import tkinter as tk
from tkinter import filedialog, scrolledtext
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

# ── Walk dependency graph depth-first, return ordered module list ─────────
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
                return f"__DARKLUA_BUNDLE_MODULES.{path_to_key[dp]}()"
            return m.group(0)   # external require, keep unchanged
        return REQUIRE_RE.sub(rep, source)

    log("\nBuilding bundle...")
    out = ["local __DARKLUA_BUNDLE_MODULES = {cache = {}}\n\ndo\n"]

    for req_str, abs_path, source in modules:
        key = path_to_key[abs_path]
        rw  = rewrite(source, abs_path)
        # strip runtime package.path manipulation - not needed in bundled form
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
        out.append(f"        function __DARKLUA_BUNDLE_MODULES.{key}()\n")
        out.append(f"            local v = __DARKLUA_BUNDLE_MODULES.cache.{key}\n")
        out.append(    "            if not v then\n")
        out.append(    "                v = { c = __modImpl() }\n")
        out.append(f"                __DARKLUA_BUNDLE_MODULES.cache.{key} = v\n")
        out.append(    "            end\n")
        out.append(    "            return v.c\n")
        out.append(    "        end\n")
        out.append(    "    end\n")

    entry_key = path_to_key[entry_file]
    out.append(f"end\n\nreturn __DARKLUA_BUNDLE_MODULES.{entry_key}()\n")

    with open(output_file, "w", encoding="utf-8") as f:
        f.write("".join(out))

    kb = os.path.getsize(output_file) / 1024
    log(f"\n✓ Done!  {kb:.1f} KB  |  {len(modules)} modules  →  {output_file}")

# ── GUI ───────────────────────────────────────────────────────────────────
class App:
    def __init__(self, root):
        self.root = root
        root.title("ZukaTech Bundler")
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

        MONO  = ("Consolas", 10)
        LABEL = ("Segoe UI", 9)
        BOLD  = ("Segoe UI", 9, "bold")

        # ── header
        hdr = tk.Frame(root, bg=BG, padx=20, pady=14)
        hdr.pack(fill="x")
        tk.Label(hdr, text="⬡ ZUKATECH", font=("Consolas", 16, "bold"),
                 bg=BG, fg=ACCENT).pack(side="left")
        tk.Label(hdr, text=" BUNDLER", font=("Consolas", 16),
                 bg=BG, fg=TEXT).pack(side="left")
        tk.Label(hdr, text="v1.0", font=("Consolas", 9),
                 bg=BG, fg=MUTED).pack(side="left", padx=(8,0), pady=(5,0))

        tk.Frame(root, bg=BORDER, height=1).pack(fill="x", padx=20)

        # ── path fields
        form = tk.Frame(root, bg=BG, padx=20, pady=16)
        form.pack(fill="x")
        form.columnconfigure(1, weight=1)

        self.entry_var  = tk.StringVar()
        self.src_var    = tk.StringVar()
        self.output_var = tk.StringVar()

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

        field("Entry File",  0, self.entry_var,  self.pick_entry)
        field("Src Folder",  1, self.src_var,    self.pick_src)
        field("Output File", 2, self.output_var, self.pick_output)

        tk.Frame(root, bg=BORDER, height=1).pack(fill="x", padx=20)

        # ── log box
        log_wrap = tk.Frame(root, bg=BG, padx=20, pady=12)
        log_wrap.pack(fill="both", expand=True)
        tk.Label(log_wrap, text="LOG", font=("Consolas", 8, "bold"),
                 bg=BG, fg=MUTED).pack(anchor="w", pady=(0,4))
        self.log = scrolledtext.ScrolledText(
            log_wrap, font=MONO, bg=PANEL, fg=TEXT,
            relief="flat", bd=0, height=16, width=74,
            state="disabled", insertbackground=ACCENT,
            selectbackground="#2a4a3a"
        )
        self.log.pack(fill="both", expand=True)
        self.log.tag_config("ok",   foreground=ACCENT)
        self.log.tag_config("err",  foreground=RED)
        self.log.tag_config("info", foreground=BLUE)
        self.log.tag_config("dim",  foreground=MUTED)

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

    def pick_entry(self):
        p = filedialog.askopenfilename(filetypes=[("Lua files", "*.lua")])
        if not p: return
        self.entry_var.set(p)
        if not self.src_var.get():
            self.src_var.set(os.path.dirname(p))
        if not self.output_var.get():
            self.output_var.set(
                os.path.join(os.path.dirname(os.path.dirname(p)), "bundled.lua"))

    def pick_src(self):
        p = filedialog.askdirectory()
        if p: self.src_var.set(p)

    def pick_output(self):
        p = filedialog.asksaveasfilename(defaultextension=".lua",
                                          filetypes=[("Lua files", "*.lua")])
        if p: self.output_var.set(p)

    def write_log(self, msg):
        tag = "dim"
        if "✓" in msg or "Done" in msg:      tag = "ok"
        elif "ERROR" in msg or "WARN" in msg: tag = "err"
        elif "SKIP" in msg:                   tag = "err"
        elif msg.startswith(("Found","Scan","Build")): tag = "info"
        def _do():
            self.log.config(state="normal")
            self.log.insert("end", msg + "\n", tag)
            self.log.see("end")
            self.log.config(state="disabled")
        self.root.after(0, _do)

    def run(self):
        entry  = self.entry_var.get().strip()
        src    = self.src_var.get().strip()
        output = self.output_var.get().strip()

        if not entry or not os.path.isfile(entry):
            self.write_log("ERROR: Please select a valid entry .lua file.")
            return
        if not src:
            src = os.path.dirname(entry)
        if not output:
            output = os.path.join(os.path.dirname(src), "bundled.lua")

        self.log.config(state="normal")
        self.log.delete("1.0", "end")
        self.log.config(state="disabled")
        self.btn.config(state="disabled", bg="#1a1a1a", fg="#444")
        self.status.config(text="Bundling...", fg="#00c896")

        def task():
            try:
                bundle(entry, src, output, self.write_log)
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

if __name__ == "__main__":
    root = tk.Tk()
    App(root)
    root.mainloop()
