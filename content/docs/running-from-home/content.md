+++
fragment = "content"
weight = 100

title = "Seting Up From Home Network"

[sidebar]
  sticky = true
+++

So, you've installed Euterpe on your home computer and you like it. Now what? How do you make it accessible from the internet?

The answer is, as with many things in life, "it depends". If you're running it on your home computer then you will have to expose it to the internet and this is relatively easy if you have a static IP. You will have to ask your ISP for that if you don't know what I am talking about. If you don't have a static IP then it gets a little bit harder but still, it is possible.

The first step, either way, is to make sure the Euterpe server is listening on your network interface. Which you could do by [configuring](https://listen-to-euterpe.eu/docs/configuration/#directives) the `listen` address to something like `0.0.0.0:9996`. So [your config.json](https://listen-to-euterpe.eu/docs/configuration/#configuration-location) will become similar to

```js
{
    "listen": "0.0.0.0:9996",
    // other stuff we don't care about at the moment
}
```

After editing the file restart Euterpe. This will make sure it listens on port 9996 for all network interfaces. By default this is disabled and set to only listening to `localhost` for security reasons. It prevents you from accidentally leaking your music or opening up network ports to the wide world. You do that explicitly by editing the `config.json`.

If you are running Euterpe on a machine that is facing the public internet then that's it! You can go to `http://<your-machine-public-ip>:9996` and you would see the web interface. Such machines are typically servers or virtual machines on public clouds as you suggested.

But probably you are using a home network and your router is doing [NAT](https://en.wikipedia.org/wiki/Network_address_translation) for you. Then you will have to go into its configuration and search for something like "Port Forwarding" or "Port Triggering", or something very similar. In there make a rule to forward port 9996 TCP traffic to your home machine's (the one which runs Euterpe) IP on the same port 9996. Once that is done you could go to `http://<your-static-IP>:9996` and you would see the web interface, assuming you have a static IP for this router as discussed above.

If you don't have a public IP then you will have to use a service such as https://www.noip.com/. It requires cooperation between your router and the service and probably some account. There's [documentation on the noip.com website for that](https://www.noip.com/remote-access/computer). Once this is done you will have your Euterpe exposed to the internet through the noip method. Follow their documentation to find out what address you could use. Of course, there are other providers of the same service, for example [dyn](https://account.dyn.com/). Choose whichever you like most or whichever has an integration with your router.

That's it 😅 Of course, if you already have a web server under your control running anywhere then you could decide to run Euterpe behind. Here's the docs for [Nginx](/docs/deploy-behind-nginx/) and [Apache](/docs/deploy-behind-apache/) which explain how you do that. This has the benefit that you won't have to open additional ports to the internet.

I hope this is not too much! I am considering switching the default listening address for Euterpe to `0.0.0.0:9996` anyway in the future. Which will make the first step, editing `config.json`, unnecessary.
