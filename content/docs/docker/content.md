+++
fragment = "content"
weight = 100

title = "Docker"

[sidebar]
  sticky = true
+++

### Using A Published Image

You can use the Euterpe [Docker image](https://hub.docker.com/r/ironsmile/euterpe) in order to try it out or actually deploy it.

```sh
docker run -v "${HOME}/Music/:/root/Music" -p 8080:9996 -d ironsmile/euterpe:latest euterpe
```

Then point your browser to [https://localhost:8080](https://localhost:8080) and you will see the Euterpe web UI. The `-v` flag in the Docker command will mount your `$HOME/Music` directory to be discoverable by Euterpe.

### Building the Image Yourself

First clone the [git repository](https://github.com/ironsmile/euterpe) and then building image is as simple as running the following

```docker build -t ironsmile/euterpe github.com/ironsmile/euterpe```

The `euterpe` binary there is placed in `/usr/local/bin/euterpe`.

Once image is built you can start the [same way as for published images](#using-a-published-image).
