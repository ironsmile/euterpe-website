---
title: "GTK Client"
date: 2021-11-01T07:00:03+03:00
draft: false
fragment: "content"
weight: 100
display_date: true
sidebar:
  align: "right"
categories:
  - "Blog"
asset:
  image: gtk-client-alpha.png
---

For some time now I've been working on a [GTK client for Euterpe](https://github.com/ironsmile/euterpe-gtk/). One meant to work on both mobile and desktop Linux. Think about phones such as [PinePhone](https://en.wikipedia.org/wiki/PinePhone), [Librem 5](https://en.wikipedia.org/wiki/Librem_5). But about your homey Linux on the desktop machine too.

It is still a very early alpha and certainly misses almost all of the features one expects from a media player. But I've reached a state where one could actually use it to play music from their server, albeit by manually clicking on every song after one finishes. So I decided this might be a good time to announce it. This is what will be getting my attention the new few week whenever I have some free time.

### But Why?

Well, mainly because I've seen that there is a distinct lack of good software for the mobile Linux. Most of the programs are desktop-first and only then shoehorned into fitting the mobile display. And it shows. The only good media player is [Lollypop](https://wiki.gnome.org/Apps/Lollypop) but it requires you to copy all your music on the phone. Granted, this is extremely easy for a Linux phone (looking at you, Apple!). But some streaming wouldn't be bad, would it? I hear there's a Spotify client but we [don't want that]({{< ref "own-the-music-you-listen-to" >}}).

I've searched a way to create a Lollypop plug-in but no luck there. It does not have any plug-in system. So I decided to try my hand on a full GTK application and possibly bring Euterpe streaming to the hordes of thirsty Linux phone users out there!

## How?

I've decided to create a convergent application. One which would work from the same codebase on the desktop as well as on the mobile. GTK seems like a good choice since there is the [Libhandy](https://gitlab.gnome.org/GNOME/libhandy) which would hopefully take care of most of the convergent stuff. I've decided to write in Python as it seems like the easiest way to go about it. And it helps hat Lollypop is written the same way so that I could use it for inspiration and learning resource. Remember, this is my first full GTK application.

For the playback back-end I am using Gstreamer. Have to say that I am consistently impressed with how extremely good this project is. Both in capabilities and documentation. It puts to shame the Android sprawl of media libraries, APIs and conventions.

And if everything aligns just right then I might be able to build the player for Windows and macOS too. Don't get your hopes too high since I haven't seen this done for most of the rest of GTK applications so it probably is hard. I will give it a try nonetheless.

At some point I might decide to port the application to Go. Mainly because I suspect it will work much faster and use far less resources. This is very important for mobile environments, remember. I didn't start with this outright since it seems that Go is not considered a first-class citizen by the GNOME/GTK developers and I didn't want to spend time dealing with its GTK integration on top of everything else. Not to mention that cross compiling will probably be a pain.

## OK, So What Now?

I will be improving the Client bit by bit. Once it is somewhat useful for finding and playing an album then I will release its first version. For the time being I am planning on distributing it via Flatpak. If you want to try it out then clone [the repository](https://github.com/ironsmile/euterpe-gtk/) and run the following:


```
meson . _build --prefix=/usr
ninja -C _build
sudo ninja -C _build install
```

Make sure you have `libhandy` 1.x and Gstreamer installed. Happy listening!
