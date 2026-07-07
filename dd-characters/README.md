# DD Characters

Multicharacter system inspired from qbx_core multichar [Qbox](https://github.com/Qbox-project/qbx_core).

<img width="1917" height="1079" alt="Screenshot 2026-07-04 125514" src="https://github.com/user-attachments/assets/f8d7c74e-077f-4a2c-8b19-a8d789597a4d" />


## Requirements

- [ox_lib](https://github.com/overextended/ox_lib)
- [qbx_core](https://github.com/Qbox-project/qbx_core)
- [illenium-appearance](https://github.com/iLLeniumStudios/illenium-appearance)
- [qbx_apartments](https://github.com/Qbox-project/qbx_apartments) (new characters)
- [bob74_ipl](https://github.com/Bob74/bob74_ipl) (preview interiors)

## Installation

1. Add the resource as `dd-characters`.
2. In `qbx_core/config/client.lua`:

   ```lua
   characters = {
       useExternalCharacters = true,
   }
   ```

3. `ensure dd-characters` after dependencies.

## Character slot limits

Configure **only** in `data/server.lua`:

```lua
characters = {
    defaultNumberOfCharacters = 3,
    playersNumberOfCharacters = {
        ['license2:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'] = 10,
    },
},
```

dd-characters owns character listing, slot limits, and creation. It does not use `qbx_core` multichar callbacks or `qbx_core/config/server.lua` character limits.

## Configuration

| File | What to edit |
|------|----------------|
| `data/shared.lua` | Brand, apartments, codex/pulse toggles, exit action, default spawn |
| `data/client.lua` | Preview scenes, model loading timeout |
| `data/server.lua` | Character slot limits, registration validation |
| `data/starters.lua` | Starter items for new characters |
| `data/codex.lua` | Codex content (enable in shared.lua) |
| `data/pulse.lua` | Pulse feed content (enable in shared.lua) |

## Development

```bash
cd web
bun install
bun run build
```

## More Preview
<img width="1918" height="1079" alt="Screenshot 2026-07-04 125536" src="https://github.com/user-attachments/assets/11b4faac-0913-4b9e-afc3-45b4868fd5bb" />
<img width="1919" height="1076" alt="Screenshot 2026-07-04 125526" src="https://github.com/user-attachments/assets/bf06b387-9ab5-4985-bd66-2eef3062a72e" />
<img width="1917" height="1079" alt="Screenshot 2026-07-04 125514" src="https://github.com/user-attachments/assets/35f17287-6ddb-4c4d-9b49-cf9c216109e8" />
<img width="1919" height="1079" alt="Screenshot 2026-07-04 125434" src="https://github.com/user-attachments/assets/2498784e-5dc1-4390-b8db-26575f1be080" />

