+++
fragment = "content"
weight = 100

title = "Apache Configuration"

[sidebar]
  sticky = true
+++

Maybe you already have an [Apache](https://httpd.apache.org/) server running on your machine
and want to take advantage of it when deploying Euterpe. It makes sense to leave Apache
handle the TLS, server multiplexing and similar things.

I will show two types of configurations here. For when you want your Euterpe to be
visible on its own domain or sub-domain. Or alternatively, when you want to have it
running under a predefined path on a shared domain.

For the rest of the document **assume that Euterpe is running at localhost:9996** (which
is the default).

### Own (sub)domain

This is the easiest way to run Euterpe behind Apache. Say, you want to have your Euterpe
installation at `euterpe.example.com`. Then just use the following Apache config:

```
<VirtualHost *:80>
    ServerName euterpe.example.com

    <Location />
        ProxyPass http://localhost:9996/
        ProxyPassReverse http://localhost:9996/
    </Location>
</VirtualHost>
```

This will make your Euterpe accessible at `http://euterpe.example.com`.

### With Path Prefix

In case you don't have a domain or a sub-domain then you might want to have Euterpe
running on some path of your web server, e.g. `http://example.com/euterpe/`.

This is slightly more involved. The Euterpe server is not exactly designed for
this out of the box but some Apache configuration magic could work-around this. In
order for this to work, Apache must be compiled with
[mod_proxy_html](https://httpd.apache.org/docs/current/mod/mod_proxy_html.html),
[mod_headers](https://httpd.apache.org/docs/current/mod/mod_headers.html),
[mod_proxy_http](https://httpd.apache.org/docs/current/mod/mod_proxy_http.html) and
[mod_substitute](https://httpd.apache.org/docs/current/mod/mod_substitute.html).

Then add this block to your server's virtual host configuration:

```
<Location /euterpe/>
    ProxyPass http://localhost:9996/
    ProxyPassReverse http://localhost:9996/
    RequestHeader set "Accept-Encoding" ""
    Header edit "Location" "^\/((?!euterpe).*)" "/euterpe$0"

    ProxyHTMLEnable On
    ProxyHTMLLinks a href
    ProxyHTMLLinks link href
    ProxyHTMLLinks img src
    ProxyHTMLLinks script src
    ProxyHTMLURLMap / /euterpe/

    AddOutputFilterByType SUBSTITUTE application/javascript
    Substitute 's|/v1/|/euterpe/v1/|n'
    Substitute 's|"/new_qr_token|"/euterpe/new_qr_token|n'
    Substitute 's|"//" + window.location.host|"//" + window.location.host + "/euterpe/"|n'
    Substitute 's|case "/|case "/euterpe/|n'
</Location>
```

This will expose your Euterpe installation at the `/euterpe/` path of your server.

Note that this variant places some stress on your Apache server and might cause some
problems here or there. Consider switching to own domain or sub-domain as shown in the
above section.
