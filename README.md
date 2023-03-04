#  To-Day

I wanted a very simple Mac menubar app that showed a list of items that I could check off over the day. Nothing long term, just day-by-day.

Every app I found had a terrific list of features, most of which I didn't want, so I wrote my own in SwiftUI for macOS 13.0 or later.

Use the **Edit Todos…** menu item to add, delete, edit and move your todos. Select them in the menu to mark them as complete or incomplete.

There are only two settings: **Complete at End** sorts the list in the menu, moving the completed todos to the end and **Launch on Login** sets whether you want the app to start automatically when you log in.

This app is free, but if you'd like to support my work, please [https://ko-fi.com/H2H3BU7SI](Buy Me a Coffee).

If you'd like to contact me, I'm [@troz@mastodon.social](https://mastodon.social/@troz) on Mastodon.

#### Things to fix:

- [x] Editing - SwiftUI jumps the insertion cursor to the end of the field when editing an existing todo.
- [x] Keyboard shortcuts for deleting and moving.
- [x] Allow clicking anywhere in the text area to start editing
- [x] Lint & tidy up project
- [x] Fix Shift-tab so it goes from 2 to 1 and not from 2 to new

#### Dev notes:

- Not happy with chain of `onChange` modifiers to track focus.
- This leads to various timed fixes which are fragile.
- Testing new version with no focus tracking. Doesn't allow moves, but maybe that's ok.

## Sparkle process

- Archive app
- Distribute using Developer ID, using Apple notary service
- Export notarised app and copy into read-write DMG
- Configure DMG window as required
- Eject DMG and use Disk Utility to convert to read-only
- Set name to To-Day.dmg and move to Releases folder
- Show Sparkle folder in Finder
- Open Terminal at artifacts folder in the level above Sparkle
- Run `./bin/generate_appcast /path/to/Releases`
- Push to repo
- Run old version and test update process (errors appear in Console)
