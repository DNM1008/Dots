# Neovim Keymaps

Leader key: `<Space>`

## Splits (`<leader>s`)

| Key | Action |
|-----|--------|
| `<leader>sv` | Vertical split |
| `<leader>sh` | Horizontal split |
| `<leader>se` | Equalise splits |
| `<leader>sx` | Close split |
| `<leader>sm` | Maximise/minimise split |

### Navigation & resize
| Key | Action |
|-----|--------|
| `<A-h/j/k/l>` | Swap split in direction |
| `<A-Left/Right>` | Resize vertical |
| `<A-Up/Down>` | Resize horizontal |

## Tabs (`<leader>t`)

| Key | Action |
|-----|--------|
| `<leader>to` | New tab |
| `<leader>tx` | Close tab |
| `<leader>tn` | Next tab |
| `<leader>tp` | Previous tab |
| `<leader>tf` | Buffer to new tab |
| `<leader>tl` | List tabs |

## Terminal (`<leader><CR>`)

| Key | Action |
|-----|--------|
| `<leader><CR>h` | Open horizontal terminal |
| `<leader><CR>v` | Open vertical terminal |
| `<Esc>` | Normal mode (in terminal) |
| `ZZ` | Close terminal window |

## Explorer (`<leader>e`)

| Key | Action |
|-----|--------|
| `<leader>ee` | Toggle file explorer |
| `<leader>ef` | Focus explorer on current file |
| `<leader>ec` | Collapse explorer |
| `<leader>er` | Refresh explorer |

## Find (`<leader>f`)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>fh` | Find help tags |
| `<leader>fs` | Live grep |
| `<leader>fc` | Grep word under cursor |

## Code (`<leader>c`)

| Key | Action |
|-----|--------|
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format file/range |
| `<leader>cd` | Generate docstring |
| `<leader>cl` | Trigger linting |

### LSP navigation
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gR` | Go to references |
| `K` | Hover docs |
| `[d` / `]d` | Previous/next diagnostic |

## Diagnostics (`<leader>x`)

| Key | Action |
|-----|--------|
| `<leader>xf` | Floating diagnostic |
| `<leader>xw` | Workspace diagnostics (Trouble) |
| `<leader>xq` | Quickfix list (Trouble) |
| `<leader>xl` | Location list (Trouble) |
| `<leader>xt` | Todos (Trouble) |

## Git (`<leader>g`)

| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit |

## Claude / AI (`<leader>a`)

| Key | Action |
|-----|--------|
| `<leader>ac` | Toggle Claude |
| `<leader>an` | New Claude chat |
| `<leader>af` | Focus Claude |
| `<leader>ar` | Resume Claude |
| `<leader>am` | Select model |
| `<leader>ab` | Add current buffer |
| `<leader>as` | Send selection to Claude (visual) |
| `<leader>aa` | Accept diff |
| `<leader>ad` | Deny diff |

## Lazy / Mason (`<leader>l`)

| Key | Action |
|-----|--------|
| `<leader>ls` | Lazy sync |
| `<leader>lu` | Lazy update |
| `<leader>lx` | Lazy clean |
| `<leader>lz` | Open Lazy |
| `<leader>lm` | Open Mason |

## Markdown (`<leader>p`)

| Key | Action |
|-----|--------|
| `<leader>pt` | Preview (render-markdown) |
| `<leader>pp` | Render to PDF |

## View (`<leader>v`)

| Key | Action |
|-----|--------|
| `<leader>vc` | Toggle CSV view |

## Misc

| Key | Action |
|-----|--------|
| `<leader>nh` | Clear search highlights |
| `j` / `k` | Move by visual line (wrap-aware) |
