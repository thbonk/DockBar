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
import SwiftUI

class DockPanelController: NSWindowController, ObservableObject {

  // MARK: - Private Properties

  //private var eventMonitor: EventMonitor!
  private var keyCombo: KeyCombo!
  private var hotKey: HotKey!
  private var dockPanel: NSPanel!
  private var applicationDockView: AnyView!
  private var dockModelProvider = DockModelProvider()


  // MARK: - Initialization

  override func awakeFromNib() {
    /*eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { event in
      if self.dockPanel.isVisible {
        self.hideDockPanel()
      }
    }*/

    if let kc = KeyCombo(key: .space, cocoaModifiers: .option) {
      keyCombo = kc
      hotKey = HotKey(identifier: "Option + Space", keyCombo: keyCombo, actionQueue: .main, handler: toggleDockPanel(key:))
      hotKey.register()
    }

    applicationDockView =
      AnyView(
        ApplicationDockView()
          .environmentObject(dockModelProvider)
          .environmentObject(self))
    dockPanel = makePanel()
    self.window = dockPanel
    dockPanel.windowController = self
    dockPanel.contentViewController = NSHostingController(rootView: applicationDockView)
  }


  // MARK: - Public Methods

  func launch(application: DockEntry) {
    DispatchQueue.main.async {
      NSWorkspace.shared.open(application.url!)
    }
    DispatchQueue.main.async {
      self.hideDockPanel()
    }
  }


  // MARK: - Private Methods

  private func toggleDockPanel(key: HotKey) {
    if dockPanel.isVisible {
      hideDockPanel()
    } else {
      showDockPanel()
    }
  }

  private func hideDockPanel() {
    NSApp.deactivate()
    //eventMonitor.stop()
    dockPanel.close()
  }

  private func showDockPanel() {
    NSApp.activate(ignoringOtherApps: true)
    //eventMonitor.start()

    let coords = calculateDockPanelCoords()
    dockPanel.setFrameOrigin(coords.0)
    dockPanel.setContentSize(coords.1)
    dockPanel.orderFrontRegardless()
  }

  private func calculateDockPanelCoords() -> (NSPoint, NSSize, Int) {
    let model = dockModelProvider.model()
    let mouseLocation = mouseLocation()
    let contentHeight = model.maxIconHeight + 10
    var contentWidth = model.allIconsWidth + model.applications.count * 10
    var iconWing = 32
    let screenWidth = screenWithMouseWidth()!
    var xPos = Int((screenWidth - contentWidth) / 2)

    if contentWidth > screenWidth {
      contentWidth = screenWidth
      iconWing = (contentWidth - model.applications.count * 20) / model.applications.count
      xPos = Int((screenWidth - contentWidth) / 2)
    }

    return (NSPoint(x: xPos, y: Int(mouseLocation.y)), NSSize(width: contentWidth, height: contentHeight), iconWing)
  }

  private func makePanel() -> NSPanel {
    let panel = NSPanel()
    let visualEffect = NSVisualEffectView()

    visualEffect.translatesAutoresizingMaskIntoConstraints = false
    visualEffect.material = .dark
    visualEffect.state = .active
    visualEffect.wantsLayer = true
    visualEffect.layer?.cornerRadius = 10.0

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
