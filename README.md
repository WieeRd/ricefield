# Ricefield

> [Rice] is a word that is commonly used to refer to making visual improvements
> and customizations on one's desktop. It was inherited from the practice of
> customizing cheap Asian import cars to make them appear to be faster than they
> actually were - which was also known as "ricing".

Welcome to my rice field, nerd.

[Rice]: https://www.reddit.com/r/unixporn/wiki/themeing/dictionary/#wiki_rice

## Deployment

I got tired of gimmicks and hassles of so called "dotfiles managers".

This repository is simply my home directory being tracked by Git.

```nushell
git init
git remote add origin https://github.com/WieeRd/ricefield.git
git pull origin
```

Alternatively, use the [--separate-git-dir] strategy.

```nushell
git clone --bare https://github.com/WieeRd/ricefield.git ~/.ricefield.git
cd ~/.ricefield.git/
git config core.worktree ~
```

It can avoid some unwanted noises from making `$HOME` a Git repository.

[--separate-git-dir]: https://news.ycombinator.com/item?id=11070797

## The Workflow

I will (try to) document things in detail later (hopefully).

- OS: Arch Linux
- WM: Qtile
- Terminal: Kitty
- Shell: Nushell
- Editor: Neovim

## License

[*Do Whatever The Fuck You Want to.*](http://www.wtfpl.net)\
I stole this config from others and so others shall steal from me.
