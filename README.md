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

- Installing `git`. You'll have to do this manually, which is usually just `xcode-select --install`
- Installing `homebrew` (automatic)
- Installing `zero` (which is what I use to automate setup from dotfiles)

``` shell
git clone --recursive https://github.com/addr/dotfiles ~/.dotfiles
cd ~/.dotfiles
make
```

Running the above is all you need to do. You will probably have to restart and rerun `make` if there are system updates, but other than that it is pretty much all automated.

Note that it isn't completely unattended: you'll have to babysit it as there are prompts at various points along the way.

### Manual Setup

There are a few things that, unfortunately, can't be scripted or put into a configuration file.

## Background

This section is like a description of the various parts of my dotfiles (at least the noteworthy ones).

### Essential Utilities

#### Tiling Window Manager (Yabai)

Yabai is a powerful tiling window manager. I started out with Amethyst, which is awesome, but more limited. Yabai can be fully controlled from the command line and a text-based config file, and is the closest thing to i3, Sway, etc... on Linux.

My config is mostly taken from: https://cbrgm.net/post/2021-05-5-setup-macos/

With some bits from: https://github.com/koekeishiya/dotfiles/blob/master/skhd/skhdrc

#### Hotkeys (SKHD)

SKHD is primarily used to assign hotkeys to Yabai. It is the other component to providing an i3-like experience on Mac OS.

#### Calculator (Numi)

Yeah, you can use the built in MacOS calculator, or do the basic stuff in Spotlight, but for anything more Numi is awesome.

#### Menu Bar Calendar (Itsycal)

I hate needing a separate window for my calendar. Itsycal allows me to see, at a glance, what I've got coming up without having to open a full calendar window.

### Developer Stuff

There's a lot of

### Personal

These are a few of the miscellaneous personal apps I use.

#### Package Tracking

[Parcel](https://parcelapp.net) is great, and it has both iOS and Mac versions.
