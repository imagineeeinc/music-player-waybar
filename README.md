# Music player waybar

A super light waybar module helper that shows the title of the current music playing from **playerctl** with the playback status using nerd icon.

## Usage

- Install [Nim](https://nim-lang.org)
- Compile with `nimble build -d:release`
  - Optional: add to PATH
- Use in waybar config, if application not installed in path, replace with location of program:
  ```json
  ...
  custom/music": {
      "format": "{}",
      "tooltip": true,
      "interval": 2,
      "exec": "player_waybar --player=Supersonic",
      "return-type": "json"
  }
  ...
- Configure options to run by passing arguments to configure output
  - `--player`: Set the player to filter by, one at a time is supported as of now
  - `--maxTitleLength`: Set the max length of the title to show, only pass integers. Default is 30
- Use as waybar module
- Ensure **playerctl** is installed and your music player supports [MPIRS](https://wiki.archlinux.org/title/MPRIS)

# License

This code is under MIT license
