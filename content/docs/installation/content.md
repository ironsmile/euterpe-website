+++
fragment = "content"
weight = 100

title = "Installation"

[sidebar]
  sticky = true
+++

### Released Versions

The safest route is installing [one of the releases](https://github.com/ironsmile/euterpe/releases).

#### Linux & macOS

If you have [one of the releases](https://github.com/ironsmile/euterpe/releases) (for example `euterpe_1.1.0_linux.tar.gz`) it includes an `install` script which would install Euterpe in `/usr/bin/euterpe`. You will have to uninstall any previously installed versions first. An `uninstall` script is provided as well.

#### Windows

Automatically creating a release version for Windows is in progress at the moment. For the time being check out the next section, "From Source". Pay attention to the requirements. As of writing this the author hasn't been yet initiated in the secret art of building and installing libraries on Windows so you are on your own.

### Requirements For Building

* [Go](http://golang.org/) 1.16 or later [installed and properly configured](http://golang.org/doc/install).

* [taglib](https://taglib.org/) - Read the [install instructions](https://github.com/taglib/taglib/blob/master/INSTALL.md) or better yet the one inside your downloaded version. Most operating systems will have it in their package manager, though. Better use this one.

* [International Components for Unicode](http://site.icu-project.org/) - The Euterpe binary dynamically links to `libicu`. Your friendly Linux distribution probably already has a package. For other OSs one should [go here](http://site.icu-project.org/download).


### From Source (any OS)

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

Or alternatively, if you want to produce a release version you will have to get the repository. Then in the root of the project run

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
