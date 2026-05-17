// ==UserScript==
// @name         C.AI RP Paraphraser
// @namespace    http://tampermonkey.net/
// @version      2.0
// @description  Paraphrase your RP dialogue on character.ai with persona support
// @author       You
// @match        https://character.ai/*
// @match        https://www.character.ai/*
// @grant        GM_xmlhttpRequest
// @grant        GM_addStyle
// @grant        GM_getValue
// @grant        GM_setValue
// @connect      api.anthropic.com
// ==/UserScript==

(function () {
    'use strict';

    // ─── CONFIG ────────────────────────────────────────────────────────────────
    const API_KEY = '';
    const MODEL   = 'claude-sonnet-4-20250514';

    // ─── DEFAULT PERSONAS ──────────────────────────────────────────────────────
    // Junko is pre-loaded. Add more from the UI or edit the list below.
    const SEED_PERSONAS = [
        {
            id: 'none',
            name: 'No Persona',
            description: '',
        },
        {
            id: 'junko',
            name: 'Junko Enoshima',
            description: `You are writing dialogue for Junko Enoshima from Danganronpa.
Junko is chaotic, theatrical, and completely obsessed with despair — she finds it beautiful, exciting, and intoxicating.
Her mood shifts rapidly and without warning: one sentence she is bubbly and girlish, the next she is coldly menacing and calculating.
She is self-aware, manipulative, and treats everything like a performance for an audience.
Her speech is energetic and over-the-top: she loves dramatic monologues, dark humor, rhetorical questions, and italics-style emphasis.
She frequently references "despair" as something to be savored. She uses exclamations, trailing ellipses for suspense, and dramatic gasps or reactions mid-sentence (e.g. *gasps*, *claps hands*).
She never speaks plainly — everything is embellished, theatrical, and laced with menace or manic glee.
Do NOT soften her personality. She should feel unpredictable and unhinged, but articulate.`,
        },
    ];

    // Persist personas across sessions
    let personas = GM_getValue('rp_personas_v2', null);
    if (!personas) {
        personas = SEED_PERSONAS;
        GM_setValue('rp_personas_v2', personas);
    }
    let activePersonaId = GM_getValue('rp_active_persona', 'junko');

    // ─── TONES ─────────────────────────────────────────────────────────────────
    const TONES = [
        { label: '🗡️ Dramatic',   value: 'dramatic and intense, rich with emotion and gravitas' },
        { label: '🌹 Romantic',   value: 'romantic and poetic, tender and expressive' },
        { label: '😏 Witty',      value: 'witty and sharp, clever with a dry edge' },
        { label: '🌑 Dark',       value: 'dark and brooding, ominous and atmospheric' },
        { label: '⚔️ Heroic',     value: 'heroic and noble, bold and resolute' },
        { label: '🎭 Theatrical', value: 'theatrical and over-the-top, vivid and expressive' },
        { label: '🌀 Unhinged',   value: 'chaotic and unpredictable, manic energy with sharp wit' },
    ];

    // ─── STYLES ────────────────────────────────────────────────────────────────
    GM_addStyle(`
        #rp-paraphraser {
            position: fixed;
            bottom: 90px;
            right: 20px;
            width: 370px;
            background: #0f0f13;
            border: 1px solid #2a2a3a;
            border-radius: 14px;
            box-shadow: 0 8px 40px rgba(0,0,0,0.6), 0 0 0 1px rgba(120,80,255,0.15);
            font-family: 'Segoe UI', system-ui, sans-serif;
            color: #e0dff5;
            z-index: 99999;
            overflow: hidden;
            transition: all 0.25s ease;
        }
        #rp-paraphraser.collapsed { height: 48px; }
        #rp-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 16px;
            background: linear-gradient(90deg, #1a1030, #0f0f1a);
            cursor: pointer;
            user-select: none;
            border-bottom: 1px solid #2a2a3a;
        }
        #rp-header span { font-size: 13px; font-weight: 600; letter-spacing: 0.03em; color: #c4b5fd; }
        #rp-toggle-btn { background: none; border: none; color: #c4b5fd; font-size: 16px; cursor: pointer; padding: 0; }
        #rp-body {
            padding: 14px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            max-height: 80vh;
            overflow-y: auto;
        }
        #rp-paraphraser.collapsed #rp-body { display: none; }
        #rp-body::-webkit-scrollbar { width: 4px; }
        #rp-body::-webkit-scrollbar-track { background: transparent; }
        #rp-body::-webkit-scrollbar-thumb { background: #3a3550; border-radius: 4px; }

        .rp-section-label {
            font-size: 10.5px;
            color: #5a5878;
            text-transform: uppercase;
            letter-spacing: 0.09em;
            margin-bottom: -4px;
        }

        /* PERSONAS */
        #rp-persona-list { display: flex; flex-wrap: wrap; gap: 6px; }
        .rp-persona-chip {
            background: #1a1728;
            border: 1px solid #312d4a;
            border-radius: 20px;
            color: #b0a8d8;
            font-size: 12px;
            padding: 4px 11px;
            cursor: pointer;
            transition: all 0.15s;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .rp-persona-chip:hover { background: #241f3a; border-color: #7c5cfc; color: #e0dff5; }
        .rp-persona-chip.active {
            background: #2a1f4a;
            border-color: #a78bfa;
            color: #e9d5ff;
            box-shadow: 0 0 8px rgba(167,139,250,0.2);
        }
        .rp-persona-chip .pdot {
            width: 5px; height: 5px;
            border-radius: 50%;
            background: #4a4768;
            flex-shrink: 0;
        }
        .rp-persona-chip.active .pdot { background: #a78bfa; }
        .rp-persona-chip .pedit { font-size: 10px; opacity: 0.4; margin-left: 2px; transition: opacity 0.1s; }
        .rp-persona-chip:hover .pedit { opacity: 1; }
        #rp-add-persona-btn {
            background: none;
            border: 1px dashed #2e2a44;
            border-radius: 20px;
            color: #5a5878;
            font-size: 12px;
            padding: 4px 11px;
            cursor: pointer;
            transition: all 0.15s;
        }
        #rp-add-persona-btn:hover { border-color: #7c5cfc; color: #a78bfa; }
        #rp-persona-preview {
            font-size: 11.5px;
            color: #5a5878;
            font-style: italic;
            line-height: 1.55;
            display: none;
            background: #14121e;
            border-left: 2px solid #3a3550;
            padding: 6px 10px;
            border-radius: 0 6px 6px 0;
        }
        #rp-persona-preview.visible { display: block; }

        /* INPUT / OUTPUT */
        #rp-input, #rp-output {
            width: 100%;
            box-sizing: border-box;
            background: #17171f;
            border: 1px solid #2e2e42;
            border-radius: 8px;
            color: #e0dff5;
            font-size: 13px;
            line-height: 1.6;
            padding: 10px 12px;
            resize: vertical;
            min-height: 80px;
            outline: none;
            transition: border-color 0.2s;
            font-family: inherit;
        }
        #rp-input:focus, #rp-output:focus { border-color: #7c5cfc; }
        #rp-output { color: #a78bfa; min-height: 60px; cursor: text; }

        /* TONES */
        #rp-tones { display: flex; flex-wrap: wrap; gap: 6px; }
        .rp-tone-btn {
            background: #1e1b30;
            border: 1px solid #3a3550;
            border-radius: 20px;
            color: #c4b5fd;
            font-size: 11.5px;
            padding: 4px 10px;
            cursor: pointer;
            transition: all 0.15s;
        }
        .rp-tone-btn:hover { background: #2d2850; border-color: #7c5cfc; }
        .rp-tone-btn.active { background: #4c2fad; border-color: #7c5cfc; color: #fff; }

        /* ACTIONS */
        #rp-actions { display: flex; gap: 8px; }
        #rp-go-btn {
            flex: 1;
            padding: 9px;
            background: linear-gradient(135deg, #5b21b6, #7c3aed);
            border: none;
            border-radius: 8px;
            color: #fff;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.2s, transform 0.1s;
        }
        #rp-go-btn:hover { opacity: 0.9; }
        #rp-go-btn:active { transform: scale(0.98); }
        #rp-go-btn:disabled { opacity: 0.5; cursor: not-allowed; }
        #rp-copy-btn, #rp-paste-btn {
            padding: 9px 13px;
            background: #1e1b30;
            border: 1px solid #3a3550;
            border-radius: 8px;
            color: #c4b5fd;
            font-size: 13px;
            cursor: pointer;
            transition: background 0.15s;
        }
        #rp-copy-btn:hover, #rp-paste-btn:hover { background: #2d2850; }
        #rp-grab-btn {
            width: 100%;
            padding: 7px;
            background: #1a1a28;
            border: 1px dashed #3a3550;
            border-radius: 8px;
            color: #7c6fb0;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.15s;
        }
        #rp-grab-btn:hover { border-color: #7c5cfc; color: #c4b5fd; background: #1e1b30; }

        /* STATUS */
        #rp-status { font-size: 11px; color: #6b6a8a; text-align: center; min-height: 16px; }
        #rp-status.error { color: #f87171; }
        #rp-status.ok    { color: #86efac; }

        /* MODAL */
        #rp-modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.75);
            z-index: 100001;
            align-items: center;
            justify-content: center;
        }
        #rp-modal-overlay.open { display: flex; }
        #rp-modal {
            background: #12111c;
            border: 1px solid #2e2e42;
            border-radius: 14px;
            padding: 20px;
            width: 330px;
            box-shadow: 0 16px 60px rgba(0,0,0,0.9);
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        #rp-modal h3 { margin: 0; font-size: 14px; color: #c4b5fd; font-weight: 600; }
        .rp-field { display: flex; flex-direction: column; gap: 4px; }
        .rp-field label { font-size: 11px; color: #6b6a8a; text-transform: uppercase; letter-spacing: 0.06em; }
        .rp-field input, .rp-field textarea {
            background: #1a1728;
            border: 1px solid #2e2e42;
            border-radius: 7px;
            color: #e0dff5;
            font-size: 13px;
            padding: 8px 10px;
            outline: none;
            font-family: inherit;
            transition: border-color 0.15s;
            resize: vertical;
            box-sizing: border-box;
            width: 100%;
        }
        .rp-field input:focus, .rp-field textarea:focus { border-color: #7c5cfc; }
        .rp-field textarea { min-height: 110px; }
        .rp-field small { font-size: 11px; color: #4a4768; }
        #rp-modal-btns { display: flex; gap: 8px; flex-wrap: wrap; }
        #rp-modal-save {
            flex: 1; padding: 8px;
            background: linear-gradient(135deg, #5b21b6, #7c3aed);
            border: none; border-radius: 8px;
            color: #fff; font-size: 13px; font-weight: 600; cursor: pointer;
        }
        #rp-modal-delete {
            padding: 8px 12px;
            background: #1f1020; border: 1px solid #4a1530;
            border-radius: 8px; color: #f87171; font-size: 13px; cursor: pointer;
        }
        #rp-modal-cancel {
            padding: 8px 12px;
            background: #1e1b30; border: 1px solid #3a3550;
            border-radius: 8px; color: #9d96c8; font-size: 13px; cursor: pointer;
        }
    `);

    // ─── BUILD PANEL ───────────────────────────────────────────────────────────
    const panel = document.createElement('div');
    panel.id = 'rp-paraphraser';
    panel.innerHTML = `
        <div id="rp-header">
            <span>✦ RP Paraphraser</span>
            <button id="rp-toggle-btn">▼</button>
        </div>
        <div id="rp-body">
            <div class="rp-section-label">Persona</div>
            <div id="rp-persona-list"></div>
            <div id="rp-persona-preview"></div>

            <div class="rp-section-label">Tone</div>
            <div id="rp-tones"></div>

            <button id="rp-grab-btn">⇡ Grab text from chat input</button>
            <textarea id="rp-input" placeholder="Paste or type your dialogue here..."></textarea>

            <div id="rp-actions">
                <button id="rp-go-btn">✦ Paraphrase</button>
                <button id="rp-copy-btn" title="Copy result">⎘ Copy</button>
                <button id="rp-paste-btn" title="Paste into chat">⇣ Paste</button>
            </div>

            <div id="rp-output" contenteditable="true" spellcheck="false"></div>
            <div id="rp-status"></div>
        </div>
    `;
    document.body.appendChild(panel);

    // ─── BUILD MODAL ───────────────────────────────────────────────────────────
    const modal = document.createElement('div');
    modal.id = 'rp-modal-overlay';
    modal.innerHTML = `
        <div id="rp-modal">
            <h3 id="rp-modal-title">Add Persona</h3>
            <div class="rp-field">
                <label>Persona Name</label>
                <input id="rp-modal-name" placeholder="e.g. Junko Enoshima" />
            </div>
            <div class="rp-field">
                <label>How do they speak?</label>
                <textarea id="rp-modal-desc" placeholder="Describe their personality, speech style, quirks, catchphrases, mannerisms..."></textarea>
                <small>More detail = more accurate paraphrase.</small>
            </div>
            <div id="rp-modal-btns">
                <button id="rp-modal-save">Save</button>
                <button id="rp-modal-delete" style="display:none">Delete</button>
                <button id="rp-modal-cancel">Cancel</button>
            </div>
        </div>
    `;
    document.body.appendChild(modal);

    // ─── REFS ──────────────────────────────────────────────────────────────────
    const inputEl    = panel.querySelector('#rp-input');
    const outputEl   = panel.querySelector('#rp-output');
    const statusEl   = panel.querySelector('#rp-status');
    const goBtn      = panel.querySelector('#rp-go-btn');
    const personaList= panel.querySelector('#rp-persona-list');
    const preview    = panel.querySelector('#rp-persona-preview');
    const tonesEl    = panel.querySelector('#rp-tones');
    let activeTone   = TONES[0];
    let editingId    = null;

    function setStatus(msg, type = '') {
        statusEl.textContent = msg;
        statusEl.className = type;
    }

    // ─── RENDER PERSONAS ───────────────────────────────────────────────────────
    function renderPersonas() {
        personaList.innerHTML = '';
        personas.forEach(p => {
            const chip = document.createElement('button');
            chip.className = 'rp-persona-chip' + (p.id === activePersonaId ? ' active' : '');
            chip.innerHTML = `<span class="pdot"></span>${p.name}${p.id !== 'none' ? ' <span class="pedit">✎</span>' : ''}`;
            chip.addEventListener('click', (e) => {
                if (e.target.classList.contains('pedit')) { openModal(p.id); return; }
                activePersonaId = p.id;
                GM_setValue('rp_active_persona', activePersonaId);
                renderPersonas();
                updatePreview();
            });
            personaList.appendChild(chip);
        });
        const addBtn = document.createElement('button');
        addBtn.id = 'rp-add-persona-btn';
        addBtn.textContent = '+ Add';
        addBtn.addEventListener('click', () => openModal(null));
        personaList.appendChild(addBtn);
    }

    function updatePreview() {
        const p = personas.find(x => x.id === activePersonaId);
        if (!p || !p.description) { preview.classList.remove('visible'); return; }
        const short = p.description.length > 130 ? p.description.slice(0, 130) + '…' : p.description;
        preview.textContent = short;
        preview.classList.add('visible');
    }

    // ─── MODAL LOGIC ───────────────────────────────────────────────────────────
    function openModal(personaId) {
        editingId = personaId;
        const existing = personaId ? personas.find(p => p.id === personaId) : null;
        modal.querySelector('#rp-modal-title').textContent = existing ? 'Edit Persona' : 'New Persona';
        modal.querySelector('#rp-modal-name').value = existing ? existing.name : '';
        modal.querySelector('#rp-modal-desc').value = existing ? existing.description : '';
        modal.querySelector('#rp-modal-delete').style.display = (existing && personaId !== 'none') ? 'block' : 'none';
        modal.classList.add('open');
    }

    modal.querySelector('#rp-modal-save').addEventListener('click', () => {
        const name = modal.querySelector('#rp-modal-name').value.trim();
        const desc = modal.querySelector('#rp-modal-desc').value.trim();
        if (!name) { alert('Give the persona a name!'); return; }
        if (editingId) {
            const idx = personas.findIndex(p => p.id === editingId);
            if (idx !== -1) { personas[idx].name = name; personas[idx].description = desc; }
        } else {
            personas.push({ id: 'persona_' + Date.now(), name, description: desc });
        }
        GM_setValue('rp_personas_v2', personas);
        modal.classList.remove('open');
        renderPersonas();
        updatePreview();
    });

    modal.querySelector('#rp-modal-delete').addEventListener('click', () => {
        if (!editingId || editingId === 'none') return;
        personas = personas.filter(p => p.id !== editingId);
        if (activePersonaId === editingId) activePersonaId = 'none';
        GM_setValue('rp_personas_v2', personas);
        GM_setValue('rp_active_persona', activePersonaId);
        modal.classList.remove('open');
        renderPersonas();
        updatePreview();
    });

    modal.querySelector('#rp-modal-cancel').addEventListener('click', () => modal.classList.remove('open'));
    modal.addEventListener('click', (e) => { if (e.target === modal) modal.classList.remove('open'); });

    // ─── TONE BUTTONS ──────────────────────────────────────────────────────────
    TONES.forEach((t, i) => {
        const btn = document.createElement('button');
        btn.className = 'rp-tone-btn' + (i === 0 ? ' active' : '');
        btn.textContent = t.label;
        btn.addEventListener('click', () => {
            tonesEl.querySelectorAll('.rp-tone-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            activeTone = t;
        });
        tonesEl.appendChild(btn);
    });

    // ─── COLLAPSE ─────────────────────────────────────────────────────────────
    const toggleBtn = panel.querySelector('#rp-toggle-btn');
    panel.querySelector('#rp-header').addEventListener('click', () => {
        panel.classList.toggle('collapsed');
        toggleBtn.textContent = panel.classList.contains('collapsed') ? '▲' : '▼';
    });

    // ─── GRAB ─────────────────────────────────────────────────────────────────
    function getChatInput() {
        return (
            document.querySelector('div[contenteditable="true"][data-lexical-editor]') ||
            document.querySelector('textarea[placeholder]') ||
            document.querySelector('div[role="textbox"]')
        );
    }

    panel.querySelector('#rp-grab-btn').addEventListener('click', () => {
        const ci = getChatInput();
        if (!ci) { setStatus('Could not find chat input.', 'error'); return; }
        const text = ci.innerText || ci.value || '';
        if (!text.trim()) { setStatus('Chat input is empty.', 'error'); return; }
        inputEl.value = text.trim();
        setStatus('Grabbed! ✓', 'ok');
    });

    // ─── COPY ─────────────────────────────────────────────────────────────────
    panel.querySelector('#rp-copy-btn').addEventListener('click', () => {
        const text = outputEl.innerText.trim();
        if (!text) { setStatus('Nothing to copy.', 'error'); return; }
        navigator.clipboard.writeText(text).then(() => setStatus('Copied! ✓', 'ok'));
    });

    // ─── PASTE ────────────────────────────────────────────────────────────────
    panel.querySelector('#rp-paste-btn').addEventListener('click', () => {
        const text = outputEl.innerText.trim();
        if (!text) { setStatus('Nothing to paste.', 'error'); return; }
        const ci = getChatInput();
        if (!ci) { setStatus('Could not find chat input.', 'error'); return; }
        ci.focus();
        if (ci.tagName === 'TEXTAREA') {
            ci.value = text;
            ci.dispatchEvent(new Event('input', { bubbles: true }));
        } else {
            document.execCommand('selectAll', false, null);
            document.execCommand('insertText', false, text);
        }
        setStatus('Pasted! ✓', 'ok');
    });

    // ─── PARAPHRASE ───────────────────────────────────────────────────────────
    goBtn.addEventListener('click', () => {
        const text = inputEl.value.trim();
        if (!text) { setStatus('Enter some text first.', 'error'); return; }
        if (API_KEY === 'YOUR_ANTHROPIC_API_KEY_HERE') {
            setStatus('Add your API key in the script!', 'error'); return;
        }

        const persona = personas.find(p => p.id === activePersonaId);
        const hasPersona = persona && persona.description;

        const personaBlock = hasPersona
            ? `${persona.description}\n\n`
            : '';

        const prompt = `${personaBlock}Rewrite the following roleplay dialogue in a ${activeTone.value} style.${hasPersona ? ` Stay fully in character as described above.` : ''}
Keep the core meaning and intent intact but make it more vivid and engaging for RP.
Return ONLY the rewritten text — no commentary, no preamble, no surrounding quotation marks.

Original:
${text}`;

        goBtn.disabled = true;
        outputEl.innerText = '';
        setStatus('Paraphrasing...');

        GM_xmlhttpRequest({
            method: 'POST',
            url: 'https://api.anthropic.com/v1/messages',
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': API_KEY,
                'anthropic-version': '2023-06-01',
            },
            data: JSON.stringify({
                model: MODEL,
                max_tokens: 1024,
                messages: [{ role: 'user', content: prompt }],
            }),
            onload(res) {
                goBtn.disabled = false;
                try {
                    const data = JSON.parse(res.responseText);
                    if (data.error) { setStatus('API error: ' + data.error.message, 'error'); return; }
                    const result = data.content?.find(b => b.type === 'text')?.text?.trim();
                    if (!result) { setStatus('Empty response.', 'error'); return; }
                    outputEl.innerText = result;
                    setStatus(`Done! ✓${hasPersona ? '  [' + persona.name + ']' : ''}`, 'ok');
                } catch (e) {
                    setStatus('Failed to parse response.', 'error');
                }
            },
            onerror() {
                goBtn.disabled = false;
                setStatus('Network error. Check key / connection.', 'error');
            },
        });
    });

    // ─── INIT ─────────────────────────────────────────────────────────────────
    renderPersonas();
    updatePreview();

})();
