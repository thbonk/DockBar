//
//  Preferences.swift
//  DockBar
//
//  Created by Thomas Bonk on 16.07.21.
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

import Foundation
import AppKit

fileprivate extension String {
  static let PreferencesFolderUrl = "PreferencesFolderUrl"
}

class Preferences {

  // MARK: - Public Properties

  var preferencesFolderUrl: URL? {
    get {
      if let data = userDefaults.value(forKey: .PreferencesFolderUrl) as? Data {
        var stale = false
        return try? URL(resolvingBookmarkData: data, bookmarkDataIsStale: &stale)
      }
      return nil
    }
    set {
      guard let url = newValue else {
        userDefaults.removeObject(forKey: .PreferencesFolderUrl)
        return
      }

      do {
        let data = try url.bookmarkData()
        userDefaults.set(data, forKey: .PreferencesFolderUrl)
      } catch {
        NSAlert.showModalAlert(
                    style: .critical,
              messageText: "Error while granting read access to the Preferences folder.",
          informativeText: "The error is \(error)",
                  buttons: ["OK"])
        NSLog("\(error)")
      }
    }
  }

  var dockConfigurationUrl: URL? {
    return preferencesFolderUrl?.appendingPathComponent("com.apple.dock.plist")
  }


  // MARK: - Private Properties

  private var userDefaults = UserDefaults()


  // MARK: - Initialization

  init() {
    userDefaults.register(defaults: [:])
  }
}
