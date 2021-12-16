+++
fragment = "content"
weight = 100

title = "Configuration"

[sidebar]
  sticky = true
+++

### Configuration Location

The configuration is stored in a JSON file. Every user on the system has their own configuration file. For a Unixy OS it is located in ```$HOME/.euterpe/config.json```. For Windows users it is in ```%APPDATA%\euterpe\config.json```. The configuration file will be created for you on the first run. The default configuration options can be found in [here](https://github.com/ironsmile/euterpe/blob/master/src/config/config.go).

### Example File

Here is an example configuration with explanation for its directives.

```javascript
{
    // Address and port on which Euterpe will listen. It is in the form hostname[:port]
    // For exact explanation see the Addr field in the Go's net.http.Server
    // Make sure the user running Euterpe have permission to bind on the specified
    // port number
    "listen": ":443",

    // true if you want to access Euterpe over HTTPS or false for plain HTTP.
    // If set to true the "ssl_certificate" field must be configured as well.
    "ssl": true,

    // Provides the paths to the certificate and key files. Must be full paths, not
    // relatives. If "ssl" is false this can be left out.
    "ssl_certificate": {
        "crt": "/full/path/to/certificate/file.crt",
        "key": "/full/path/to/key/file.key"
    },

    // true if you want the server to require HTTP basic authentication. Credentials
    // are set by the 'authentication' field below.
    "basic_authenticate": true,
    
    // User and password for the HTTP basic authentication.
    "authentication": {
        "user": "example",
        "password": "example",

        // This secret is used for generating session and device JWT tokens.
        // It has to be completely random string, different for every installation.
        "secret": "some-random-string"
    },

    // An array with all the directories which will be scanned for media. They must be
    // full paths and formatted according to your OS. So for example a Windows path
    // have to be something like "D:\Media\Music".
    // As expected Euterpe will need permission to read in the library folders.
    "libraries": [
        "/path/to/my/files",
        "/some/more/files/can/be/found/here"
    ],
    
    // Optional configuration on how to scan libraries. Note that this configuration
    // is applied to each library separately.
    "library_scan": {
        // Will wait this much time before actually starting to scan a library.
        // This might be useful when scanning is resource hungry operation and you
        // want to postpone it on start up.
        "initial_wait_duration": "1s",
        
        // With this option a "operation" is defined by this number of scanned files.
        "files_per_operation": 1500,

        // After each "operation", sleep this amount of time.
        "sleep_after_operation": "15ms"
    },

    // When true, Euterpe will search for images on the internet. This means album artwork
    // and artists images. Cover Art Archive is used for album artworks when none is
    // found locally. And Discogs for artist images. Anything found will be saved in
    // the Euterpe database and later used to prevent further calls to the archive.
    "download_artwork": true,

    // If download_artwork is true the server will try to find artist artwork in the
    // Discogs database. In order for this to work an authentication is required
    // with their API. This here must be a personal access token. In effect the server
    // will make requests on your behalf.
    //
    // See the API docs for more information:
    // https://www.discogs.com/developers/#page:authentication,header:authentication-discogs-auth-flow
    "discogs_auth_token": "some-personal-token"
}
```

### Directives

The JSON can store the following list of directives. Everything else is ignored.

* **listen** (_string_) - Address and port on which the server will listen. You will have to point your browser to thsi address to listen to your music. Examples: ":80", "example.com", "127.0.0.1:8080", ":http", "127.0.0.1:443"

* **libraries** (_array with strings_) - Places on the filesystem where your media files are stored. Examples: ["/home/user/Music"], ["C:\Users\user\My Music", "D:\mp3"]

* **ssl** (_boolean_) - If true the server will use the certificate stored in ```ssl_certificate``` in order to server your content over https. Note that you are responsible for setting the right port number in the ```listen``` directive. Examples: true, false.

* **ssl_certificate** (_object_) - Contains the paths to the certificate files. Example: {"crt": "/path/to/crt", "key": "/path/to/key"}.
  * **crt** (_string_) - Path to the certificate file. Use an absolute path.
  * **key** (_string_) - Path to the certificate ket. Use an absolute path.

* **basic_authenticate** (_boolean_) - If true the webserver will require basic authentication on every request. Authentication is in the ```authentication``` directive. Examples: true, false.

* **authentication** (_object_) - Contains the basic authentication user and password. Example: {"user": "test", "password": "testpassword", "secret": "not-so-secret"}.
  * **user** (_string_) - authentication username
  * **password** (_string_) - authentication password
  * **secret** (_string_) - A random string which will be used for signing JWT for devices and browser sessions when authentication is enabled.

* **download_artwork** (_boolean_) - When true, Euterpe will search Cover Art Archive for album artworks when none is found locally. Anything found will be saved in the Euterpe database and later used instead of further calls to the archive. By default it is "false".

* **discogs_auth_token** (_string_) - If download_artwork is true the server will try to find artist artwork in the Discogs database. In order for this to work an authentication is required with their API. This here must be a personal access token. In effect the server will make requests on your behalf. See the [Discogs API docs](https://www.discogs.com/developers/#page:authentication,header:authentication-discogs-auth-flow) for more information on how to generate your own token.

### Danger Zone

You are discouraged to touch any of the following directives. But if you really need want to, read the following carefully.

* **log_file** (_string_) - The name of logfile. Euterpe will store logs in it. It will be truncated on every start. If the given path is relative it will be relative to the config directory.

* **sqlite_database** (_string_) - Name of the sqlite database in which information for the media files will be stored. If the given path is relative it will be relative to the config directory.

* **gzip** (_boolean_) - If true the HTTP server will gzip its HTTP responses when appropriate.

* **read_timeout** (_integer_) - Maximum number of seconds which the webserver will read the incoming requests. If request takes too long to send its request it will be terminated.

* **write_timeout** (_integer_) - Maximum number of seconds the webserver will be sending the response to the client. Take note of this if you have particularly large media files. Make sure it is more than it takes for your file to download.

* **max_header_bytes** (_integer_) - The maximum size of the request headers in bytes. If a larger reuquest is sent it will be ignored.
