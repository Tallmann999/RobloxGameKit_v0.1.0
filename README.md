# RobloxGameKit

AI-first modular starter kit for Roblox projects using **Codex + Roblox Studio MCP + Rojo + Git**.

The kit is deliberately split into:

- `templates/game/` — minimal files every new Roblox project receives.
- `modules/` — reusable installable modules and blueprints.
- `scripts/` — bootstrapping/import helpers.
- `docs/` — workflow, architecture, module catalog, and Codex prompts.

## Design goals

1. Roblox Studio owns world building and visual scene editing.
2. The filesystem/Git owns code and project documentation.
3. Rojo syncs only dedicated code containers by default; it does **not** own Workspace.
4. The server is authoritative for game state, rewards, progression, purchases, and persistence.
5. World objects are connected to systems primarily by Tags + Attributes, not copied scripts.
6. New games install only the modules required by their MVP.
7. Codex must inspect, plan, implement, playtest, inspect Output, fix, and retest.
8. If Codex cannot perform a required manual Studio/account/auth step, it must stop and give the user exact numbered instructions, then continue after the user says it is done.

## First-time use

Read:

1. `docs/WORKFLOW_RU.md`
2. `docs/MODULE_CATALOG.md`
3. `docs/CODEX_MASTER_INSTRUCTION_RU.md`

## Quick local bootstrap

From a cloned RobloxGameKit repository:

```powershell
python scripts/bootstrap_game.py --target "D:\\Roblox\\MyGame" --modules core network tags
```

The script copies the base template, resolves module dependencies, installs ready modules, and writes `robloxgamekit.lock.json`.

Blueprint modules are intentionally not auto-installed: Codex reads their `BLUEPRINT.md` and implements them only if the current game needs them.
