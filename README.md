# DockBar

Application that is available in the Menu Bar. It reads the dock configuration at ~/Library/Preferences/com.apple.dock.plist and displays:
- The apps in the dock (key persistent-apps)
- Other items in the dock (key persistent-others)
- Recent apps (key recent-apps)

User should be able to select which categories shall be displayed.
The dock content shall be displayed as menu items in the menu bar menu. Via a shortcut, a popup shall appear that displays the dock contents.

## Installation
1. In Finder select the menu Go > Go to Folder...
2. Enter `~/Library`
3. Drag & Drop the Library from your home folder to your Finder favorites
4. Copy DockBar to /Programs
5. Start DockBar
6. DockBar opens the a File Open panel. In that panel, navigate to `Library > Preferences` and select the file `com.apple.dock.plist`.
7. You can also add DockBar to your Login Items   
