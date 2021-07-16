//
//  DockEntry.swift
//  DockBar
//
//  Created by Thomas Bonk on 15.07.21.
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



class DockEntry: NSObject, Identifiable, NSCoding {

  // MARK: - Public Properties

  private(set) var id: Int = 0
  private(set) var label: String = ""
  private(set) var bundleIdentifier: String = ""
  private(set) var url: URL? = nil

  var icon: NSImage? {
    guard let path = url?.path else {
      return nil
    }

    return NSWorkspace.shared.icon(forFile: path)
  }


  // MARK: - Initialization

  init(id: Int = 0, label: String, bundleIdentifier: String, url: URL?) {
    self.id = id
    self.label = label
    self.bundleIdentifier = bundleIdentifier
    self.url = url

    super.init()
  }


  // MARK: - NSCoding

  func encode(with coder: NSCoder) {
    coder.encode(id, forKey: "id")
    coder.encode(label, forKey: "label")
    coder.encode(bundleIdentifier, forKey: "bundleIdentifier")
    coder.encode(url!, forKey: "url")
  }

  required init?(coder: NSCoder) {
    id = coder.decodeInteger(forKey: "id")
    label = coder.decodeObject(forKey: "label") as! String
    bundleIdentifier = coder.decodeObject(forKey: "bundleIdentifier") as! String
    url = (coder.decodeObject(forKey: "url") as! URL)

    super.init()
  }


  /*// MARK: - Initialization

  init(data: Dictionary<String, Any>) {
    let tileData = toDictionary(data[.TileData] as Any)

    id = toInt(data[.GUID] as Any)
    label = toString(tileData[.FileLabel] as Any)
    bundleIdentifier = toString(tileData[.BundleIdentifier] as Any)
    url = URL(string: toString(toDictionary(tileData[.FileData] as Any)[.FileURL] as Any))
  }


  // MARK: - Private Methods

  private func toInt(_ data: Any) -> Int {
    return Int(truncating: (data as! NSNumber))
  }

  private func toDictionary(_ data: Any) -> Dictionary<String, Any> {
    return data as! Dictionary<String, Any>
  }

  private func toString(_ data: Any) -> String {
    return data as! String
  }*/
}
