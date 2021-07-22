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
  static let PersistentApplications = "persistent-apps"
  static let GUID                   = "GUID"
  static let TileData               = "tile-data"
  static let FileLabel              = "file-label"
  static let BundleIdentifier       = "bundle-identifier"
  static let FileData               = "file-data"
  static let FileURL                = "_CFURLString"
}

class DockModel {

  // MARK: - Public Properties

  public private(set) var applications = [DockEntry]()

  public var maxIconHeight: Int {
    return applications.map { entry in Int(entry.icon!.size.height) }.max() ?? 32
  }

  public var allIconsWidth: Int {
    return applications.map { entry in Int(entry.icon!.size.width) }.reduce(0, +)
  }


  // MARK: - Initialization

  init(from url: URL) throws {
    applications = try importDockModel(from: url)
  }


  // MARK: - Private Methods

  private func importDockModel(from url: URL) throws -> [DockEntry] {
    guard let dockConfiguration = NSDictionary(contentsOf: url) as? Dictionary<String, Any> else {
      throw AppDelegate.ApplicationError.importDockModelError
    }

    if let persistentApplications = dockConfiguration[.PersistentApplications] as? Array<Dictionary<String, Any>> {
      return persistentApplications.map(toDockEntry(app:))
    }

    throw AppDelegate.ApplicationError.importDockModelError
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
