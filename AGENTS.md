# RobloxGameKit Agent Rules

This repository is a reusable toolkit, not one specific game.

## Hard rules

- Never assume a Roblox API is current when the behavior affects security, monetization, persistence, publishing, networking, analytics, or Studio tooling. Verify current official Roblox documentation before implementing or changing such integrations.
- Do not modify or delete user-created Workspace/Terrain/Lighting assets unless the task explicitly requires it.
- Default to server-authoritative game state.
- Treat all client-supplied values as untrusted.
- Validate remote requests server-side and add rate/shape/context checks where appropriate.
- Prefer Tags + Attributes for binding world instances to reusable systems.
- Prefer a small module set for an MVP. Do not install speculative systems.
- Reusable code belongs in a module; game-specific mechanics stay in the game repository.
- Do not add large frameworks unless the project has a demonstrated need.
- Keep module public APIs small and documented.

## Work loop

For implementation tasks:

1. Read relevant docs and existing code.
2. Inspect the live Studio DataModel through MCP when available.
3. State a small implementation plan.
4. Implement the smallest complete slice.
5. Run StyLua and Selene when available.
6. Run/playtest in Studio when MCP is available.
7. Read Output/console.
8. Fix failures.
9. Retest.
10. Update docs/feature status and changelog if the project uses them.

Never claim a feature is complete without reporting what was actually tested.

## Manual-step protocol

If blocked by authentication, Roblox Studio UI, publishing permissions, installing a plugin/tool, enabling MCP, creating an Experience, entering product IDs, or another user-only action:

- do not guess;
- do not abandon the task;
- ask one compact question;
- provide exact numbered UI/terminal steps;
- say what successful completion should look like;
- wait for the user to say the step is complete, then resume from the next action.
