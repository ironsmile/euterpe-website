---
title: "Version 1.6.0 Released"
date: 2025-06-07T15:40:03+03:00
draft: false
fragment: "content"
weight: 100
display_date: true
sidebar:
  align: "right"
categories:
  - "Blog"
---

It has been just a bit more than two years since the last release of Euterpe. Throughout all of this time I've been (slowly) improving it and adding new features. But never felt comfortable creating a new release since many things were in progress and nothing quite ready.

Well, this is still mostly the case. But I've been using the development version continuously and decided that enough is enough. Last few weeks were spent thoroughly testing the server and writing many new unit tests. And with the last few bugs here and there squashed out it was as ready as it gonna be.

The main feature of the release 1.6.0 is Subsonic API support. This opens Euterpe to be used by a plethora of clients. After many years of writing Euterpe music players for each and every operating system I could think of I decided that there might be a better way. By working with all of the excellent Subsonic clients out there the server will be way more useful, I hope. The new API is not yet fully implemented yet but enough is so that one could aim any random Subsonic client towards an Euterpe server and I think it will be fine. The current progress of the API implementation could be followed through the [progress.md](https://github.com/ironsmile/euterpe/blob/master/src/webserver/subsonic/progress.md) file in the Euterpe repository.

The Euterpe API is not going away as well. Actually, it has been greatly improved for this release. And it also exposes a new playlists functionality. You shouldn't worry about the future of the built-in web client, the [Rhythmbox plug-in](https://github.com/ironsmile/euterpe-rhythmbox) and the [Euterpe GTK](https://github.com/ironsmile/euterpe-gtk/) program. They are all using the Euterpe API and will continue to be improved. Especially the web client which could be greatly enhanced by taking advantage of the new APIs. The only change I can envision is archiving the [React Native](https://github.com/ironsmile/euterpe-mobile) mobile client. Keeping up with this ecosystem has been an nightmare and the lack of newer versions isn't due to lack of effort, let me tell you.

With all of this said, let us get to the meat of the new release. What follows is a heavily compressed overview of 131 git commits which include more than 18 thousand lines of new code written for this version:

```
git history v1.5.4...v1.6.0 -- ./src/
...skipping...
 132 files changed, 18007 insertions(+), 548 deletions(-)
```

### Version 1.6.0 Change Log

This one of the biggest improvements of Euterpe so far. As always, it retains API backwards compatibility with older Euterpe versions.

**Subsonic API**

This release adds preliminary support of the [Subsonic API](https://www.subsonic.org/pages/api.jsp) v1.16.1. More specifically its [Open Subsonic](https://opensubsonic.netlify.app/) flavour. The API implementation is not complete yet but is comprehensive enough for everyday use. What's not yet ready is podcasts, public shares, bookmarks and some small API endpoints. Keep up with the implementation progress by watching the [progress document](https://github.com/ironsmile/euterpe/blob/master/src/webserver/subsonic/progress.md).

The server has been tested with numerous Subsonic clients and the following have been vetted to work really well with the current state of the implementation:

* Supersonic (Linux, Mac, Windows)
* play:Sub (iOS)
* Amperify (iOS)
* Substreamer (iOS)

**What is New**

* Browsing the library by songs is now possible via the API.
* The API now returns much more data for albums, artists and tracks:
  - Number of plays
  - Time of the last play
  - User rating
  - When an item has been added to a favourites list
  - Track bitrate and album average bitrate
  - Release year for albums and tracks
  - Track size in bytes
* New ways for ordering tracks, albums an artists while browsing:
  - By year when applicable
  - By play frequency
  - By play recency
* A new API endpoints for playlists management have been added
* A new API endpoint /v1/about. It includes information about the Euterpe server version.

**Bug Fixes**

* Artist images are now cleaned up from the database as well when an artist entry has been removed.
* The web UI will now properly take advantage of browser caches for its static files.
* Improved media tag reading, especially for Vorbis.
* There was a bug which caused some tracks to never be removed from the database even though they're no longer on disk. This has been fixed.

### The Future

With this big release out of the way now it will be easier to continuously make and release smaller improvements. At a much rapid pace, one could hope. The main areas I will focus on in the near future are completing the Subsonic API coverage, the built-in web client and the GTK client. I am getting a lot of usage from the last one and working on it has been a joy.
