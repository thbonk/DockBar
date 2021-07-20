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

  private var keyCombo: KeyCombo!
  private var hotKey: HotKey!
  private var dockPanel: NSPanel!
  private var applicationDockView: AnyView!


  // MARK: - Initialization

  override func awakeFromNib() {
    if let kc = KeyCombo(key: .space, cocoaModifiers: .option) {
      keyCombo = kc
      hotKey = HotKey(identifier: "Option + Space", keyCombo: keyCombo, actionQueue: .main, handler: toggleDockPanel(key:))
      hotKey.register()
    }

    dockPanel = makePanel()
    self.window = dockPanel
    dockPanel.windowController = self
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
    dockPanel.close()
  }

  private func showDockPanel() {
    do {
      NSApp.activate(ignoringOtherApps: true)

      applicationDockView =
        AnyView(
          ApplicationDockView()
            .environmentObject(AppDelegate.shared.dockModelProvider)
            .environmentObject(self)
            .background(Color(cgColor: NSColor.controlColor.cgColor))
            .cornerRadius(5))
      dockPanel.contentViewController = NSHostingController(rootView: applicationDockView)

      let coords = try calculateDockPanelCoords()
      dockPanel.setFrameOrigin(coords.0)
      dockPanel.setContentSize(coords.1)
      dockPanel.orderFrontRegardless()
    } catch {
      NSAlert.showModalAlert(
                  style: .critical,
            messageText: "Error while reading the macOS Dock configuration.",
        informativeText: "The error is \(error)",
                buttons: ["OK"])
    }
  }

  private func calculateDockPanelCoords() throws -> (NSPoint, NSSize) {
    let model = try AppDelegate.shared.dockModelProvider.model()
    let mouseLocation = mouseLocation()
    let screenWidth = screenWithMouseWidth()!
    let contentHeight = model.maxIconHeight
    var contentWidth = model.allIconsWidth + model.applications.count * 10 + 96

    if contentWidth > screenWidth {
      contentWidth = screenWidth
    }

    let xPos = Int((screenWidth - contentWidth) / 2)

    return (NSPoint(x: xPos, y: Int(mouseLocation.y)), NSSize(width: contentWidth, height: contentHeight + 10))
  }

  private func makePanel() -> NSPanel {
    let panel = NSPanel()
    let visualEffect = NSVisualEffectView()

    visualEffect.translatesAutoresizingMaskIntoConstraints = false
    visualEffect.material = .sheet
    visualEffect.layer?.backgroundColor = NSColor.controlColor.cgColor
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
