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
  static let DockConfigurationUrl = "DockConfigurationUrl"
}

class Preferences {

  // MARK: - Public Properties

  var dockConfigurationUrl: URL? {
    get {
      if let data = userDefaults.value(forKey: .DockConfigurationUrl) as? Data {
        var stale = false

        if let url = try? URL(resolvingBookmarkData: data, bookmarkDataIsStale: &stale) {
          if stale {
            self.dockConfigurationUrl = url
          }

          return url
        }
      }
      return nil
    }
    set {
      guard let url = newValue else {
        userDefaults.removeObject(forKey: .DockConfigurationUrl)
        return
      }

      do {
        let data = try url.bookmarkData()
        userDefaults.set(data, forKey: .DockConfigurationUrl)
      } catch {
        NSAlert.showModalAlert(
          style: .critical,
          messageText: "Error while granting read access to the URL \(url).",
          informativeText: "The error is \(error)",
          buttons: ["OK"])
        NSLog("\(error)")
      }
    }
  }

  var dockConfiguration: DockModel? {
    get {
      nil
    }
    set {

    }
  }


  // MARK: - Private Properties

  private var userDefaults = UserDefaults()


  // MARK: - Initialization

  init() {
    userDefaults.register(defaults: [:])
  }


  // MARK: - Public Methods

  func grantedAccessUrl(for url: URL) -> URL {
    if let data = userDefaults.object(forKey: url.path) as? Data {
      var isStale = false
      if let grantedAccessUrl = try? URL(resolvingBookmarkData: data, bookmarkDataIsStale: &isStale) {
        if isStale {
          storeGrantedAccessUrl(grantedAccessUrl, for: url)
        }

        return grantedAccessUrl.appendingPathComponent(url.lastPathComponent)
      }
    }

    return url
  }

  func storeGrantedAccessUrl(_ grantedAccessUrl: URL, for url: URL) {
    userDefaults.setValue(try? grantedAccessUrl.bookmarkData(), forKey: url.path)
  }
}
