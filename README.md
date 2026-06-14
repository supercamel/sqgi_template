# SQGI Template

A quick start demo for [SQGI](https://github.com/supercamel/sqgi): clone this
repo, rename the app, and start building a GTK4 desktop application. Read the
SQGI docs at [sqgi.readthedocs.io](https://sqgi.readthedocs.io/en/latest/).

SQGI is a small Squirrel runtime for native applications. This template keeps
the first project shape deliberately simple: one `main.nut`, one
`sqgipkg.json`, and a GitHub Actions workflow that packages release artifacts.

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

## Prerequisite

Install SQGI first so the `sqgi` and `sqgipkg` commands are available:

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

## Start a new app

```sh
git clone https://github.com/supercamel/sqgi_template.git my-sqgi-app
cd my-sqgi-app
```

Then update the app name and application ID in `main.nut`, `sqgipkg.json`, and
`.github/workflows/release.yml`.

## Run And Test Locally

```sh
sqgi main.nut
```

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

For a quick launch-and-exit smoke test:

```sh
sqgi main.nut --smoke
```

Before pushing a release, ask `sqgipkg` to check the project shape:

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
