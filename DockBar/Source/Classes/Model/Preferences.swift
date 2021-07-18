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
  static let DockModelOnceImported = "DockModelOnceImported"
  static let PersistentApplications = "PersistentApplications"
}

class Preferences {

  // MARK: - Public Properties

  var dockModelOnceImported: Bool {
    get {
      return userDefaults.bool(forKey: .DockModelOnceImported)
    }
    set {
      userDefaults.set(newValue, forKey: .DockModelOnceImported)
      _ = userDefaults.synchronize()
    }
  }

  var persistentApplications: [DockEntry] {
    get {
      if let data  = userDefaults.object(forKey: .PersistentApplications) as? Data {
        let entries = try? (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [DockEntry])

        return entries ?? []
      }

      return []
    }
    set {
      let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
      
      userDefaults.set(encodedData, forKey: .PersistentApplications)
    }
  }


  // MARK: - Private Properties

  private var userDefaults = UserDefaults()


  // MARK: - Initialization

  init() {
    userDefaults.register(defaults: [
      .DockModelOnceImported : false,
      .PersistentApplications: [DockEntry]()
    ])
  }
}
