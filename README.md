# valign.nvim

## Install

### Vim

- **Check** if the vim version support plugin and script.
- **Check** if the directory `~/.vim/plugin` exists.

```sh
curl -LO https://raw.githubusercontent.com/riku-ri/valign.nvim/main/plugin/valign.vim --output-dir ~/.vim/plugin
```

### Neovim

- lazy.nvim
	```vim
	{"riku-ri/valign.nvim"}
	```

Or any other similar plugin manager.
Just add the full repository name without any options.

## Usage

1. In visual mode, select lines to be aligned
1. Type `:` to go into command mode **with selected range**,
	now the command line in vim should be with range, *i.e.* shows `:'<,'>`. In the next step, just type command after it
1. Run command for the range :
	> The indent at the head of each line should always be ignored,
	> all words will be aligned as no indent and insert the indent later.
	- `Valign` : align all words splited by white space
	- `Vsqueeze` : make all words splited by single space character

## About multibyte characters

Currently all multibyte characters will be treated as :
- 3 bytes in storage
- Shown 2 character width in screen

Like how CJK UTF-8 monospace character should be.
