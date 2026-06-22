# SQGI Template

A minimal starter project for building native GTK4 desktop apps with
[SQGI](https://github.com/supercamel/sqgi).

Clone this template, rename the app, write Squirrel code in `main.nut`, and
push a release tag. GitHub Actions builds the distributable packages for you:

- Linux x86_64 AppImage
- Linux aarch64 AppImage
- Windows x86_64 NSIS installer

You only need SQGI and the libraries your app uses for local development.
Release packaging happens in CI, so you do not need to set up cross-compilers,
MSYS2, NSIS, or AppImage tooling on your own machine just to ship a desktop app.

SQGI is a small Squirrel runtime for native applications. This template keeps
the first project shape deliberately simple:

- one `main.nut`
- one `sqgipkg.json`
- one GitHub Actions release workflow

Read the SQGI docs at
[sqgi.readthedocs.io](https://sqgi.readthedocs.io/en/latest/) or join the
[SQGI community Discord](https://discord.gg/krVe8U9wGm).

## What you get

This template is designed for the simplest useful native app loop:

```sh
sqgi main.nut
git add .
git commit -m "Update app"
git push
```

When you are ready to ship:

```sh
git tag -a v0.1.0 -m "Release v0.1.0"
git push origin main
git push origin v0.1.0
```

GitHub Actions then builds release artifacts from the same source you tested
locally.

## Project layout

```text
.
├── main.nut
├── sqgipkg.json
├── assets/
│   └── dev.sam.sqgitemplate.png
├── scripts/
│   └── install-local-desktop-entry.sh
└── .github/
    └── workflows/
        └── release.yml
```

Important files:

- `main.nut` — application entry point
- `sqgipkg.json` — app metadata and packaging configuration
- `.github/workflows/release.yml` — CI release builder
- `assets/` — app icons and other bundled assets
- `scripts/` — local development helpers

## Quickstart

Create an empty GitHub repository for your new app first.

Do not initialize it with a README, `.gitignore`, or license. This template
already includes the project files.

Clone the template:

```sh
git clone https://github.com/supercamel/sqgi_template.git my-sqgi-app
cd my-sqgi-app
```

Point `origin` at your new repository:

```sh
git remote set-url origin git@github.com:YOURNAME/my-sqgi-app.git
```

Rename the app by updating the app name, application ID, icon name, and package
metadata in:

- `main.nut`
- `sqgipkg.json`
- `.github/workflows/release.yml`
- `assets/`, if you replace the default icon

Then commit and push:

```sh
git add .
git commit -m "Create app from SQGI template"
git push -u origin main
```

Run the app locally:

```sh
sqgi main.nut
```

## Windows development

The recommended Windows setup is [Ooblerg](https://ooblerg.xyz/).

Ooblerg is a package manager and MinGW sysroot for local SQGI, GTK4, Vala,
GStreamer, and related native app development on Windows. It lets you install
the tools and libraries you need into a managed sysroot, then use them from
Command Prompt, PowerShell, or VS Code.

To set up this template on Windows:

1. Download and install Ooblerg.
2. Launch Ooblerg.
3. Refresh the package index.
4. Install `sqgi` and `gtk4`.
5. In Ooblerg, check that its MinGW sysroot is added to `PATH`.
6. Open a fresh Command Prompt or PowerShell window.
7. Run the app:

```sh
sqgi main.nut
```

Install additional Ooblerg packages when your app imports extra libraries. For
example:

- `libadwaita`
- `gstreamer`
- `libsoup`
- other GTK/GNOME/native libraries your app needs

Ooblerg is for local Windows development. The Windows installer is still built
by the Ubuntu GitHub Actions runner when you push to `main` or publish a
version tag.

## Linux development

On Linux, install SQGI so you can run the app locally with `sqgi`.

If your distro does not provide SQGI packages yet, build the upstream project
from source:

```sh
git clone https://github.com/supercamel/sqgi.git
cd sqgi
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cmake --install build --prefix /usr/local
sudo ldconfig
```

Then return to your app project and run:

```sh
sqgi main.nut
```

See the upstream [SQGI README](https://github.com/supercamel/sqgi) and
[SQGI documentation](https://sqgi.readthedocs.io/en/latest/) for the current
dependency list, language guide, packaging docs, and platform notes.

## Development workflow

The normal development loop is:

```sh
sqgi main.nut
```

Make changes, test locally, then commit:

```sh
git add .
git commit -m "Update app"
git push
```

A push to `main` creates downloadable workflow artifacts.

A version tag creates the same artifacts and publishes them to a GitHub Release:

```sh
git tag -a v0.1.0 -m "Release v0.1.0"
git push origin main
git push origin v0.1.0
```

Use semantic version-style tags like:

```text
v0.1.0
v0.2.0
v1.0.0
```

## Local testing notes

Run the app from the project directory:

```sh
sqgi main.nut
```

This template uses the icon at:

```text
assets/dev.sam.sqgitemplate.png
```

During local terminal runs on Ubuntu/GNOME, the dock may still show a generic
icon. This is normal. GNOME usually matches running apps to an installed
`.desktop` file.

For local development, you can install a temporary desktop entry:

```sh
scripts/install-local-desktop-entry.sh
```

Then launch the app from the desktop launcher instead of directly from the
terminal.

The packaged AppImage includes its own desktop metadata for release builds.

## Check the package

If `sqgipkg` is available in your environment, ask it to check the project
before publishing a release:

```sh
sqgipkg --doctor
```

You can also build a local Linux AppImage:

```sh
sqgipkg --target appimage --appimage-arch x86_64
```

Local AppImage builds are optional. The GitHub Actions workflow builds release
artifacts automatically.

## GitHub Actions release builds

The release workflow lives at:

```text
.github/workflows/release.yml
```

It checks out this app, checks out
[github.com/supercamel/sqgi](https://github.com/supercamel/sqgi), builds the
upstream SQGI runtime and `sqgipkg`, then packages this project.

The workflow runs when you:

- push to `main`
- push a version tag like `v0.1.0`

A push to `main` creates downloadable workflow artifacts.

A version tag creates downloadable artifacts and publishes them to a GitHub
Release.

The workflow builds:

- Linux x86_64 AppImage
- Linux aarch64 AppImage
- Windows x86_64 NSIS installer

That means local development only needs the SQGI runtime and the native
libraries your app imports. You do not need to install cross-compilers, MSYS2,
NSIS, or AppImage tooling just to ship the app.

## Troubleshooting

### `sqgi` is not found

Make sure SQGI is installed and available on `PATH`.

On Windows, check that Ooblerg's MinGW sysroot is added to `PATH`, then open a
fresh Command Prompt or PowerShell window.

### GTK cannot be found

Make sure GTK4 is installed in your local development environment.

On Windows, install `gtk4` in Ooblerg.

On Linux, install your distro's GTK4 development packages, or follow the SQGI
documentation for the current dependency list.

### `pkg-config` cannot find a library

Install the development package for the library you are importing.

For example, if your app imports GTK4, make sure the GTK4 package and its
pkg-config files are installed in the active sysroot or development
environment.

On Windows, install the package in Ooblerg and make sure the Ooblerg sysroot is
on `PATH`.

### The app icon is generic during local runs

This can happen when launching directly from a terminal on GNOME-based
desktops. Install the local development desktop entry:

```sh
scripts/install-local-desktop-entry.sh
```

Then launch the app from the desktop environment.

### The release did not appear

Make sure you pushed the tag to GitHub:

```sh
git push origin v0.1.0
```

Pushing a commit to `main` creates workflow artifacts, but publishing a GitHub
Release requires a version tag.

## Next steps

After the template is running:

1. Replace the app name and application ID.
2. Replace the default icon.
3. Edit `main.nut`.
4. Add any extra library dependencies your app needs.
5. Test locally with `sqgi main.nut`.
6. Push a version tag when you are ready to ship.

For more details, see:

- [SQGI repository](https://github.com/supercamel/sqgi)
- [SQGI documentation](https://sqgi.readthedocs.io/en/latest/)
- [Ooblerg](https://ooblerg.xyz/)
- [SQGI community Discord](https://discord.gg/krVe8U9wGm)