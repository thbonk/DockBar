//
//  AppDelegate.swift
//  DockBar
//
//  Created by Thomas Bonk on 14.07.21.
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

import AppKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

  // MARK: - Public Enums

  enum ApplicationError: Error {
    case importDockModelError
  }

  // MARK: - Class Properties

  static var shared: AppDelegate = {
    NSApplication.shared.delegate as! AppDelegate
  }()

  static var preferences: Preferences = {
    Preferences()
  }()

  static var userDirectory: URL {
    FileManager.default.urls(for: .userDirectory, in: .allDomainsMask)[0]
  }

  static var preferencesFolderUrl: URL {
    return AppDelegate.userDirectory
      .appendingPathComponent(NSUserName())
      .appendingPathComponent("Library")
      .appendingPathComponent("Preferences")
  }

  static var dockConfigurationUrl: URL {
    return AppDelegate.userDirectory
      .appendingPathComponent(NSUserName())
      .appendingPathComponent("Library")
      .appendingPathComponent("Preferences")
      .appendingPathComponent("com.apple.dock.plist")
  }


  // MARK: - Public Properties

  lazy var dockModelProvider: DockModelProvider = {
    DockModelProvider()
  }()
  

  // MARK: - Private Properties

  @IBOutlet
  private var statusBarController: StatusBarController!
  @IBOutlet
  private var popupController: DockPanelController!


  // MARK: - NSApplicationDelegate
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if AppDelegate.preferences.preferencesFolderUrl == nil {
      grantAccessToPreferencesFolder()
    }

  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


  // MARK: - Private Methods

  private func grantAccessToPreferencesFolder() {
    var url = AppDelegate.preferencesFolderUrl

    showGrantAccessInformation()
    guard retrievePreferencesFolderUrl(into: &url) else {
      showAccessNotGrantedError()
      return
    }

    AppDelegate.preferences.preferencesFolderUrl = url

    // check whether is possible to read the Dock configuration
    do {
      guard  let url = AppDelegate.preferences.dockConfigurationUrl else {
        showDockConfigurationUrlNotAvailableError()
        return
      }

      _ = try Data(contentsOf: url)
    } catch {
      showDockConfigurationReadError(error)
      NSLog("\(error)")
    }
  }

  private func retrievePreferencesFolderUrl(into url: inout URL) -> Bool {
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
        if dialog.url?.path != AppDelegate.preferencesFolderUrl.path {
          return false
        }
        url = dialog.url!
        return true

      default:
        return false
      }
  }

  private func showGrantAccessInformation() {
    NSAlert
      .showModalAlert(
        style: .informational,
        messageText: "DockBar requires access to the macOS Dock configuration. In the next step, you have to select " +
                     "that folder, such that access is granted by macOS.",
        informativeText: "Only the file \(AppDelegate.dockConfigurationUrl.path) is read, no other file is accessed " +
                         "by DockBar. After pusching the OK button, a File Open Panel is displayed with the folder " +
                         "\(AppDelegate.preferencesFolderUrl.path) selected. Just push the Open button and access is " +
                         "granted.",
        buttons: ["OK"])
  }

  private func showAccessNotGrantedError() {
    NSAlert
      .showModalAlert(
        style: .critical,
        messageText: "You haven't granted acces to the folder \(AppDelegate.preferencesFolderUrl.path).",
        informativeText: "DockBar can't be started, since it requires read access to the macOS Dock configuration " +
                         "located at \(AppDelegate.dockConfigurationUrl.path). DockBar is going to be terminated." +
                         " You can restart it and grant acces then.",
        buttons: ["Quit"])

    NSApplication.shared.terminate(self)
  }

  private func showDockConfigurationUrlNotAvailableError() {
    NSAlert
      .showModalAlert(
        style: .critical,
        messageText: "It wasn't possible to grant access to the folder\(AppDelegate.preferencesFolderUrl.path).",
        informativeText: "DockBar can't be started, since it requires read access to the macOS Dock configuration " +
        "located at \(AppDelegate.dockConfigurationUrl.path). DockBar is going to be terminated." +
        " You can restart it and grant acces then.",
        buttons: ["Quit"])

    NSApplication.shared.terminate(self)
  }

  private func showDockConfigurationReadError(_ error: Error) {
    NSAlert
      .showModalAlert(
        style: .critical,
        messageText: "An error occured while reading the macOS Dock configuration.",
        informativeText: "DockBar can't be started, since it requires to read the macOS Dock configuration " +
        "located at \(AppDelegate.dockConfigurationUrl.path). DockBar is going to be terminated." +
        " You can restart it to try reading the configuration again. The error was:\n\(error)",
        buttons: ["Quit"])

    NSApplication.shared.terminate(self)
  }
}

