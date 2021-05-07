+++
fragment = "content"
weight = 100

title = "API"

[sidebar]
  sticky = true
+++

You can use Euterpe as a REST API and write your own player. Or maybe a plugin for your favourite player which would use your Euterpe installation as a back-end.

### v1 Compatibility Promise

The API presented here under the `/v1/` prefix is stable and will continue to be supported as long as version one of the service is around. And this should be very _long time_. I don't plan to make backward incompatible changes. Ever. It has survived in this form since 2013. So it should be good for at least double than this amount of time in the future.

This means that **clients written for Euterpe will continue to work**. I will never break them on purpose and if this happened it will be considered a bug to be fixed as soon as possible.

### Authentication

When your server is open you don't have to authenticate requests to the API. Installations protected by user name and password require you to authenticate requests when using the API. For this the following methods are supported:

* Bearer token in the `Authorization` HTTP header (as described in [RFC 6750](https://tools.ietf.org/html/rfc6750)):

```
Authorization: Bearer token
```

* Basic authentication ([RFC 2617](https://tools.ietf.org/html/rfc2617)) with your username and password:

```
Authorization: Basic base64(username:password)
```

Authentication tokens can be acquired using the `/v1/login/token/` endpoint described below. Using tokens is the preferred method since it does not expose your username and password in every request. Once acquired users must _register_ the tokens using the `/v1/register/token/` endpoint in order to "activate" them. Tokens which are not registered may or may not work. Tokens may have expiration date or they may not. Integration applications must provide a mechanism for token renewal.

### Endpoints

* [Search](#search)
* [Browse](#browse)
* [Play a Song](#play-a-song)
* [Download an Album](#download-an-album)
* [Album Artwork](#album-artwork)
    * [Get Artwork](#get-artwork)
    * [Upload Artwork](#upload-artwork)
    * [Remove Artwork](#remove-artwork)
* [Artist Image](#artist-image)
    * [Get Artist Image](#get-artist-image)
    * [Upload Artist Image](#upload-artist-image)
    * [Remove Artist Image](#remove-artist-image)
* [Token Request](#token-request)
* [Register Token](#register-token)

### Search

One can do a search query at the following endpoint

```sh
GET /v1/search/?q={query}
```

wich would return an JSON array with tracks. Every object in the JSON represents a single track which matches the `query`. Example:

```js
[
   {
      "album" : "Battlefield Vietnam",
      "title" : "Somebody to Love",
      "track" : 10,
      "artist" : "Jefferson Airplane",
      "artist_id": 33,
      "id" : 18,
      "album_id" : 2,
      "format": "mp3",
      "duration": 180000
   },
   {
      "album" : "Battlefield Vietnam",
      "artist" : "Jefferson Airplane",
      "track" : 14,
      "format": "flac",
      "title" : "White Rabbit",
      "album_id" : 2,
      "id" : 22,
      "artist_id": 33,
      "duration": 308000
   }
]
```

The most important thing here is the track ID at the `id` key. It can be used for playing this track. The other interesting thing is `album_id`. Tracks can be grouped in albums using this value. And the last field of particular interest is `track`. It is the position of this track in the album.

Note that the track duration is in milliseconds.

### Browse

A way to browse through the whole collection is via the browse API call. It allows you to get its albums or artists in an ordered and paginated manner.

```sh
GET /v1/browse/[?by=artist|album][&per-page={number}][&page={number}][&order-by=id|name][&order=desc|asc]
```

The returned JSON contains the data for the current page, the number of all pages for the current browse method and URLs of the next or previous pages.

```js
{
  "pages_count": 12,
  "next": "/v1/browse/?page=4&per-page=10",
  "previous": "/v1/browse/?page=2&per-page=10",
  "data": [ /* different data types are returned, determined by the `by` parameter */ ]
}
```

For the moment there are two possible values for the `by` parameter. Consequently there are two types of `data` that can be returned: "artist" and "album" (which is the **default**).

**by=artist**

would result in value such as

```js
{
  "artist": "Jefferson Airplane",
  "artist_id": 73
}
```

**by=album**

would result in value such as

```js
{
  "album": "Battlefield Vietnam"
  "artist": "Jefferson Airplane",
  "album_id": 2
}
```

**Additional parameters**

_per-page_: controls how many items would be present in the `data` field for every particular page. The **default is 10**.

_page_: the generated data would be for this page. The **default is 1**.

_order-by_: controls how the results would be ordered. The value `id` means the ordering would be done by the album or artist ID, depending on the `by` argument. The same goes for the `name` value. **Defaults to `name`**.

_order_: controls if the order would ascending (with value `asc`) or descending (with value `desc`). **Defaults to `asc`**.


### Play a Song

```
GET /v1/file/{trackID}
```

This endpoint would return you the media file as is. A song's `trackID` can be found with the search API call.

### Download an Album

```
GET /v1/album/{albumID}
```

This endpoint would return you an archive which contains the songs of the whole album.


### Album Artwork

Euterpe supports album artwork. Here are all the methods for managing it through the API.

#### Get Artwork

```
GET /v1/album/{albumID}/artwork
```

Returns a bitmap image with artwork for this album if one is available. Searching for artwork works like this: the album's directory would be scanned for any images (png/jpeg/gif/tiff files) and if anyone of them looks like an artwork, it would be shown. If this fails, you can configure Euterpe to search in the [MusicBrainz Cover Art Archive](https://musicbrainz.org/doc/Cover_Art_Archive/). By default no external calls are made, see the 'download_artwork' configuration property.

By default the full size image will be served. One could request a thumbnail by appending the `?size=small` query.

#### Upload Artwork

```
PUT /v1/album/{albumID}/artwork
```

Can be used to upload artwork directly on the Euterpe server. This artwork will be stored in the server database and will not create any files in the library paths. The image should  be send in the body of the request in binary format without any transformations. Only images up to 5MB are accepted. Example:

```sh
curl -i -X PUT \
  --data-binary @/path/to/file.jpg \
  http://127.0.0.1:9996/v1/album/18/artwork
```

#### Remove Artwork

```
DELETE /v1/album/{albumID}/artwork
```

Will remove the artwork from the server database. Note, this will not touch any files on the file system. Thus it is futile to call it for artwork which was found on disk.

### Artist Image

Euterpe could build a database with artists' images. Which it could then be used throughout the interfaces. Here are all the methods for managing it through the API.

#### Get Artist Image

```
GET /v1/artist/{artistID}/image
```

Returns a bitmap image representing an artist if one is available. Searching for artwork works like this: if artist image is found in the database then it will be used. In case there is not and Euterpe is configured to download images from interned and has a Discogs access token then it will use the MusicBrainz and Discogs APIs in order to retrieve an image. By default no internet requests are made.

By default the full size image will be served. One could request a thumbnail by appending the `?size=small` query.

#### Upload Artist Image

```
PUT /v1/artist/{artistID}/image
```

Can be used to upload artist image directly on the Euterpe server. It will be stored in the server database and will not create any files in the library paths. The image should  be send in the body of the request in binary format without any transformations. Only images up to 5MB are accepted. Example:

```sh
curl -i -X PUT \
  --data-binary @/path/to/file.jpg \
  http://127.0.0.1:9996/v1/artist/23/image
```

#### Remove Artist Image

```
DELETE /v1/artist/{artistID}/image
```

Will remove the artist image the server database. Note, this will not touch any files on the file system.

### Token Request

```
POST /v1/login/token/
{
  "username": "your-username",
  "password": "your-password"
}
```

You have to send your username and password as a JSON in the body of the request as described above. Provided they are correct you will receive the following response:

```js
{
  "token": "new-authentication-token"
}
```

Before you can use this token for accessing the API you will have to register it with on "Register Token" endpoint.

### Register Token

```
POST /v1/register/token/
```

This endpoint registers the newly generated tokens with Euterpe. Only registered tokens will work. Requests at this endpoint must authenticate themselves using a previously generated token.
