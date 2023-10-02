# Contributing

- [Development Software](#development-software)
    - [Godot Engine](#godot-engine)
    - [Image Creation](#image-creation)
- [Style Guide](#style-guide)
    - [Directory Layout](#directory-layout)
    - [Code Style](#code-style)

## Development Software

A couple of software tools are commonly used for this project. The tool and its purpose are listed below.

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

## Style Guide

This style guide will be expanded further when more development-oriented work begins on the project. The current
standards are listed below.

The project organization will follow
(Godot's recommended structure)[https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html].

### Directory Layout

The below diagram indicates how files and directories should be laid out.

```
project root
│   README.md
│   CONTRIBUTING.md
│   ...other root files
│
└───docs
│   ...offline project-specific documentation
│
└───src
    │   project.godot
    │
    └───addons
    │   ...any addons for Godot
    │
    └───features
    │   │
    │   └───[feature 1's name]
    │   │   │
    │   │   └───assets
    │   │   │   │   ...images/audio/other digital assets
    │   │   │
    │   │   └───nodes
    │   │   │   │   ...all feature-specific nodes
    │   │   │
    │   │   └───scripts
    │   │       │   ...any unattached .gd script
    │   │
    │   └───[feature 2's name]
    │       │
    │       └───assets
    │       │   │   ...images/audio/other digital assets
    │       │
    │       └───nodes
    │       │   │   ...all feature-specific nodes
    │       │
    │       └───scripts
    │           │   ...any unattached .gd script
    │
    └───scenes
        │   ...any non-categorized scenes
        │
        └───levels
        │   │   ...all main-game levels
        │
        └───guis
            │   ...all gui-only scenes (i.e., main menu, etc.)

```

### Code Style

1. Within GDScript, the optional static typing should always be used.
2. Variable names should be descriptive.
3. ... More to come soon.

