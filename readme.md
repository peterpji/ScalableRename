# Yet another unit naming mod
This mod is for game Supreme Commander Forced Alliance and meant to be used with FA Forever community project.
It is based on "Veterename" by Cobrand (Published here: https://forums.faforever.com/viewtopic.php?f=41&t=11382).

It aims to expand on existing mod by:
* Exclude some units
    * Inties, asf
    * Structures?
* Allow easily dividing names into pools. E.g.
    * One name pool for T4
    * One name pool for the rest
* Not too frequent naming
    * Logarithmic name frequency - naming frequency decreases quickly in order to avoid spamming
    * Frequency is separate per tier and domain (land, air and navy)

## Original mod_info.lua
```lua
name = "Veterename"
uid = "EE500612-B7E6-48DF-A24A-B30645A88D5E"
version = 2
copyright = ""
description = "Renames veteran units"
author = "Cobrand"
url = ""
selectable = true
enabled = true
exclusive = false
ui_only = true
requires = {}
requiresNames = {}
conflicts = {}
before = {}
after = {}
```
