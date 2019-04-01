# vim-nano

Mighty nano inside a vim. I initially wrote this for a parody hackathon, and now
I just want to see how far I can go with this. Many nano features yet to be
implemented, including the brand new nano 4.0 goodness!

# Requirements

- neovim/vim8 (terminal support abused to replicate nano interface)
- python (should work with 2 or 3, I only test it on py3 nowadays)

# Installation
Not yet packaged as a plugin, because you don't need a vimrc anyway!

```
$ git clone https://github.com/nims11/vim-nano.git
$ cd vim-nano/
$ nvim -u nano.vim
```

![vim-nano in action](https://raw.githubusercontent.com/nims11/vim-nano/master/screenshot.png)
