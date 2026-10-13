# Roblox voice idea → local MVP: two Codex skills

Source kit: https://github.com/Tallmann999/RobloxGameKit_v0.1.0
Original GD author: https://github.com/VKSpaz/gd-doc-kickoff

The original gd-doc-kickoff interviews about **one selected feature only**. It does NOT create a game concept or feature index. Our separate gd-roblox-kickoff adds those tasks and creates an MVP handoff; roblox-mvp-builder uses the handoff to create a minimal vertical slice.

## Install in Windows PowerShell

Clone or download **this branch** of RobloxGameKit, open PowerShell in that folder, then execute:

    powershell -ExecutionPolicy Bypass -File .\scripts\install_voice_mvp_skills.ps1

Installer copies both new skills to %USERPROFILE%\.agents\skills. If Git is available, it **clones the entire original gd-doc-kickoff skill** separately and copies its three interview references into gd-roblox-kickoff/references/upstream. Existing skills are backed up. It does not modify the original upstream GitHub repository or install Rojo/Studio/MCP.

Restart Codex and open an empty folder for a new game.

## One voice request

    $gd-roblox-kickoff У меня идея новой игры Roblox. Запиши концепт, индекс фичей и документ основной фичи. Выбери самое маленькое MVP. Потом используй $roblox-mvp-builder: подготовь RobloxGameKit, подключи локальную Roblox Studio через MCP и Rojo, собери прототип, проверь Play, сохрани локальный .rbxl. Без публичной публикации.

If Codex cannot use a named skill automatically, invoke the two skills one after another. Voice dictation requires a supported voice input feature of the particular Codex client or speech-to-text; the skill does not enable microphones by itself.

## Evidence

The first skill creates docs/project-concept.md, docs/feature-index.md, docs/features/F-001_core-loop_gd-spec.md, docs/mvp-handoff.md.
The second skill reads these docs and produces docs/technical-plan.md, docs/mvp-checklist.md, src/, plus a local place snapshot after an actual Studio test.

Studio visual world remains outside of Rojo-controlled code mapping. Studio MCP access and Play test are external dependencies, not promised by a Markdown skill. Do not hand out .rbxl to third parties if server source must remain private.
