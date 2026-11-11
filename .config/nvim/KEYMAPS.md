# Neovim Keymaps

Leader key: `<Space>` · Local leader: `\` (default)

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
| `<C-h/j/k/l>` | Move to split (also across tmux panes) |
| `<A-h/j/k/l>` | Swap split in direction |
| `<A-Left/Right>` | Resize vertical (normal and terminal mode) |
| `<A-Up/Down>` | Resize horizontal (normal and terminal mode) |

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
| `<Esc>` | Normal mode (in terminal; in the Claude terminal it goes to Claude) |
| `<C-S-c>` | Normal mode in the Claude terminal |

## Explorer (`<leader>e`)

| Key | Action |
|-----|--------|
| `<leader>ee` | Toggle file explorer |
| `<leader>ef` | Focus explorer on current file |
| `<leader>ec` | Collapse explorer |
| `<leader>er` | Refresh explorer |

### Inside nvim-tree
| Key | Action |
|-----|--------|
| `<leader>d` | Drag file(s) out (ripdrag) |
| `<leader>P` | Play video fullscreen (kitty overlay) |

## Find (`<leader>f`)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files in cwd |
| `<leader>fh` | Find files in home directory |
| `<leader>fr` | Recent files |
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
| `<leader>cx` | Toggle focused diagnostics popup |

### LSP navigation
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gR` | Go to references |
| `K` | Hover docs (nvim default) |
| `[d` / `]d` | Previous/next diagnostic (nvim default) |

## Diagnostics (`<leader>x`)

| Key | Action |
|-----|--------|
| `<leader>xw` | Workspace diagnostics (Trouble) |
| `<leader>xd` | Document diagnostics (Trouble) |
| `<leader>xq` | Quickfix list (Trouble) |
| `<leader>xl` | Location list (Trouble) |
| `<leader>xt` | Todos (Trouble) |

## Text objects and motions (treesitter)

Select with `a`/`i` + suffix (outer/inner), e.g. `daf`, `yim`:

| Suffix | Object |
|--------|--------|
| `=` | Assignment (`l=` / `r=` for left/right side) |
| `:` | Object property, JS/TS (`l:` / `r:` for key/value) |
| `a` | Parameter/argument |
| `i` | Conditional |
| `l` | Loop |
| `f` | Function call |
| `m` | Method/function definition |
| `c` | Class |

Jump with `]`/`[` (start) and `]`/`[` + uppercase (end):

| Key | Target |
|-----|--------|
| `]f` `[f` `]F` `[F` | Function call |
| `]m` `[m` `]M` `[M` | Method/function definition |
| `]k` `[k` `]K` `[K` | Class |
| `]i` `[i` `]I` `[I` | Conditional |
| `]o` `[o` `]O` `[O` | Loop |
| `]x` | Next scope |
| `]z` | Next fold |
| `;` / `,` | Repeat last jump (also `f`/`F`/`t`/`T`) forward/back |

## Swap (`<leader>m`)

| Key | Action |
|-----|--------|
| `<leader>ma` / `<leader>mA` | Swap argument with next/previous |
| `<leader>mp` / `<leader>mP` | Swap property with next/previous |
| `<leader>mf` / `<leader>mF` | Swap function with next/previous |

## Git (`<leader>g`)

| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit |

## Claude / AI (`<leader>a`)

| Key | Action |
|-----|--------|
| `<leader>ac` | Toggle Claude |
| `<leader>an` | New Claude chat |
| `<leader>aC` | Continue last Claude session |
| `<leader>af` | Focus Claude |
| `<leader>ar` | Resume Claude (pick session) |
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

## Noice (`<leader>n`)

| Key | Action |
|-----|--------|
| `<leader>nl` | Last message |
| `<leader>nh` | Message history |

## Notes / Neorg (`<leader>o`)

| Key | Action |
|-----|--------|
| `<leader>oo` | Notes index (`~/notes`) |
| `<leader>or` | Close notes, back to previous buffers |
| `<leader>oj` | Journal: today |

In `.norg` files, Neorg's own keys sit under the local leader: `\t` todo states,
`\l` lists, `\i` insert date, `\n` new note, `\c` magnify code block;
`<C-Space>` cycles a task, `<CR>` follows a link.

## Markdown (`<leader>p`)

| Key | Action |
|-----|--------|
| `<leader>pt` | Preview (vellum) |
| `<leader>pz` | Zoom diagram/image under cursor |
| `<leader>pp` | Render to PDF (pandoc) |

## View (`<leader>v`)

| Key | Action |
|-----|--------|
| `<leader>vc` | Toggle CSV view (CSV files) |

## Zen (`<leader>z`)

| Key | Action |
|-----|--------|
| `<leader>zz` | Zen mode |

## Video

Opening a video file (mp4, mkv, webm, mov, avi, m4v) plays it in that window.

| Key | Action |
|-----|--------|
| `p` | Play/pause (plays again after stop or end) |
| `q` | Stop |
| `h` / `l` | Seek -5s / +5s |
| `m` | Mute |

## Misc

| Key | Action |
|-----|--------|
| `<Esc>` | Clear search highlights |
| `j` / `k` | Move by visual line; by real line with a count (`5j`) |
