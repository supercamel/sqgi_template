# SQGI Template

A quick start demo for [SQGI](https://github.com/supercamel/sqgi): copy this
template into a new repo, rename the app, and start building a GTK4 desktop
application. Read the SQGI docs at
[sqgi.readthedocs.io](https://sqgi.readthedocs.io/en/latest/) or join the
[SQGI community Discord](https://discord.gg/krVe8U9wGm).

SQGI is a small Squirrel runtime for native applications. This template keeps
the first project shape deliberately simple: one `main.nut`, one
`sqgipkg.json`, and a GitHub Actions workflow that packages release artifacts.

## Quickstart

Install SQGI first so you can run the app locally with `sqgi`. Release
packaging is handled by GitHub Actions.

### Windows

The recommended Windows setup is [Ooblerg](https://ooblerg.xyz/), a package
manager and MinGW sysroot for local SQGI, GTK4, Vala, GStreamer, and related
native app development.

1. Download and install Ooblerg for Windows.
2. Launch Ooblerg and refresh the package index.
3. Install `sqgi` and `gtk4`.
4. In Ooblerg, check that its MinGW sysroot is added to `PATH`.
5. Open a fresh Command Prompt or PowerShell window.

Install additional Ooblerg packages, such as `libadwaita` or `gstreamer`, when
your app imports those libraries. Ooblerg is for local Windows development; the
Windows installer is still built by the Ubuntu GitHub Actions runner when you
push to `main` or publish a version tag.

### Linux and source builds

On Linux, or when you want to build SQGI from source, use the upstream project:

```sh
git clone https://github.com/supercamel/sqgi.git
cd sqgi
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cmake --install build --prefix /usr/local
sudo ldconfig
```

See the upstream [SQGI README](https://github.com/supercamel/sqgi) and
[SQGI documentation](https://sqgi.readthedocs.io/en/latest/) for the current
dependency list, language guide, packaging docs, and platform notes.

### Start a new app

Create an empty GitHub repository for your app first. Do not initialize it with
a README, `.gitignore`, or license; this template already includes the project
files.

Clone the template, then point `origin` at your new repository:

```sh
git clone https://github.com/supercamel/sqgi_template.git my-sqgi-app
cd my-sqgi-app
git remote set-url origin git@github.com:YOURNAME/my-sqgi-app.git
```

Then update the app name and application ID in `main.nut`, `sqgipkg.json`, and
`.github/workflows/release.yml`.

Commit those changes and push to your new repo:

```sh
git add .
git commit -m "Create app from SQGI template"
git push -u origin main
```

Run the app:

```sh
sqgi main.nut
```

## The idea

Write your app as a Squirrel script, test it locally with `sqgi`, and let CI
build the distributable packages.

The usual loop is:

```sh
sqgi main.nut
git add .
git commit -m "Update app"
git push
```

When you are ready to ship a release, push a version tag:

```sh
git tag -a v0.1.0 -m "Release v0.1.0"
git push origin main
git push origin v0.1.0
```

GitHub Actions then builds the Linux and Windows packages from the same source
you tested locally.

## Local Testing Notes

Run `sqgi main.nut` from the project directory when iterating locally.

The app uses `assets/dev.sam.sqgitemplate.png` as its GTK application icon.
Ubuntu/GNOME may still show a generic dock icon when the app is launched
directly from a terminal, because the dock normally matches running apps to an
installed `.desktop` file. Install a local development desktop entry when you
want the dock icon to match during local runs:

```sh
scripts/install-local-desktop-entry.sh
```

Then launch the app normally, or from your desktop launcher. The packaged
AppImage includes its own desktop metadata for release builds.

On Linux or another environment where `sqgipkg` is available, ask it to check
the project shape before pushing a release:

```sh
sqgipkg --doctor
```

You can also build a local Linux AppImage:

```sh
sqgipkg --target appimage --appimage-arch x86_64
```

## GitHub Actions Release Builds

The workflow in `.github/workflows/release.yml` is the release builder. It
checks out this app, checks out
[github.com/supercamel/sqgi](https://github.com/supercamel/sqgi) during the
build, builds the upstream runtime and `sqgipkg`, then packages this project.

It runs when you:

- push to `main`, which creates downloadable workflow artifacts;
- push a tag like `v0.1.0`, which creates the same artifacts and publishes them
  to a GitHub Release.

The workflow builds:

- Linux x86_64 AppImage
- Linux aarch64 AppImage
- Windows x86_64 NSIS installer

That means local development only needs the SQGI runtime. You do not need to
set up cross-compilers, MSYS2, NSIS, or AppImage tooling on your own machine
just to ship the app.
