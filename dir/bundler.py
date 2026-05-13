import os, re, string, threading

# ── Key generator: a-z, A-Z, Za, Zb, ..., aa, ab, ... ────────────────────
def make_key_generator():
    chars = string.ascii_lowercase + string.ascii_uppercase
    i = [0]
    def next_key():
        n = i[0]; i[0] += 1
        if n < len(chars):
            return chars[n]
        n -= len(chars)
        prefix = chars[n // len(chars)]
        suffix = chars[n % len(chars)]
        return prefix + suffix
    return next_key

# ── Resolve require("X.Y.Z") to an absolute file path ────────────────────
def resolve_require(req_str, current_file, src_root):
    rel = req_str.replace(".", "/") + ".lua"
    c1 = os.path.normpath(os.path.join(src_root, rel))
    if os.path.isfile(c1): return c1
    c2 = os.path.normpath(os.path.join(os.path.dirname(current_file), rel))
    if os.path.isfile(c2): return c2
    return None

REQUIRE_RE = re.compile(r'require\s*\(\s*["\']([^"\']+)["\']\s*\)')

# ── Detect custom loader function name ────────────────────────────────────
def detect_custom_loader(source):
    """
    Look for a variable assigned a function that uses loadstring internally,
    e.g.: LoadFromUrl = function(x) ... loadstring(...) ... end
    Returns the loader variable name if found, else None.
    """
    m = re.search(
        r'(\w+)\s*=\s*function\s*\([^)]*\).*?loadstring.*?end',
        source, re.DOTALL
    )
    if m:
        return m.group(1)
    return None

def rewrite_custom_loaders(source, loader_name, src_root, current_file, log):
    """
    Replace: local Foo = LoadFromUrl("Foo")
    With:    local Foo = require("Foo")
    Only for modules that exist on disk — others are left untouched.
    """
    pattern = re.compile(
        r'(local\s+\w+\s*=\s*)' + re.escape(loader_name) + r'\s*\(\s*["\']([^"\']+)["\']\s*\)'
    )
    def rep(m):
        prefix   = m.group(1)
        mod_name = m.group(2)
        resolved = resolve_require(mod_name, current_file, src_root)
        if resolved:
            log(f"  [REWRITE] {loader_name}(\"{mod_name}\") → require(\"{mod_name}\")")
            return f'{prefix}require("{mod_name}")'
        else:
            log(f"  [SKIP] {loader_name}(\"{mod_name}\") — not on disk, left as-is")
            return m.group(0)
    return pattern.sub(rep, source)

def strip_loader_definition(source, loader_name):
    """
    Remove the loader function definition (and surrounding if/else block)
    from the source so it doesn't end up in the bundle.
    """
    if not loader_name:
        return source
    # Remove: local LoaderName \n ... LoaderName = function ... end (with if/else wrapping)
    source = re.sub(
        r'local\s+' + re.escape(loader_name) + r'\s*\n.*?' +
        re.escape(loader_name) + r'\s*=\s*function.*?^end\b',
        '', source, flags=re.DOTALL | re.MULTILINE
    )
    # Also catch bare assignment form
    source = re.sub(
        re.escape(loader_name) + r'\s*=\s*function\s*\([^)]*\).*?^end\b.*?\n',
        '', source, flags=re.DOTALL | re.MULTILINE
    )
    return source

# ── Auto-detect root modules (never required by anything else) ────────────
def find_root_modules(src_root, log):
    lua_files = {}
    for fname in os.listdir(src_root):
        if fname.endswith(".lua") and fname != "__entry__.lua":
            base = fname[:-4]
            lua_files[base] = os.path.join(src_root, fname)

    required_by_others = set()
    for base, path in lua_files.items():
        try:
            with open(path, "r", encoding="utf-8") as f:
                source = f.read()
        except Exception:
            continue

        # Standard requires
        for dep in REQUIRE_RE.findall(source):
            dep_base = dep.split(".")[-1]
            if dep_base in lua_files:
                required_by_others.add(dep_base)

        # Custom loader calls
        loader = detect_custom_loader(source)
        if loader:
            custom_pat = re.compile(
                re.escape(loader) + r'\s*\(\s*["\']([^"\']+)["\']\s*\)'
            )
            for dep in custom_pat.findall(source):
                dep_base = dep.split(".")[-1]
                if dep_base in lua_files:
                    required_by_others.add(dep_base)

    roots = [(base, path) for base, path in lua_files.items()
             if base not in required_by_others]
    log(f"  Found {len(roots)} root module(s): {', '.join(r[0] for r in roots)}")
    return roots

# ── Generate a synthetic entry file ───────────────────────────────────────
def generate_entry_file(src_root, log):
    roots = find_root_modules(src_root, log)
    if not roots:
        log("  [WARN] No roots found — treating all files as roots.")
        roots = [(os.path.splitext(f)[0], os.path.join(src_root, f))
                 for f in os.listdir(src_root) if f.endswith(".lua")]

    lines = ["-- Auto-generated entry file\n"]
    names = []
    for base, _ in roots:
        var = re.sub(r'\W', '_', base)
        lines.append(f'local {var} = require("{base}")\n')
        names.append(var)

    if len(names) == 1:
        lines.append(f"\nreturn {names[0]}\n")
    else:
        lines.append("\nreturn {\n")
        for name in names:
            lines.append(f"    {name} = {name},\n")
        lines.append("}\n")

    entry_path = os.path.join(src_root, "__entry__.lua")
    with open(entry_path, "w", encoding="utf-8") as f:
        f.writelines(lines)

    log(f"  Generated: {entry_path}")
    return entry_path

# ── Walk dependency graph depth-first ────────────────────────────────────
def collect_modules(entry_file, src_root, log):
    visited = {}
    order   = []

    def walk(req_str, abs_path):
        if abs_path in visited: return
        visited[abs_path] = True
        try:
            with open(abs_path, "r", encoding="utf-8") as f:
                source = f.read()
        except Exception as e:
            log(f"  [WARN] Could not read {abs_path}: {e}")
            return

        # Detect and rewrite any custom loader before scanning deps
        loader_name = detect_custom_loader(source)
        if loader_name:
            log(f"  [DETECT] Custom loader '{loader_name}' in {os.path.basename(abs_path)}")
            source = rewrite_custom_loaders(source, loader_name, src_root, abs_path, log)
            source = strip_loader_definition(source, loader_name)

        for dep in REQUIRE_RE.findall(source):
            dp = resolve_require(dep, abs_path, src_root)
            if dp: walk(dep, dp)
            else:  log(f"  [SKIP] {dep} (external, left as-is)")

        order.append((req_str, abs_path, source))

    walk("__entry__", entry_file)
    return order

# ── Core bundle function ──────────────────────────────────────────────────
def bundle(entry_file, src_root, output_file, log):
    log("Scanning dependency graph...")
    modules = collect_modules(entry_file, src_root, log)
    log(f"Found {len(modules)} modules.\n")

    next_key    = make_key_generator()
    path_to_key = {}

    for req_str, abs_path, _ in modules:
        k = next_key()
        path_to_key[abs_path] = k
        log(f"  [{k:>3}]  {req_str}")

    def rewrite(source, cur_path):
        def rep(m):
            dp = resolve_require(m.group(1), cur_path, src_root)
            if dp and dp in path_to_key:
                return f"__BUNDLE_MODULES.{path_to_key[dp]}()"
            return m.group(0)
        return REQUIRE_RE.sub(rep, source)

    log("\nBuilding bundle...")
    out = ["local __BUNDLE_MODULES = {cache = {}}\n\ndo\n"]

    for req_str, abs_path, source in modules:
        key = path_to_key[abs_path]
        rw  = rewrite(source, abs_path)
        rw = re.sub(
            r'local function script_path\(\).*?package\.path\s*=\s*[^\n]+\n',
            '', rw, flags=re.DOTALL
        )
        rw = re.sub(r'package\.path\s*=\s*oldPkgPath\s*;?\s*\n?', '', rw)

        out.append(    "    do\n")
        out.append(    "        local function __modImpl()\n")
        for line in rw.splitlines():
            out.append(f"            {line}\n")
        out.append(    "        end\n\n")
        out.append(f"        function __BUNDLE_MODULES.{key}()\n")
        out.append(f"            local v = __BUNDLE_MODULES.cache.{key}\n")
        out.append(    "            if not v then\n")
        out.append(    "                v = { c = __modImpl() }\n")
        out.append(f"                __BUNDLE_MODULES.cache.{key} = v\n")
        out.append(    "            end\n")
        out.append(    "            return v.c\n")
        out.append(    "        end\n")
        out.append(    "    end\n")

    entry_key = path_to_key[entry_file]
    out.append(f"""end

__BUNDLE_MODULES.{entry_key}()
""")

    with open(output_file, "w", encoding="utf-8") as f:
        f.write("".join(out))

    kb = os.path.getsize(output_file) / 1024
    log(f"\n✓ Done!  {kb:.1f} KB  |  {len(modules)} modules  →  {output_file}")

# ── GUI ───────────────────────────────────────────────────────────────────
class App:
    def __init__(self, root):
        import tkinter as tk
        from tkinter import filedialog, scrolledtext
        self._tk = tk
        self._filedialog = filedialog
        self._scrolledtext = scrolledtext
        self.root = root
        root.title("Lua Bundler")
        root.resizable(False, False)
        root.configure(bg="#0d0d0d")

        BG     = "#0d0d0d"
        PANEL  = "#161616"
        BORDER = "#252525"
        ACCENT = "#00c896"
        TEXT   = "#d8d8d8"
        MUTED  = "#4a4a4a"
        RED    = "#ff4f4f"
        BLUE   = "#4fa3ff"
        YELLOW = "#f0c060"

        MONO  = ("Consolas", 10)
        LABEL = ("Segoe UI", 9)
        BOLD  = ("Segoe UI", 9, "bold")

        # ── header
        hdr = tk.Frame(root, bg=BG, padx=20, pady=14)
        hdr.pack(fill="x")
        tk.Label(hdr, text="⬡ LUA", font=("Consolas", 16, "bold"),
                 bg=BG, fg=ACCENT).pack(side="left")
        tk.Label(hdr, text=" BUNDLER", font=("Consolas", 16),
                 bg=BG, fg=TEXT).pack(side="left")
        tk.Label(hdr, text="v2.0", font=("Consolas", 9),
                 bg=BG, fg=MUTED).pack(side="left", padx=(8,0), pady=(5,0))

        tk.Frame(root, bg=BORDER, height=1).pack(fill="x", padx=20)

        # ── path fields
        form = tk.Frame(root, bg=BG, padx=20, pady=16)
        form.pack(fill="x")
        form.columnconfigure(1, weight=1)

        self.entry_var  = tk.StringVar()
        self.src_var    = tk.StringVar()
        self.output_var = tk.StringVar()
        self.auto_entry = tk.BooleanVar(value=False)

        def field(label, row, var, browse_cmd):
            tk.Label(form, text=label, font=LABEL, bg=BG, fg=MUTED,
                     anchor="w", width=11).grid(row=row, column=0, sticky="w", pady=5)
            wrap = tk.Frame(form, bg=PANEL, highlightbackground=BORDER,
                            highlightthickness=1)
            wrap.grid(row=row, column=1, sticky="ew", padx=(8,0), pady=5)
            e = tk.Entry(wrap, textvariable=var, font=MONO, bg=PANEL, fg=TEXT,
                         insertbackground=ACCENT, relief="flat", bd=6)
            e.pack(side="left", fill="x", expand=True)
            tk.Button(wrap, text="…", font=BOLD, command=browse_cmd,
                      bg=BORDER, fg=TEXT, relief="flat", padx=10,
                      cursor="hand2", activebackground=ACCENT,
                      activeforeground="#000").pack(side="right")
            return e

        self._entry_widget = field("Entry File",  0, self.entry_var,  self.pick_entry)
        field("Src Folder",  1, self.src_var,    self.pick_src)
        field("Output File", 2, self.output_var, self.pick_output)

        # ── auto-entry toggle
        chk_row = tk.Frame(form, bg=BG)
        chk_row.grid(row=3, column=1, sticky="w", padx=(8,0), pady=(0,4))
        tk.Checkbutton(
            chk_row,
            text="Auto-detect entry  ",
            variable=self.auto_entry,
            command=self.toggle_auto_entry,
            font=LABEL, bg=BG, fg=MUTED,
            selectcolor=PANEL, activebackground=BG,
            activeforeground=ACCENT,
            highlightthickness=0, bd=0, cursor="hand2"
        ).pack(side="left")
        tk.Label(chk_row,
                 text="scans src folder for root modules and generates entry automatically",
                 font=("Segoe UI", 8), bg=BG, fg=MUTED).pack(side="left")

        tk.Frame(root, bg=BORDER, height=1).pack(fill="x", padx=20)

        # ── log
        log_wrap = tk.Frame(root, bg=BG, padx=20, pady=12)
        log_wrap.pack(fill="both", expand=True)
        tk.Label(log_wrap, text="LOG", font=("Consolas", 8, "bold"),
                 bg=BG, fg=MUTED).pack(anchor="w", pady=(0,4))
        self.log_box = scrolledtext.ScrolledText(
            log_wrap, font=MONO, bg=PANEL, fg=TEXT,
            relief="flat", bd=0, height=16, width=74,
            state="disabled", insertbackground=ACCENT,
            selectbackground="#2a4a3a"
        )
        self.log_box.pack(fill="both", expand=True)
        self.log_box.tag_config("ok",      foreground=ACCENT)
        self.log_box.tag_config("err",     foreground=RED)
        self.log_box.tag_config("info",    foreground=BLUE)
        self.log_box.tag_config("dim",     foreground=MUTED)
        self.log_box.tag_config("rewrite", foreground=YELLOW)

        # ── bottom bar
        bar = tk.Frame(root, bg=PANEL, padx=20, pady=10)
        bar.pack(fill="x")
        self.status = tk.Label(bar, text="Ready.", font=LABEL,
                               bg=PANEL, fg=MUTED, anchor="w")
        self.status.pack(side="left")
        self.btn = tk.Button(bar, text="  BUNDLE  ", font=BOLD,
                             command=self.run, bg=ACCENT, fg="#000",
                             relief="flat", padx=14, pady=6, cursor="hand2",
                             activebackground="#00a87e", activeforeground="#000")
        self.btn.pack(side="right")
        root.bind("<Return>", lambda _: self.run())

    def toggle_auto_entry(self):
        if self.auto_entry.get():
            self._entry_widget.config(state="disabled", fg="#444444")
            self.entry_var.set("")
        else:
            self._entry_widget.config(state="normal", fg="#d8d8d8")

    def pick_entry(self):
        filedialog = self._filedialog
        p = filedialog.askopenfilename(filetypes=[("Lua files", "*.lua")])
        if not p: return
        self.entry_var.set(p)
        self.auto_entry.set(False)
        self.toggle_auto_entry()
        if not self.src_var.get():
            self.src_var.set(os.path.dirname(p))
        if not self.output_var.get():
            self.output_var.set(
                os.path.join(os.path.dirname(os.path.dirname(p)), "bundled.lua"))

    def pick_src(self):
        filedialog = self._filedialog
        p = filedialog.askdirectory()
        if not p: return
        self.src_var.set(p)
        if not self.output_var.get():
            self.output_var.set(os.path.join(os.path.dirname(p), "bundled.lua"))

    def pick_output(self):
        filedialog = self._filedialog
        p = filedialog.asksaveasfilename(defaultextension=".lua",
                                          filetypes=[("Lua files", "*.lua")])
        if p: self.output_var.set(p)

    def write_log(self, msg):
        tag = "dim"
        if "✓" in msg or "Done" in msg:                  tag = "ok"
        elif "ERROR" in msg or "WARN" in msg:             tag = "err"
        elif "SKIP" in msg:                               tag = "err"
        elif "REWRITE" in msg or "DETECT" in msg:         tag = "rewrite"
        elif msg.startswith(("Found","Scan","Build",
                             "Auto","Generat")):           tag = "info"
        def _do():
            self.log_box.config(state="normal")
            self.log_box.insert("end", msg + "\n", tag)
            self.log_box.see("end")
            self.log_box.config(state="disabled")
        self.root.after(0, _do)

    def run(self):
        src      = self.src_var.get().strip()
        output   = self.output_var.get().strip()
        use_auto = self.auto_entry.get()
        entry    = self.entry_var.get().strip()

        if not src or not os.path.isdir(src):
            self.write_log("ERROR: Please select a valid Src Folder.")
            return
        if not output:
            output = os.path.join(os.path.dirname(src), "bundled.lua")
        if not use_auto and (not entry or not os.path.isfile(entry)):
            self.write_log("ERROR: Select an Entry File or enable Auto-detect.")
            return

        self.log_box.config(state="normal")
        self.log_box.delete("1.0", "end")
        self.log_box.config(state="disabled")
        self.btn.config(state="disabled", bg="#1a1a1a", fg="#444")
        self.status.config(text="Bundling...", fg="#00c896")

        def task():
            try:
                actual_entry = entry
                if use_auto:
                    self.write_log("Auto-detecting root modules...")
                    actual_entry = generate_entry_file(src, self.write_log)
                    self.write_log("")
                bundle(actual_entry, src, output, self.write_log)
                self.root.after(0, lambda: self.status.config(text="Done!", fg="#00c896"))
            except Exception as ex:
                import traceback
                self.write_log(f"ERROR: {ex}")
                self.write_log(traceback.format_exc())
                self.root.after(0, lambda: self.status.config(text="Failed.", fg="#ff4f4f"))
            finally:
                self.root.after(0, lambda: self.btn.config(
                    state="normal", bg="#00c896", fg="#000"))

        threading.Thread(target=task, daemon=True).start()

# ── CLI ───────────────────────────────────────────────────────────────────
def cli_main():
    import argparse, sys

    parser = argparse.ArgumentParser(
        prog="bundler",
        description="Bundle a multi-file Lua project into a single file.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # explicit entry file
  python bundler.py src/ -e src/main.lua -o bundled.lua

  # auto-detect entry (scans src/ for root modules)
  python bundler.py src/ --auto -o bundled.lua

  # auto output name (saves next to src/ as bundled.lua)
  python bundler.py src/ --auto
        """
    )
    parser.add_argument(
        "src",
        metavar="SRC_FOLDER",
        help="Folder containing your .lua source files"
    )
    parser.add_argument(
        "-e", "--entry",
        metavar="FILE",
        help="Entry .lua file (required unless --auto is used)"
    )
    parser.add_argument(
        "-o", "--output",
        metavar="FILE",
        help="Output .lua file (default: <parent of SRC>/bundled.lua)"
    )
    parser.add_argument(
        "--auto",
        action="store_true",
        help="Auto-detect root modules and generate an entry file"
    )
    parser.add_argument(
        "--gui",
        action="store_true",
        help="Force the GUI to open even when other flags are present"
    )

    args = parser.parse_args()

    # --gui flag: fall through to GUI launch below
    if args.gui:
        return False  # signal: open GUI

    # ── validate src
    src = os.path.normpath(args.src)
    if not os.path.isdir(src):
        print(f"Error: '{src}' is not a directory.", file=sys.stderr)
        sys.exit(1)

    # ── resolve output
    output = args.output or os.path.join(os.path.dirname(src), "bundled.lua")

    # ── resolve entry
    if args.auto:
        print("Auto-detecting root modules...")
        entry = generate_entry_file(src, print)
        print()
    else:
        if not args.entry:
            parser.error("Provide --entry <file> or use --auto.")
        entry = os.path.normpath(args.entry)
        if not os.path.isfile(entry):
            print(f"Error: entry file '{entry}' not found.", file=sys.stderr)
            sys.exit(1)

    # ── run
    try:
        bundle(entry, src, output, print)
    except Exception as ex:
        import traceback
        print(f"\nError: {ex}", file=sys.stderr)
        traceback.print_exc()
        sys.exit(1)

    return True  # signal: CLI handled, don't open GUI


if __name__ == "__main__":
    import sys

    # If no args at all, or explicit --gui: open the GUI
    # Otherwise try CLI first; it exits on success/failure so GUI never opens
    no_args = len(sys.argv) == 1
    force_gui = "--gui" in sys.argv

    if no_args or force_gui:
        import tkinter as tk
        root = tk.Tk()
        App(root)
        root.mainloop()
    else:
        cli_main()
