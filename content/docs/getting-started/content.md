+++
fragment = "content"
weight = 100

title = "Getting Started"

[sidebar]
  sticky = true
+++

This guide will show you how to set-up the most basic Euterpe installation. At the end of it you will have it monitoring a single directory for music and its web UI will be accessible without authentication on your local machine.

For more advanced installation see the rest of the documentation.

### Option 1: Docker

This is the easiest way to get you started. The only thing you need is a working [Docker](https://www.docker.com/) installation. Once you do, build yourself the Docker Image:

```
docker build -t ironsmile/httpms github.com/ironsmile/httpms
```

Wooh, great! With the image in hand you can run the following (depending on your OS).

For Linux/MacOS/BSDs:

```
docker run -v "${HOME}/Music/:/root/Music" -p 8080:9996 -d ironsmile/httpms httpms -D
```

For Windows:

```
docker run -v "%userprofile%/Music/:/root/Music" -p 8080:9996 -d ironsmile/httpms httpms -D
```

Then point your browser to [http://localhost:8080](http://localhost:8080) and you will see the Euterpe web UI. The -v flag in the Docker command will mount your `Music` directory to be discoverable by Euterpe.

Note that the method above will build you an image which using the latest version on the `master` branch. Which might be unstable at times. You might want to choose a particular release tag instead.

For more details how to run effectively run Euterpe in a Docker container see the [Docker section of the documentation](/docs/docker).

### Option 2: Run Natively

Running software in a Docker image is easy at first but mounting directories will become old pretty fast. The main issue is harder access to the configuration file and the required volume management if one wants to preserve the Euterpe database, logs and configuration. You could do it and if you want to, read the [relevant documentation](/docs/docker). But if you just want to run the program without images and containers, continue reading this section.

The main goal is to have the `httpms` binary installed for your OS. Head over to the [installation section](/docs/installation) and follow the instructions. At the end of it you will have a `httpms` binary in your `$PATH` (for Linux/macOS/BSDs) or `httpms.exe` in your programs directory.

Then just run it with the `-D` flag and you will have Euterpe running and looking into your `Music` directory for files.

Linux/macOS/BSDs:

```
httpms -D
```

Windows:

```
.\httpms -D
```

With that done, point your browser to [http://localhost:9996](http://localhost:9996) and you should see the web UI!

### Add More Music Directories

At that point you might want to add a different directory (or "folder" in Microsoft parlance) with music. Maybe you have an external drive, or a network storage or you simily don't use your OS profile's Music directory. Then you will have to add a new library path in the configuration file. It will be at the following place:

* `/root/.httpms/config.json` for in the Docker image
* `$HOME/.httpms/config.json` for Linux/macOS/freeBSD
* `%APPDATA%\httpms\config.json` for Windows

Add your new directory under the `libraries` directive which is a JSON list.

### Further Set-Up

For more options and finer set-up check out the rest of the documentaion pages.
