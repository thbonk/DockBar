//
//  PopupController.swift
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
import Magnet

class PopupController: NSObject {

  // MARK: - Private Properties

  private var keyCombo: KeyCombo!
  private var hotKey: HotKey!


  // MARK: - Initialization

  override func awakeFromNib() {
    if let kc = KeyCombo(key: .space, cocoaModifiers: .option) {
      keyCombo = kc
      hotKey = HotKey(identifier: "Option + Space", keyCombo: keyCombo, actionQueue: .main, handler: togglePopup(key:))
      hotKey.register()
    }
  }


  // MARK: - Private Properties

  private func togglePopup(key: HotKey) {

  }
}
