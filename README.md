# Git Pretty Graph

A simple and pretty Git Graph tool.

![git-pg usage](https://github.com/saltchang/git-pg/blob/main/assets/git-pg-usage-example.gif?raw=true)

## Getting Started

### Installation

```bash
git clone https://github.com/saltchang/git-pg.git

cd git-pg && ./install-git-pg.sh
```

This installation script will copy `git-pg` to your `$HOME/bin`, add the command to your `$PATH`, and then create a Git alias named `git pg` for it.

### Usage

You can run `git-pg` as the command directly or run `git pg` as a Git alias.

This shows the Git Graph:

```bash
git pg
```

This shows the help text:

```bash
git pg --usage

# or
git pg -H

# or
git-pg --help
```
