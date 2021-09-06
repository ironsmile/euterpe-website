+++
fragment = "content"
weight = 100

title = "Nginx Configuration"

[sidebar]
  sticky = true
+++

Maybe you already have an [Nginx](https://nginx.org/en/) server running on your machine
and want to take advantage of it when deploying Euterpe. It makes sense to leave Nginx
handle the TLS, server multiplexing and similar things.

I will show two types of configurations here. For when you want your Euterpe to be
visible on its own domain or sub-domain. Or alternatively, when you want to have it
running under a predefined path on a shared domain.

For the rest of the document **assume that Euterpe is running at 127.0.0.1:9996** (which
is the default).

### Own (sub)domain

This is the easiest way to run Euterpe behind Nginx. Say, you want to have your Euterpe
installation at `euterpe.example.com`. Then just use the following Nginx config:

```
server {
    listen 80;
    server_name euterpe.example.com;

    location / {
        proxy_pass http://127.0.0.1:9996;

        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto http;
        proxy_set_header X-Forwarded-Port 80;
        proxy_set_header Host $host;
    }
}
```

This will make your Euterpe accessible at `http://euterpe.example.com`.

### With Path Prefix

In case you don't have a domain or a sub-domain then you might want to have Euterpe
running on some path of your web server, e.g. `http://example.com/euterpe/`.

This is slightly more involved. The Euterpe server is not exactly designed for
this out of the box but some Nginx configuration magic could work-around this. In
order for this to work, Nginx must be compiled with [ngx_http_sub_module](https://nginx.org/en/docs/http/ngx_http_sub_module.html).
This is the case for most Debian/Ubuntu based Linux distributions.

Then add this block to your server's configuration:

```
location /euterpe/ {
        proxy_pass http://127.0.0.1:9996/;
        proxy_redirect / /euterpe/;
        sub_filter 'href="/' 'href="/euterpe/';
        sub_filter 'src="/' 'src="/euterpe/';
        sub_filter 'content="/' 'content="/euterpe/';
        sub_filter 'case "/":' 'case "/euterpe/":';
        sub_filter 'case "/login/":' 'case "/euterpe/login/":';
        sub_filter 'case "/add_device/":' 'case "/euterpe/add_device/":';
        sub_filter '/v1/' '/euterpe/v1/';
        sub_filter '/new_qr_token/' '/euterpe/new_qr_token/';
        sub_filter 'serverAddress = window.location.protocol + "//" + window.location.host' 'serverAddress = window.location.protocol + "//" + window.location.host + "/euterpe/"';
        sub_filter_types *;
        sub_filter_once off;
        sub_filter_last_modified on;
        proxy_set_header Accept-Encoding "";

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto http;
        proxy_set_header X-Forwarded-Port 80;
        proxy_set_header Host $host;
}
```

This will expose your Euterpe installation at the `/euterpe/` path of your server.

Note that this variant places some stress on your Nignx server and might cause some
problems here or there. Consider switching to own domain or sub-domain as shown in the
above section.
