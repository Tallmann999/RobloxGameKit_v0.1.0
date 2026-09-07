# Команды для старта новой игры

Ниже пример. Пути и URL замени своими.

```powershell
# 1) Клонировать пустой репозиторий игры
git clone https://github.com/<YOU>/GoldenEgg-MVP.git
cd GoldenEgg-MVP

# 2) Временно скачать RobloxGameKit рядом/во временную папку
git clone https://github.com/<YOU>/RobloxGameKit.git .robloxgamekit-temp

# 3) Посмотреть доступные модули
python .robloxgamekit-temp/scripts/list_modules.py

# 4) Bootstrap минимального MVP
python .robloxgamekit-temp/scripts/bootstrap_game.py --target . --modules core network tags

# 5) Удалить временную копию kit
Remove-Item -Recurse -Force .robloxgamekit-temp

# 6) После установки Rokit
rokit install
rojo plugin install

# 7) Запустить sync server
rojo serve
```

Для MVP с сохранением монет:

```powershell
python .robloxgamekit-temp/scripts/bootstrap_game.py --target . --modules core network tags player-data economy
```

`player-data` по умолчанию имеет `Persistence.Enabled = false`. Включать реальный DataStore следует только после создания private test Experience и осознанной настройки DEV persistence.
