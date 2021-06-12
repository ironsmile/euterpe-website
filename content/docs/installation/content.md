+++
fragment = "content"
weight = 100

title = "Installation"

[sidebar]
  sticky = true
+++

### Released Versions

The safest route is installing [one of the releases](https://github.com/ironsmile/euterpe/releases). Make sure you select a version built for your OS and CPU architecture.

If you have an already built version (for example `euterpe_1.5.0_linux.tar.gz`) it includes an `install` script which would install Euterpe in `/usr/bin/euterpe`. You will have to uninstall any previously installed versions first. An `uninstall` script is provided as well.

### Requirements For Building

If you want to install it from source you will need:

* [Go](http://golang.org/) 1.16 or later [installed and properly configured](http://golang.org/doc/install).

* [go-taglib](https://github.com/wtolson/go-taglib) - Read the [install notes](https://github.com/wtolson/go-taglib#install)

* [go-sqlite3](https://github.com/mattn/go-sqlite3) - `go install github.com/mattn/go-sqlite3` would probably be enough.

* [International Components for Unicode](http://site.icu-project.org/) - The Euterpe binary dynamically links to libicu. Your friendly Linux distribution probably already has a package. For other OSs one should [go here](http://site.icu-project.org/download).

### Building From Source

If there are no builds for your OS or you simply prefer to compile programs yourself then first you will have to get the code. Download the version you would want or clone the source repository:

```
git clone https://github.com/ironsmile/euterpe.git
cd euterpe
```

Running `go install` in the project root directory will compile `euterpe` and move its binary in your `$GOPATH`. Releases from `v1.0.1` onward have their go dependencies vendored in so that don't have to hunt them down.

If you want to install the latest development version from the `master` branch, you can just run

```
go install github.com/ironsmile/euterpe
```

In the root of the project run

```
make release
```

This will produce a binary `euterpe` which is ready for distribution. Check its version with

```
./euterpe -v
```

If you want to build a particular version first checkout it and then build. For example:

```
git checkout v1.4.0
make release
```
