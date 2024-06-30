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

## Basic usage

1. In visual mode, select lines to be aligned
1. Type `:` to go into command mode **with selected range**,
	now the command line in vim should be with range, *i.e.* shows `:'<,'>`. In the next step, just type command after it
1. Run command for the range :
	> The indent at the head of each line should always be ignored,
	> all words will be aligned as no indent and insert the indent later.
	- `Valign` : align all words splited by white space
	- `Vsqueeze` : make all words splited by single space character

## Align by syntax

This plugin has a basic syntax-align command `Vsyntax0`.
It groups each word splited by white space by thier syntax code
*i.e.* `synID()` :
- `synID()` is `0`
- `synID()` is not `0`

And then align each group.

### *E.g.*

For C language code blocks :
```c
int     i  = 8  * anot     ;
static unsigned short    cs =   26 + 8 - anot ;  /**/
inline char gzjsyldpr[]   =  "uieiuhiongaiaoe"     nocat ;
```

In some version of (neo)vim,
C language operators were assigned to syntax code `0`.
So `:'<,'>Vsyntax` will generate :
```c
int                   i =           8                 * anot ;
static unsigned short cs =          26                +        8 - anot ; /**/
inline char           gzjsyldpr[] = "uieiuhiongaiaoe" nocat ;
```
Here `=` `*` `+` is assigned to syntax code `0`
so they were grouped with variables together.
And strings/numbers after them were another group
so they were at another align.

And if operators are set to `cOperator` highlight group :
```vim
:syntax match cOperator "?\|+\|-\|\*\|;\|:\|,\|<\|>\|&\||\|!\|\~\|%\|=\|)\|(\|{\|}\|\.\|\[\|\]\|/\(/\|*\)\@!"
```

`:'<,'>Vsyntax` will generate the expected block :
```c
int                   i           = 8 *               anot  ;
static unsigned short cs          = 26 + 8 -          anot  ; /**/
inline char           gzjsyldpr[] = "uieiuhiongaiaoe" nocat ;
```

## About multibyte characters

Follow `strdisplaywidth()` directly.
`:help strdisplaywidth()` for more ditailes.
