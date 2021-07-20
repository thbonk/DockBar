//
//  Step2SelectPreferencesFolder.swift
//  DockBar
//
//  Created by Thomas Bonk on 20.07.21.
//  Copyright 2021 Thomas Bonk.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import SwiftUI

struct Step2SelectPreferencesFolder: View {

  // MARK: - Public Properties

  var body: some View {
    VStack {
      Text("Select Preferences folder")
        .font(.title)
        .padding(.vertical, 10)

      Text("Please push this button to select the folder").padding([.horizontal], 10)
      Text("\(AppDelegate.preferencesFolderUrl.path)")
      Image(systemName: "hand.point.down.fill")
        .font(.system(size: 48))
        .padding(.top, 5)
      Button {
        showFileOpenPanel()
      } label: {
        Text("Open Preferences Folder")
      }

      CheckedResultArea()
        .padding(.top, 20)
    }
  }

  // MARK: - Private Properties

  @State
  private var openPanelDisplayed = false
  @State
  private var preferencesFolderUrl: URL? = nil


  // MARK: - Private Methods

  private func CheckedResultArea() -> AnyView {
    if openPanelDisplayed {
      if preferencesFolderUrl == nil {
        return AnyView(
          Text("You haven't selected any folder. Please try again!")
            .bold()
            .padding(.horizontal, 20))
      } else if preferencesFolderUrl?.path != AppDelegate.preferencesFolderUrl.path {
        return AnyView(
          Text("You have selected the folder \(preferencesFolderUrl!.path) which is the wrong folder. Please try again!")
            .bold()
            .padding(.horizontal, 20))
      } else if let error = checkFileAccess(to: preferencesFolderUrl!.appendingPathComponent("com.apple.dock.plist")) {
        return AnyView(
          Text("Can't read the macOS Dock configuration. Error was \(error.localizedDescription)")
            .bold()
            .padding(.horizontal, 20))
      } else {
        AppDelegate.preferences.preferencesFolderUrl = preferencesFolderUrl!
        return AnyView(Text("Access was granted! You can close this window.").bold().padding(.horizontal, 20))
      }
    } else {
      return AnyView(EmptyView())
    }
  }

  private func checkFileAccess(to url: URL) -> Error? {
    var err: Error? = nil

    do {
      _ = try Data(contentsOf: url)
    } catch {
      err = error
    }

    return err
  }

  private func showFileOpenPanel() {
    let dialog = NSOpenPanel()

    dialog.title = "Please select the folder \(AppDelegate.preferencesFolderUrl.path)"
    dialog.message = "Please select the folder \(AppDelegate.preferencesFolderUrl.path)"
    dialog.canChooseDirectories = true
    dialog.canChooseFiles = false
    dialog.canHide = false
    dialog.isAccessoryViewDisclosed = false
    dialog.showsTagField = false
    dialog.canCreateDirectories = false
    dialog.directoryURL = AppDelegate.preferencesFolderUrl
    dialog.allowsMultipleSelection = false

    switch dialog.runModal() {
      case .OK:
        openPanelDisplayed = true
        preferencesFolderUrl = dialog.url!
        break

      default:
        openPanelDisplayed = true
        preferencesFolderUrl = nil
        break
    }
  }
}

struct Step2SelectPreferencesFolder_Previews: PreviewProvider {
  static var previews: some View {
    Step2SelectPreferencesFolder()
  }
}
