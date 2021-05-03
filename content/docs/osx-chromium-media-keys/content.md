+++
fragment = "content"
weight = 100

title = "OSX + Chrome Media Keys"

[sidebar]
  sticky = true
+++


You can control your Euterpe web interface with the media keys the same way you can control any native media player. To achieve this a third-party program is required: [BearderSpice](https://beardedspice.github.io/). Sadly, Euterpe (HTTPMS) is [not included](https://github.com/beardedspice/beardedspice/pull/684) in the default web strategies bundled-in with the program. You will have to import the [strategy](https://github.com/beardedspice/beardedspice/tree/disco-strategy-web#writing-a-media-strategy) [file](https://github.com/ironsmile/httpms/blob/master/tools/bearded-spice.js) included in the Euterpe repo.

How to do it:

1. Install BeardedSpice. Here's the [download link](https://beardedspice.github.io/#download)
2. Then go to BeardedSpice's Preferences -> General -> Media Controls -> Import
3. Select the [bearded-spice.js](https://github.com/ironsmile/httpms/blob/master/tools/bearded-spice.js) strategy from Euterpe's repo

Or with images:

BeardedSpice Preferences:

![BS Install Step 1](barded-spice-install-step1.png)

Select "Import" under Genral tab:

![BS Install Step 2](barded-spice-install-step2.png)

Select the [bearded-spice.js](tools/bearded-spice.js) file:

![BS Install Step 3](barded-spice-install-step3.png)

Then you are good to go. Smash those media buttons!
