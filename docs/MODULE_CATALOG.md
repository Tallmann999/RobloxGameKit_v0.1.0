# Module Catalog

## Ready modules in v0.1

| Module | Purpose | Typical MVP |
|---|---|---|
| `core` | Server/client bootstrap, config, logger, module lifecycle | Always |
| `network` | Central RemoteEvent/RemoteFunction creation/access | Multiplayer interactions |
| `tags` | CollectionService tag binding helper | World-driven gameplay |
| `player-data` | Server-side profile template + optional DataStore persistence | Only if MVP must save |
| `economy` | Server-authoritative currencies on top of player-data | Currency/upgrades |

## Blueprint modules

Blueprints contain architecture/acceptance criteria and should be implemented in the game only when needed. They should not be installed speculatively.

- `interaction`
- `inventory`
- `progression`
- `ui`
- `audio`
- `analytics`
- `monetization`
- `localization`
- `settings`
- `daily-rewards`
- `teleports`
- `anti-exploit`

## Selection examples

Tiny one-session prototype with no saving:

`core + network + tags`

Prototype with coins that must survive rejoin:

`core + network + tags + player-data + economy`

Do not install monetization/analytics/daily rewards merely because a future production game may need them.
