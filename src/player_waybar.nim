import parseopt
import std/[strutils, osproc, json]

proc disconnected() =
  let output = %* {
    "class": "disconnected",
    "text": ""
  }
  echo output
  quit(0)
# TODO: Add nerd icon toggle
var nerd = false
var player: string
var maxTitleLength: int = 30
for kind, key, val in getopt():
  case kind
  of cmdArgument:
    discard
  of cmdLongOption, cmdShortOption:
    case key:
    of "nerd":
      nerd = true
    of "player":
      player = val
    of "maxTitleLength":
      maxTitleLength = parseInt(val)
  of cmdEnd:
    discard

let run = execCmdEx("""playerctl metadata --format '{"player": "{{playerName}}", "status": "{{lc(status)}}", "artist": "{{artist}}", "title": "{{title}}", "album": "{{album}}", "curPos": "{{duration(position)}}", "length": "{{duration(mpris:length)}}"}'""")
if run.exitCode == 1:
  disconnected()
let details = run.output
var items = parseJson(details)

if items["status"].getStr() == "stopped": disconnected()
if player.len != 0 and items["player"].getStr() != player: disconnected()

let status = items["status"].getStr()
let outputStatus = (case status
                    of "playing": ""
                    of "paused": ""
                    else: "")
let title = items["title"].getStr()
var outputTitle: string
if title.len > maxTitleLength:
  outputTitle = title[0 .. maxTitleLength-3] & "..."
else:
  outputTitle = title
let artist = items["artist"].getStr()
let album = items["album"].getStr()
# TODO: Add more player info like shuffle and track number
let output = %* {
  "text": outputStatus & "  " & artist & " - " & outputTitle,
  "class": status,
  "on-click": "playertcl play-pause",
  "tooltip": title &  " - " & artist & " (" & album & ")"
}

echo output
quit(0)
