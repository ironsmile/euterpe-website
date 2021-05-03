+++
fragment = "content"
weight = 100

title = "Docker"

[sidebar]
  sticky = true
+++

You can use the Euterpe [Docker image](https://github.com/ironsmile/httpms/blob/master/Dockerfile) in order to try it out or actually deploy it.

```docker build -t ironsmile/httpms github.com/ironsmile/httpms```

The `httpms` binary there is placed in `/usr/local/bin/httpms`.

Once image is built you can start the server by:

```sh
docker run -v "${HOME}/Music/:/root/Music" -p 8080:9996 -d ironsmile/httpms httpms
```

Then point your browser to [https://localhost:8080](https://localhost:8080) and you will see the Euterpe web UI. The `-v` flag in the Docker command will mount your `$HOME/Music` directory to be discoverable by Euterpe.
