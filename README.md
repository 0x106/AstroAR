# Astro AR

This project demonstrates the Astro system for creating Javascript based AR "micro::apps",
that can be run in any existing iOS application.

Imagine that in the future it's common to have AR content inside retail stores. How does this
content get there? Does every store have their own app? Does someone have to download a new
app for every store they walk in to?

It's likely that apps will become more ephemeral, with content becoming available
in a much more transient fashion. This means that content will need to be injected
into existing apps that may be running on a host phone. For example someone is walking around
using Snapchat (with the camera open), the app detects the location of the user, makes a request
to a server for the appropriate AR content, and then loads the experience. On the web this is
easy, but how do we achieve this in a native context? We can't inject compiled Swift (to the best
  of my knowledge).

The solution is to build a Javascript wrapper around a native Swift AR API.

To build an AR 'micro::app' you write a small section of Javascript, which instructs the Swift
engine how to build and run the 3D scene. With this mechanism you can add any type of functionality
you like, which makes it immensely powerful. In theory you can even pull in any Javascript you like,
which means that you actually get the full power of web technology, running inside a native Swift application.

Note that small portions of this work have been developed by [Alberto](https://github.com/snowzurfer).
This repo is a subset of prior work we did together, however I've attempted to only extract the code that
I wrote.

**Creating Experiences**

1. Visit [dashboard.astro.codes](https://dashboard.astro.codes)
2. Create the experience / click publish -- you're done!

Note that this project is a demo of what is possible mixing Javascript and Swift, and is therefore only minimally functional.
It's not intended to actually be used to create experiences outside of small tests.

<!-- end -->
