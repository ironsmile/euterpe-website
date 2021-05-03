+++
fragment = "content"
weight = 100

title = "First Run"

[sidebar]
  sticky = true
+++

Once installed, you are ready to use your media server. After its initial run it will create a configuration file which you will have to edit to suit your needs.

1. Start it with ```httpms```

2. [Edit the config.json](/docs/configuration) and add your library paths to the "library" field. This is an *important* step. Without it, `httpms` will not know where your media files are.
