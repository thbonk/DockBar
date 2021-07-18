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

fileprivate extension String {
  static let PersistentApplications = "persistent-apps"
  static let GUID                   = "GUID"
  static let TileData               = "tile-data"
  static let FileLabel              = "file-label"
  static let BundleIdentifier       = "bundle-identifier"
  static let FileData               = "file-data"
  static let FileURL                = "_CFURLString"
}

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
    
  func applicationWillFinishLaunching(_ notification: Notification) {
    if !AppDelegate.preferences.dockModelOnceImported {
      DispatchQueue.main.async {
        self.importDockModel()
      }
    }
  }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if !AppDelegate.preferences.dockModelOnceImported {
      DispatchQueue.main.async {
        self.importDockModel()
      }
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


  // MARK: - Public Methods

  func importDockModel() {
    let dialog = NSOpenPanel();

    dialog.title = "Select 'com.apple.dock.plist' to import it!"
    dialog.message = "Select 'com.apple.dock.plist' to import it!"
    dialog.canChooseDirectories = false
    dialog.canChooseFiles = true
    dialog.canHide = false
    dialog.isAccessoryViewDisclosed = false
    dialog.showsTagField = false
    dialog.canCreateDirectories = false
    dialog.directoryURL = AppDelegate.dockConfigurationUrl
    dialog.allowsMultipleSelection = false

    do {
      switch dialog.runModal() {
        case .OK:
          try importDockModel(from: dialog.url!)
          AppDelegate.preferences.dockModelOnceImported = true
          dockModelProvider.updateModel()
          break

        case .cancel, .abort:
          break

        default:
          break
      }
    } catch {
      // TODO Show error
    }
  }


  // MARK: - Private Methods

  private func importDockModel(from url: URL) throws {
    guard let dockConfiguration = NSDictionary(contentsOf: url) as? Dictionary<String, Any> else {
      throw ApplicationError.importDockModelError
    }

    if let persistentApplications = dockConfiguration[.PersistentApplications] as? Array<Dictionary<String, Any>> {
      AppDelegate.preferences.persistentApplications = persistentApplications.map(toDockEntry(app:))
    }
  }

  private func toDockEntry(app: Dictionary<String, Any>) -> DockEntry {
    let tileData = toDictionary(app[.TileData]!)
    let id = toInt(app[.GUID]!)
    let label = toString(tileData[.FileLabel]!)
    let bundleIdentifier = toString(tileData[.BundleIdentifier]!)
    let url = URL(string: toString(toDictionary(tileData[.FileData]!)[.FileURL]!))

    return DockEntry(id: id, label: label, bundleIdentifier: bundleIdentifier, url: url)
  }

  private func toInt(_ data: Any) -> Int {
    return Int(truncating: (data as! NSNumber))
  }

  private func toDictionary(_ data: Any) -> Dictionary<String, Any> {
    return data as! Dictionary<String, Any>
  }

  private func toString(_ data: Any) -> String {
    return data as! String
  }
}

