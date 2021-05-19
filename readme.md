# Yet another unit naming mod
This mod is for game Supreme Commander Forced Alliance and meant to be used with FA Forever community project.
It is based on "Veterename" by Cobrand (Published here: https://forums.faforever.com/viewtopic.php?f=41&t=11382).
The previous author gives permission to modify the work in the blog post: "If you want to customize it and release an enhanced version go ahead, you have my permission to do the f*** you want my this mod".

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

Disclaimer: I have not tested the performance impact of this mod on very long games. If you discover any significant adverse effect on the game performance, please let me know e.g. via a GitHub issue.

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
