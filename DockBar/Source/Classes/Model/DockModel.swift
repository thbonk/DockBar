//
//  DockModel.swift
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

import Foundation

fileprivate extension String {
  static let Applications = "persistent-apps"
}

class DockModel {

  // MARK: - Public Properties

  public var applications: [DockEntry]? {
    return persistentApps?
      .map { app in DockEntry(data: app) }
  }


  // MARK: - Private Properties

  private var dockConfiguration: Dictionary<String, Any>? = nil
  private var userDirectory: URL {
    FileManager.default.urls(for: .userDirectory, in: .allDomainsMask)[0]
  }
  private var dockPlist: URL {
    userDirectory
      .appendingPathComponent(NSUserName())
      .appendingPathComponent("Library")
      .appendingPathComponent("Preferences")
      .appendingPathComponent("com.apple.dock.plist")
  }
  private var persistentApps: Array<Dictionary<String, Any>>? {
    return dockConfiguration?[.Applications] as? Array<Dictionary<String, Any>>
  }


  // MARK: - Initialization

  init?() {
    guard let cfg = loadDockPlist() else {
      return nil
    }
    dockConfiguration = cfg
  }


  // MARK: - Private Methods

  private func loadDockPlist() -> Dictionary<String, Any>? {
    guard let cfg = NSDictionary(contentsOf: dockPlist) as? Dictionary<String, Any> else {
      return nil
    }

    return cfg
  }
}
