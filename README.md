# My Dotfiles

Another rewrite of my dotfiles. Why the constant rewriting? For something that I rarely do, I want the process to be as straightforward as possible, without me having to remember a bunch of stuff. I want to be able to just look at this readme, run a few commands, and have a new machine up and running quickly. On to the requirements:

- Allow separate configs for different OSes and situations (like work vs. personal). Especially with work vs personal, I need to be sure configs don't leak between the two.
- Automated install of software for each platform. I should just be able to run a script to download, install, and configure the software I need.
- Automated configuration of OS and software. This is where the dotfiles come in.



## Getting Started

tldr; `git clone --recursive https://github.com/addr/dotfiles ~/.dotfiles && cd ~/.dotfiles && make`

This section is mainly for my future self to blindly follow long after I've forgot everything here.

### Bootstrap

tldr; `make bootstrap`

In order to fetch our dotfiles and configure the system, we first need to do some basic bootstrapping. This includes:

- Installing `git`
- Installing `homebrew`
- Installing `zero` (which is what I use to automate setup from dotfiles)

``` shell
git clone --recursive https://github.com/addr/dotfiles ~/.dotfiles
```

## Background

### MacOS Defaults

- Set computer name and hostname

### Tiling Window Manager (Yabai)

