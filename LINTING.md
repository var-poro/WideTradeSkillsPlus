# Linting avec Luacheck

Ce projet utilise [Luacheck](https://github.com/lunarmodules/luacheck) pour analyser le code Lua et détecter les erreurs potentielles.

## Installation

### Windows

1. Installez [Lua](https://www.lua.org/download.html) ou utilisez [LuaRocks](https://luarocks.org/)
2. Installez Luacheck via LuaRocks :
   ```bash
   luarocks install luacheck
   ```

### Linux / macOS

```bash
# Via LuaRocks
luarocks install luacheck

# Ou via package manager (si disponible)
# Ubuntu/Debian
sudo apt-get install lua-check

# macOS (Homebrew)
brew install luacheck
```

## Utilisation

### Lancer le linter

**Windows :**
```bash
lint.bat
```

**Linux / macOS :**
```bash
chmod +x lint.sh
./lint.sh
```

**Manuellement :**
```bash
luacheck *.lua
```

### Options avancées

Pour voir uniquement les erreurs (sans warnings) :
```bash
luacheck --no-unused-globals --no-unused-args *.lua
```

Pour un format plus détaillé :
```bash
luacheck --formatter plain *.lua
```

Pour vérifier un fichier spécifique :
```bash
luacheck WideTradeSkillsPlus.lua
```

## Configuration

La configuration se trouve dans `.luacheckrc`. Elle inclut :

- **read_globals** : Liste des globaux WoW API en lecture seule
- **globals** : Liste des globaux qui peuvent être écrits (comme `WTSPlusDB`)
- **ignore** : Codes d'avertissement à ignorer

## Intégration avec les éditeurs

### Visual Studio Code

Installez l'extension [Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) qui supporte Luacheck.

### Cursor

L'extension Lua devrait automatiquement détecter le fichier `.luacheckrc` et utiliser la configuration.

## Codes d'avertissement courants

- **211** : Variable non utilisée
- **212** : Argument non utilisé (ignoré dans ce projet)
- **113** : Accès à un global non défini
- **112** : Écriture dans un global non défini

Pour plus d'informations, consultez la [documentation officielle de Luacheck](https://luacheck.readthedocs.io/).
