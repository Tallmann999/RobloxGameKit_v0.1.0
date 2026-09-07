# RobloxGameKit Architecture

## Ownership boundary

**Roblox Studio owns by default:** Workspace, Terrain, Lighting, imported models, visual placement, and other authored world content.

**Git/Rojo owns:** `ReplicatedStorage/GameShared`, `ServerScriptService/GameServer`, and `StarterPlayer/StarterPlayerScripts/GameClient`.

This keeps existing scenes safe while giving code normal filesystem version control.

## Runtime layers

- **Shared** — config, types, constants, pure utilities, remote contracts.
- **Server Services** — authoritative state and rules.
- **Client Controllers** — input, UI, camera, local effects and presentation.

`Bootstrap.server.luau` discovers modules in `Services`, then performs deterministic `Init` and `Start` phases. `Bootstrap.client.luau` does the same for `Controllers`.

## World binding

Prefer:

- CollectionService Tags: `Interactable`, `Collectible`, `Shop`, `EnemySpawner`, etc.
- Attributes: `Id`, `Reward`, `Price`, `Cooldown`, `ItemType`, etc.

Avoid placing independent copies of business-logic scripts into every world object.

## Reuse policy

A system becomes a reusable RobloxGameKit implementation only after it has proven useful in at least two projects or has a truly platform-generic responsibility.

Project-specific mechanics remain in that project's `src/server/Game`, `src/client/Game`, and `src/shared/Game` folders.
