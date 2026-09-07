# START HERE — точный сценарий новой Roblox-игры

Это пользовательский сценарий. Он предполагает: Git и VS Code уже есть; Roblox Studio установлен; Codex используется как основной разработчик.

## Этап A — один раз опубликовать RobloxGameKit на GitHub

1. На GitHub создай **пустой** репозиторий `RobloxGameKit` (без README/.gitignore/license, потому что они уже есть в kit).
2. Распакуй `RobloxGameKit_v0.1.0.zip`.
3. Открой PowerShell в папке `RobloxGameKit`.
4. Выполни:

```powershell
git init
git add .
git commit -m "chore: initial RobloxGameKit v0.1.0"
git branch -M main
git remote add origin https://github.com/<YOU>/RobloxGameKit.git
git push -u origin main
```

С этого момента URL этого репозитория является источником RobloxGameKit для всех новых игр.

---

## Этап B — создать новую игру

### Шаг 1. GitHub

Создай пустой репозиторий игры, например `GoldenEgg-MVP`.

Локально:

```powershell
git clone https://github.com/<YOU>/GoldenEgg-MVP.git
cd GoldenEgg-MVP
```

Если у Codex есть `gh` и GitHub авторизация, можно попросить Codex создать/клонировать репозиторий самому. Если нет — этот шаг делаешь руками.

### Шаг 2. Установить gd-doc-kickoff один раз для Codex

Windows PowerShell:

```powershell
git clone https://github.com/VKSpaz/gd-doc-kickoff.git "$env:USERPROFILE\.codex\skills\gd-doc-kickoff"
```

Перезапусти/обнови Codex skills, если клиент этого требует.

### Шаг 3. Первый запрос Codex — геймдизайн

Скопируй в Codex:

> Используй skill `gd-doc-kickoff`. Это новый Roblox-проект. Вот мой концепт: <ВСТАВЬ КОНЦЕПТ>. Сначала помоги сузить его до маленького MVP для проверки гипотезы. Создай в текущем репозитории `docs/project-concept.md`, `docs/feature-index.md` и нужную MVP feature-spec. Чётко раздели MVP / P1 / P2. Пока не пиши код.

Доведи интервью до готовой документации.

### Шаг 4. Второй запрос Codex — технический bootstrap

Скопируй в Codex:

> Теперь переходи из роли геймдизайнера в роль Roblox technical developer. RobloxGameKit находится здесь: `https://github.com/<YOU>/RobloxGameKit`. Прочитай `docs/CODEX_MASTER_INSTRUCTION_RU.md` из RobloxGameKit и следуй ей как основной инструкции. Прочитай документацию текущей игры, выбери минимальные модули только для MVP, создай технический план и начни bootstrap. Всё, что можешь сделать сам через shell/Git/файлы, делай сам. Если нужен мой ручной шаг в Roblox Studio, GitHub authentication или установке инструмента — остановись только на этом блокере, дай точные шаги и после моего `готово` продолжай.

Ожидаемый результат: Codex подтянет kit во временную папку, выберет модули и создаст `src/`, `default.project.json`, `rokit.toml`, `AGENTS.md`, technical plan и checklist.

---

## Этап C — инструменты Roblox

### Шаг 5. Rokit

Если `rokit` ещё не установлен, установи его по официальной инструкции. После этого в корне игры:

```powershell
rokit install
```

Это поставит закреплённые в `rokit.toml`:

- Rojo 7.7.0
- Selene 0.31.0
- StyLua 2.5.2

Затем:

```powershell
rojo plugin install
```

Если Codex имеет terminal доступ, попроси его выполнить проверки команд и установки самому.

---

## Этап D — Roblox Studio и твой мир

### Шаг 6. Создать приватный Experience

В Roblox Studio:

1. Создай Baseplate/новый Experience.
2. Publish to Roblox, но оставь Experience **private**.
3. Сохрани локальную копию мира в репозитории как:
   `place/dev-world.rbxl`.

Если файл со временем станет большим, переведи бинарные place/model snapshots на Git LFS или храни контролируемые snapshots отдельно, чтобы не раздувать историю Git.

### Шаг 7. Собрать сцену

В Studio вручную сделай/импортируй:

- Terrain/землю;
- Lighting;
- дома/окружение;
- декор;
- SpawnLocation;
- основные визуальные зоны MVP.

Пока не надо вручную создавать gameplay Scripts.

### Шаг 8. Подключить Studio MCP

В Roblox Studio:

1. Открой настройки Assistant / MCP Servers.
2. Включи **Studio as MCP server**.
3. В Quick Connect включи Codex CLI (или используемый тобой совместимый Codex-клиент).

После этого напиши Codex:

> Roblox Studio открыт, private Experience открыт, MCP включён. Сначала только прочитай DataModel и перечисли основные объекты/папки, ничего не меняй. Если связь работает — продолжи по technical plan.

### Шаг 9. Rojo

В корне проекта:

```powershell
rojo serve
```

В Roblox Studio:

1. Plugins → Rojo.
2. Connect.

Проверь, что появились:

- `ReplicatedStorage/GameShared`
- `ServerScriptService/GameServer`
- `StarterPlayer/StarterPlayerScripts/GameClient`

И главное: твои Workspace/Terrain/Lighting должны остаться на месте.

После этого напиши Codex:

> Rojo подключён. Проверь через MCP, что `GameShared`, `GameServer`, `GameClient` появились и Workspace не повреждён. Затем реализуй только первый vertical slice из `docs/mvp-checklist.md`, протестируй его через Play, прочитай Output, исправь ошибки и повтори тест.

---

## Этап E — дальнейшая работа по фичам

На каждую следующую фичу используй короткий формат:

> Возьми следующую незакрытую MVP-фичу из `docs/mvp-checklist.md`. Прочитай её GD spec и текущую архитектуру. Реализуй минимальный vertical slice. Сервер должен быть authoritative. Для объектов мира используй Tags/Attributes, если это подходит. После реализации запусти format/lint, Play Test через Studio MCP, прочитай Output, исправь проблемы, retest и только после успешной проверки отметь пункт готовым. Затем создай осмысленный Git commit.

Если нужно визуально изменить сцену, можно дать Codex задачу через MCP или сделать это руками в Studio, после чего попросить Codex повторно прочитать DataModel.

---

## Этап F — переход MVP → production

Только после того, как MVP доказал гипотезу, попроси:

> MVP подтверждён. Пересмотри `feature-index.md` и предложи P1 technical milestone. Выбери из RobloxGameKit только действительно необходимые следующие модули. Перед DataStore, analytics, monetization, teleports или другими platform-sensitive API проверь текущую официальную Roblox документацию. Не подключай P2.

И далее работай такими же vertical slices.
