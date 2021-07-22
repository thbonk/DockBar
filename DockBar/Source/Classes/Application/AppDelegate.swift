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

  let windowController = StoryboardScene.Main.setupWizardWindowController.instantiate()
  lazy var window: NSWindow? = {
    self.windowController.window
  }()

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


  // MARK: - Public Methods

  func grantAccessToPreferencesFolder() {
    let windowController = StoryboardScene.Main.setupWizardWindowController.instantiate()

    windowController.showWindow(self)
    windowController.window?.makeKeyAndOrderFront(self)
    windowController.window?.orderFrontRegardless()
  }
}

