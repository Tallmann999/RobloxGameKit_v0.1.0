# Полный рабочий процесс: идея → Roblox MVP

## 0. Один раз: подготовить RobloxGameKit

1. Распаковать RobloxGameKit в отдельную папку.
2. Создать пустой GitHub-репозиторий `RobloxGameKit`.
3. В папке выполнить `git init`, добавить remote, commit и push.
4. Дальше каждая игра использует этот репозиторий как библиотеку исходных модулей/шаблонов.

## 1. Новая игра: создать пустой репозиторий

Создай на GitHub пустой репозиторий, например `GoldenEgg-MVP`, и клонируй его локально.

Если установлен и авторизован GitHub CLI (`gh`), Codex может сделать это сам. Если нет — Codex обязан дать тебе точные шаги и продолжить после ручного создания репозитория.

## 2. Сначала геймдизайн-документация

Установить skill `gd-doc-kickoff` для Codex и прогнать концепт.

Ожидаемый минимум:

- `docs/project-concept.md`
- `docs/feature-index.md`
- спецификация ключевой MVP-фичи

`feature-index` должен явно разделять `MVP`, `P1`, `P2`.

## 3. Перед кодом: RobloxGameKit Planner

Дать Codex мастер-инструкцию из `docs/CODEX_MASTER_INSTRUCTION_RU.md`.

Codex должен:

1. прочитать GDD;
2. выписать только MVP-фичи;
3. сопоставить их с `docs/MODULE_CATALOG.md`;
4. выбрать минимальный набор модулей;
5. не устанавливать будущие P1/P2 системы;
6. создать `docs/technical-plan.md` и `docs/mvp-checklist.md`.

## 4. Bootstrap файлового проекта

Codex клонирует RobloxGameKit во временную папку и запускает:

```powershell
python <kit>/scripts/bootstrap_game.py --target <game> --modules core network tags
```

Модули зависят от конкретного MVP.

После bootstrap в игре должны появиться:

- `default.project.json`
- `rokit.toml`
- `src/`
- `place/`
- `docs/`
- `AGENTS.md`
- `robloxgamekit.lock.json`

## 5. Один раз на компьютере: инструменты

Нужны:

- Git
- VS Code
- Roblox Studio
- Codex CLI/совместимый Codex-клиент
- Rokit
- Rojo CLI
- Rojo Studio plugin
- StyLua
- Selene

Проектный `rokit.toml` фиксирует версии Rojo/StyLua/Selene. После установки Rokit в корне игры выполнить:

```powershell
rokit install
rojo plugin install
```

Если команда недоступна, Codex должен проверить PATH/установку и дать пользователю точные шаги вместо выдуманного продолжения.

## 6. Создать приватный Roblox Experience

В Roblox Studio создать новый Experience/Place и оставить его private.

Сразу сохранить локальную резервную копию в:

`place/dev-world.rbxl`

Важно: этот файл — snapshot мира, а не основной источник кода.

## 7. Собрать/импортировать мир вручную

В Studio пользователь делает то, что удобно делать визуально:

- Terrain
- Lighting
- окружение
- MeshParts/Models
- основные зоны
- spawn
- визуальное расположение объектов

Пока не просить Rojo управлять Workspace.

## 8. Подключить официальный Roblox Studio MCP

В Studio включить Studio MCP server и Quick Connect для Codex, если доступно.

Codex проверяет соединение простой безопасной операцией: читает структуру DataModel и ничего не меняет.

Если MCP не подключён, Codex должен дать ручные шаги и остановиться только на этом блокере.

## 9. Подключить Rojo

В терминале проекта:

```powershell
rojo serve
```

В Studio открыть Rojo plugin и Connect.

Ожидаемый результат:

- `ReplicatedStorage/GameShared`
- `ServerScriptService/GameServer`
- `StarterPlayer/StarterPlayerScripts/GameClient`

Workspace не должен исчезнуть или замениться.

## 10. Зафиксировать связь мира с кодом

Codex через MCP анализирует сцену и предлагает Tags/Attributes.

Пример:

- Tag `Collectible`
- Attributes: `CollectibleType`, `Reward`, `RespawnTime`

Пользователь может расставлять/настраивать объекты визуально, а одна серверная система обслуживает все объекты такого типа.

## 11. Разработка по vertical slices

Не давать задачу «сделай всю игру».

Делать по фичам:

1. Spawn → движение → первый интерактивный объект.
2. Interaction → серверная проверка → feedback.
3. Reward/currency.
4. Saving, только если MVP действительно требует rejoin persistence.
5. Core loop.
6. UI.
7. Progression.
8. Потом analytics/monetization и production-фичи.

Каждая фича проходит цикл:

`прочитать spec → план → код → format/lint → Play → Output → fix → retest → commit`.

## 12. Git

После каждого законченного vertical slice:

```powershell
git status
git add .
git commit -m "feat: ..."
git push
```

Не коммитить сломанный большой пакет изменений без промежуточных контрольных точек.

## 13. Перед переходом от MVP к production

После подтверждения гипотезы отдельно подключать только реально нужное:

- persistence
- inventory/progression
- analytics
- monetization
- localization
- settings
- anti-exploit hardening
- device/UI adaptation

На этом этапе полезные реализации, которые оказались действительно универсальными, можно вернуть обратно в RobloxGameKit как новые версии модулей.
