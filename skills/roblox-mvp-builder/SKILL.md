---
name: roblox-mvp-builder
description: "Разработчик локального Roblox MVP для Codex. Используй при запросах реализовать механику в Roblox Studio по концепту, Feature Index или GDD. Подключай RobloxGameKit, Rojo и Studio MCP; тестируй Play и сохраняй локальный place без публикации."
---

# Roblox MVP Builder

## Цель
Сделать один реально играбельный vertical slice Roblox от документов до локального файла .rbxl/.rbxlx. Разработку выполняет локальный Codex с доступными shell, Rojo и Roblox Studio MCP. Навык сам не предоставляет такого доступа.

## Вход
Прочитай docs/project-concept.md, docs/feature-index.md, docs/mvp-handoff.md, docs/features/*_gd-spec.md, AGENTS.md и имеющиеся файлы проекта. Не спрашивай повторно известное. Если документов нет, предложи сначала $gd-roblox-kickoff. Если нет существенных решений для core loop, укажи блокер; некритичные заглушки пометь ASSUMPTION.

## Режим LOCAL_MVP
По умолчанию: без публичной публикации, DataStore, аналитики, монетизации, лобби и мультиплеера, если они не являются проверяемой гипотезой. Сосредоточься на 3–7 критериях приёмки из handoff, необходимых для одного завершённого игрового цикла. Сначала запиши docs/technical-plan.md и docs/mvp-checklist.md с привязкой F-ID к реализации, тестам и статусам.

## RobloxGameKit
Используй https://github.com/Tallmann999/RobloxGameKit_v0.1.0 как источник, не копируй всю библиотеку в проект. Прочитай docs/ARCHITECTURE.md, docs/CODEX_MASTER_INSTRUCTION_RU.md и module-catalog.json. В версии 0.1.0 ready-модули: core, network, tags, economy, player-data. Другие модули только blueprint: нельзя выдавать их за готовую реализацию. Bootstrap новой папки: python <kit>/scripts/bootstrap_game.py --target <game> --modules core tags. Добавь network лишь при необходимости client/server сообщений, economy/player-data только когда требует сценарий. Не применяй --force к существующим файлам без отдельного разрешения.

## Файловая структура и Studio
Убедись в наличии default.project.json, rokit.toml, src, AGENTS.md. Синхронизация Rojo должна владеть лишь ReplicatedStorage/GameShared, ServerScriptService/GameServer и StarterPlayer/StarterPlayerScripts/GameClient. Workspace, Terrain, Lighting и импортированные модели — пользовательские данные Studio; не удаляй и не ставь их под Rojo mapping. Прежде чем менять сцену, сделай резервный .rbxl и прочитай DataModel через MCP. Если Studio MCP недоступен, дай точные шаги настройки и чётко обозначь невозможность проверить сцену.

## Реализация
Пиши Luau и простые Parts/Models вместо дорогих ассетов. Игра должна иметь явные старт, действие игрока, реакцию сервера, обратную связь и результат. Сервер авторитетен для предметов, валюты, урона, прогресса и покупок; RemoteEvent payload всегда недоверенный. Проверяй типы, диапазоны, дистанцию, ownership, cooldown, контекст и частоту действий. Код сервера держи в ServerScriptService, а не в ReplicatedStorage. Клиенту нужны UI, камера, ввод и локальные эффекты. Не клади секреты в shared. GameKit player-data не готов к надёжному production persistence без доработок.

## Тест
Запусти доступные StyLua и Selene, затем локальный Studio Play Test. Читай реальный Output, исправляй сбои и повторяй тест. Multiplayer-sensitive механики проверяй в локальном multi-client режиме. Никогда не отмечай feature-index как tested без реального выполнения acceptance criteria. Сохраняй мир как place/dev-world.rbxl или .rbxlx, а исходники как локальные Git-файлы; при наличии разрешения фиксируй коммиты. GitHub push и публикация Roblox не обязательны.

## Передача
Дай пользователю путь к игре и place, что работает, какие F-ID реально проверены, как открыть в Studio, какие шаги остаются. Не утверждай, что протестировал Studio, когда запущен был только анализ текста. Отправка .rbxl друзьям раскрывает редактируемое содержимое и серверные исходники. Для безопасного плейтеста позже предложи private Experience с доступом тестировщикам только после отдельного разрешения на публикацию.

## Ручные шаги
Если реально требуется авторизация, установка Rojo/Rokit, подключение MCP или открытие Studio, остановись только на конкретном блокере: дай 2–4 точных инструкции, ожидаемый результат и продолжай после подтверждения. Не заставляй пользователя самостоятельно писать Luau.
