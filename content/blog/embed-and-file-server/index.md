---
title: "Go's embed.FS and http.FileServer interact unexpectedly"
date: 2024-09-29T15:44:03+03:00
draft: false
fragment: "content"
weight: 100
display_date: true
sidebar:
  align: "right"
categories:
  - "Blog"
---

At least it was unexpected for me. Let me explain. Suppose you are using [Go](https://pkg.go.dev/) and want to embed some files into your program's binary and then serve them over HTTP. This is something which Euterpe does too. In this scenario you will very likely arrive at the conclusion that using [embed](https://pkg.go.dev/embed) and [http.FileServer](https://pkg.go.dev/net/http#FileServer) will be the most straightforward solution. To the point where it is actually an example in the `embed` module. And this works very well except the surprising part:

> The Last-Modified header is not set. So no browser caching!

While Last-Modified and If-Modified-Since are working just fine if you are using [http.Dir](https://pkg.go.dev/net/http#Dir), [os.DirFS](https://pkg.go.dev/os#DirFS) and similar. What gives? The embedded files will surely not change so they must be an ideal candidate for caching. Here's the networking tab of Euterpe when opening its main page after few refreshes:

![Firefox Dev Tools tab showing all files were downloaded](network-no-caching.png "Screenshot of the Firefox dev tools")

All the favicons, all the CSS files, all the JS files! Downloaded again and again on every page load. They are not much, Euterpe does its best to be very lean. But still, this is wasted traffic.

So why? First of all, it is not a bug. The crux of the matter is that first, the [HTTP library does not set the Last-Modified header when the content's modification time is zero](https://cs.opensource.google/go/go/+/refs/tags/go1.23.1:src/net/http/fs.go;l=616-620). Here's the code:

```go
func setLastModified(w ResponseWriter, modtime time.Time) {
	if !isZeroTime(modtime) {
		w.Header().Set("Last-Modified", modtime.UTC().Format(TimeFormat))
	}
}
```

This is only natural and there's no way around it. And second, `embed.FS` [returns zero modification time](https://cs.opensource.google/go/go/+/refs/tags/go1.23.1:src/embed/embed.go;l=220) for its files. Which is the following code:

```go
// A file is a single file in the FS.
// It implements fs.FileInfo and fs.DirEntry.
type file struct {
  // omitted
}

func (f *file) ModTime() time.Time         { return time.Time{} }
```

So in the end the question becomes "why is embed.FS returning zero time?". It could've easily opted into doing other things. For example, storing the modification time of the embedded files along with their content. Or maybe using the time of building the binary as the modification time for all files in the embedded file system. At this point I will have to make the conjecture that the choice was due to desire for [reproducible builds](https://go.dev/blog/rebuild) which will be fair enough. If one stores timestamps in the binary which may be different on every build one will not be able to achieve reproducible builds.

So what do we do from here? Give up and waste traffic for data which could've been cached forever? Well, no! I've decided to fix the situation to the best of my ability with a small module - [wrapfs](https://github.com/ironsmile/wrapfs). It provides a wrapper around a file system (`fs.FS`) which will replace any zero modification time with a set `time.Time` value.

It is used like so:

```go
	modTimeFS := wrapfs.WithModTime(maybeEmbedFS, time.Now())
	_ = http.FileServer(http.FS(modTimeFS))
```

It works with all ways one could receive a modification time. This means all avenues for calling `fs.File.Stat`, `fs.DirEntry.Info`, it is aware of `fs.StatFS`, `fs.ReadDirFS` and `fs.SubFS` implementations. After using it in Euterpe this is how the network tab in the dev tools looks like:

![Firefox Dev Tools tab showing cached files](network-caching-with-wrapfs.png "Another screenshot of the Firefox dev tools")

Sweet, sweet 304 status codes! I've chosen to set the modification time to `time.Now()` on every process start. So after a server restart the browsers' cache will be invalidated. This is still a huge improvement over the status quo, in my opinion. My personal Euterpe instance, for example, is restarted only on new releases which is normally a period of many months.

So, this is it. I've created [wrapfs](https://github.com/ironsmile/wrapfs) as a separate module in hope it may be useful to other people. If at some point it causes a measurable reduction of internet traffic coming out of Go applications I will be more than happy. The next version of Euterpe will certainly make use of `wrapfs`. In fact, this has already been merged into its `master` branch.
