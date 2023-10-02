# Contributing

- [Development Software](#development-software)
    - [Godot Engine](#godot-engine)
    - [Image Creation](#image-creation)
- [Git Process](#git-process)
    - [Merge Versus Rebase](#merge-versus-rebase)
    - [Branching Strategy](#branching-strategy)
    - [Pull Request Strategy](#pull-request-strategy)
- [Style Guide](#style-guide)
    - [Code Style](#code-style)

## Development Software

There are a couple of software tools that are commonly used for this project. The tool, and its purpose, are listed
below.

### Godot Engine

[Godot Engine](https://godotengine.org/) is used for game development. The all-in-one solution provides a common 
space for everyone to work on the project. Along with Godot, GDScript is the programming language of choice.

Currently, Godot Engine version 4.1 is being used. It is recommended to install Godot Engine through the Steam store.
If Godot is installed through Steam, it is recommended to "pin" the version to 4.1 through the 
`properties -> betas -> "4.1"` setting.

### Image Creation

Currently, three different tools are being investigated for image creation.

1. [Krita](https://krita.org/en/)

    - Fully free and open source.
    - Supports raster images (PNG/JPG).

2. [Aseprite](https://www.aseprite.org/)

    - Source-Available on [GitHub](https://github.com/aseprite/aseprite) for free compilation.
    - For distribution convenience, it can be purchased for $20 on
        [Steam](https://store.steampowered.com/app/431730/Aseprite/)
    - Specialized in pixel art with refined tooling.

3. [Inkscape](https://inkscape.org/)

    - Fully free and open source.
    - Good for SVGs, but the most difficult to use.

## Git Process

The following sections define the recommended procedures for using Git (and GitHub).

### Merge Versus Rebase

For all regular Git usage, merge should be used over rebase. Any pull requests should use the "merge" strategy. If you are working with a local branch,
rebase can be used if it does not cause diverging branches on the remote repository.

### Branching Strategy

Gitflow is the recommended branching strategy for this repository. An in-depth guide can be found [here](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow).

These rules can be summed up in the following:

1. The `main` branch is the "production" branch. No direct commits are allowed to `main`.
2. The `develop` branch is based on the `main` branch. No direct commits are allowed to `develop`.
3. A `release/<version>` branch is created from the `develop` branch and is merged into the `main` branch. Then, the `main` branch is pulled into `develop`.
4. A `feature/<feature name>` branch is created from the `develop` branch. Upon completion, it is merged into the `develop` branch.
5. If a crucial bug is found in `main`, then a `hotfix/<fix name>` branch is created. The `hotfix` branch is merged into `main`. Then, the `main` branch is pulled into `develop`.

### Pull Request Strategy

All changes to `main` and `develop` should first go through a Pull Request (i.e., no direct commits).

Restrictions for `main`:
- Must have at least two approvers
- All CI/CD checks must pass

Restrictions for `develop`:
- Must have at least one approver
- All CI/CD checks must pass

## Style Guide

This style guide will be expanded further when more development-oriented work begins on the project. The current
standards are listed below.

### Code Style

1. Within GDScript, the optional static typing should be used at all times.
2. Variable names should be descriptive.
3. ... More to come soon.

