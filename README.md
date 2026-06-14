# SQGI Template

A quick start demo for [SQGI](https://github.com/supercamel/sqgi): clone this
repo, rename the app, and start building a GTK4 desktop application. Read the
SQGI docs at [sqgi.readthedocs.io](https://sqgi.readthedocs.io/en/latest/).

SQGI is a small Squirrel runtime for native applications. This template keeps
the first project shape deliberately simple: one `main.nut`, one
`sqgipkg.json`, and a GitHub Actions workflow that packages release artifacts.

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

## Run locally

```sh
sqgi main.nut
```

## Package

```sh
sqgipkg --doctor
sqgipkg --target appimage --appimage-arch x86_64
```

The GitHub Actions workflow builds Linux x86_64 and aarch64 AppImages plus a
Windows NSIS installer. It checks out
[github.com/supercamel/sqgi](https://github.com/supercamel/sqgi) during the
build so CI uses the upstream runtime and `sqgipkg` tooling.
