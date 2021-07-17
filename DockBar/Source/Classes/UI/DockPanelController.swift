//
//  DockPanelController.swift
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
import AppKit

class DockPanelController: NSWindowController {

  // MARK: - Private Properties

  private var keyCombo: KeyCombo!
  private var hotKey: HotKey!
  private var dockPanel: NSPanel!


  // MARK: - Initialization

  override func awakeFromNib() {
    if let kc = KeyCombo(key: .space, cocoaModifiers: .option) {
      keyCombo = kc
      hotKey = HotKey(identifier: "Option + Space", keyCombo: keyCombo, actionQueue: .main, handler: toggleDockPopupover(key:))
      hotKey.register()
    }

    dockPanel = makePanel()
    self.window = dockPanel
    dockPanel.windowController = self
  }


  // MARK: - Private Methods

  private func toggleDockPopupover(key: HotKey) {
    if dockPanel.isVisible {
      dockPanel.close()
    } else {
      dockPanel.orderFrontRegardless()
    }
  }

  private func makePanel() -> NSPanel {
    let panel = NSPanel()
    let visualEffect = NSVisualEffectView()

    visualEffect.translatesAutoresizingMaskIntoConstraints = false
    visualEffect.material = .dark
    visualEffect.state = .active
    visualEffect.wantsLayer = true
    visualEffect.layer?.cornerRadius = 16.0

    panel.titleVisibility = .hidden
    panel.styleMask.remove(.titled)
    panel.backgroundColor = .clear
    panel.isMovableByWindowBackground = true

    panel.contentView?.addSubview(visualEffect)

    guard let constraints = panel.contentView else {
      return panel
    }

    visualEffect.leadingAnchor.constraint(equalTo: constraints.leadingAnchor).isActive = true
    visualEffect.trailingAnchor.constraint(equalTo: constraints.trailingAnchor).isActive = true
    visualEffect.topAnchor.constraint(equalTo: constraints.topAnchor).isActive = true
    visualEffect.bottomAnchor.constraint(equalTo: constraints.bottomAnchor).isActive = true

    return panel
  }
}
