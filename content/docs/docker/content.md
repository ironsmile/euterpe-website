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
docker run -v "${HOME}/Music/:/root/Music" -p 8080:9996 ironsmile/euterpe:latest euterpe
```

Then point your browser to [https://localhost:8080](https://localhost:8080) and you will see the Euterpe web UI. The `-v` flag in the Docker command will mount your `$HOME/Music` directory to be discoverable by Euterpe.

### Building the Image Yourself

First clone the [git repository](https://github.com/ironsmile/euterpe) and then building image is as simple as running the following

```docker build -t ironsmile/euterpe github.com/ironsmile/euterpe```

The `euterpe` binary there is placed in `/usr/local/bin/euterpe`.

Once image is built you can start the [same way as for published images](#using-a-published-image).

### Preserve Configuration and Database

Using the commands shown so far does have a downside and it is that the configuration file and the database will be wiped and created anew on every container start. The same goes for the program logs too. This is, probably, not very useful feature. One might want to preserve them between runs. One way is to use [Docker volumes](https://docs.docker.com/storage/volumes/). First, create a volume for your Euterpe installation:

```sh
docker volume create euterpe-data
```

And then the command for starting the container will become

```sh
docker run -v "euterpe-data:/root/.euterpe" \
    -v "${HOME}/Music/:/root/Music" \
    -p 8080:9996 \
    ironsmile/euterpe:latest euterpe
```

Now the logs, the database and the server configuration will persist between starting and stopping the container.

Obviously, you are free to use any other way for managing volumes. But explaining things such as Kubernetes and Docker Compose are outside of the scope of this documentation.
