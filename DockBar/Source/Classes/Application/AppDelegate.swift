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
class AppDelegate: NSResponder, NSApplicationDelegate {

  // MARK: - Public Enums

  enum ApplicationError: Error {
    case importDockModelError
    case notConfigured
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

  private(set) var isActive = false
  

  // MARK: - Private Properties

  @IBOutlet
  private var statusBarController: StatusBarController!
  @IBOutlet
  private var popupController: DockPanelController!


  // MARK: - NSApplicationDelegate
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    guard let _ = AppDelegate.preferences.dockConfigurationUrl, let _ = try? DockModel(from: AppDelegate.preferences.dockConfigurationUrl!) else { // AppDelegate.preferences.dockConfiguration else {
      grantAccessToDockConfiguration()
      return
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func applicationDidBecomeActive(_ notification: Notification) {
    isActive = true
  }

  func applicationDidResignActive(_ notification: Notification) {
    isActive = false
  }


  // MARK: - Public Methods

  func openDockEntry(entry: DockEntry) {
    DispatchQueue.main.async {
      NSWorkspace
        .shared
        .open(
          AppDelegate.preferences.grantedAccessUrl(for: entry.url!),
          configuration: NSWorkspace.OpenConfiguration()) { app, error in

        guard error == nil else {
          let pathUrl = entry.url!.deletingLastPathComponent()

          GrantAccessWindowController
            .grantAccess(
              to: pathUrl,
              completed: { folderUrl in
              
              if let url = folderUrl {
                AppDelegate.preferences.storeGrantedAccessUrl(url, for: entry.url!)
                NSWorkspace.shared.open(url.appendingPathComponent(entry.url!.lastPathComponent))
              }
            })

          return
        }
      }
    }
  }

  func grantAccessToDockConfiguration() {
    GrantAccessWindowController
      .grantAccess(
        to: AppDelegate.dockConfigurationUrl,
        check: checkDockConfigurationFileAccess) { configUrl in

        if let url = configUrl {
          AppDelegate.preferences.dockConfigurationUrl = url
        }
      }
  }

  /* TODO
  @IBAction
  func grantAccessToPreferencesFolder(_ sender: Any? = nil) {
    GrantAccessWindowController
      .grantAccess(
        to: AppDelegate.preferencesFolderUrl,
        check: checkDockConfigurationFileAccess) { folderUrl in

        if let url = folderUrl {
          AppDelegate.preferences.preferencesFolderUrl = url
        }
      }
  }
  */


  // MARK: - Private Methods

  private func checkDockConfigurationFileAccess(_ configUrl: URL) -> String? {
    do {
      _ = try Data(contentsOf: configUrl)
    } catch {
      return "Can't read the macOS Dock configuration. Error was \(error.localizedDescription)"
    }

    return nil
  }
}

