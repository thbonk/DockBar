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
  private var frontmostApplication: NSRunningApplication? = nil


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

  func openEntry(entry: DockEntry) {
    AppDelegate.shared.openDockEntry(entry: entry)

    DispatchQueue.main.async {
      self.hideDockPanel()
    }
  }


  // MARK: - Private Methods

  private func toggleDockPanel(key: HotKey) {
    if AppDelegate.shared.isActive {
      hideDockPanel()
    } else {
      showDockPanel()
    }
  }

  private func hideDockPanel() {
    DispatchQueue.main.async {
      self.dockPanel.hidesOnDeactivate = true
    }
    DispatchQueue.main.async {
      self.frontmostApplication?.activate(options: .activateIgnoringOtherApps)
    }
  }

  private func showDockPanel() {
    self.frontmostApplication = NSWorkspace.shared.frontmostApplication
    self.dockPanel.becomesKeyOnlyIfNeeded = false
    self.dockPanel.isFloatingPanel = true
    
    dockPanel.contentViewController =
      NSHostingController(
        rootView: AnyView(
          ApplicationDockView()
            .environmentObject(AppDelegate.shared.dockModelProvider)
            .environmentObject(self)
            .background(Color("DockPopupColor"))
            .cornerRadius(5)))



    DispatchQueue.main.async {
      NSApp.activate(ignoringOtherApps: true)
      self.showWindow(self)
      DispatchQueue.main.async {
        self.dockPanel.orderFrontRegardless()
      }
    }

    DispatchQueue.main.async {
      do {
        let frame = self.dockPanel.contentView!.frame
        let position = try self.calculateDockPanelCoords(panelSize: frame.size)

        self.dockPanel.setFrameOrigin(position)
      } catch {
        NSAlert.showModalAlert(
          style: .critical,
          messageText: "Error while reading the macOS Dock configuration.",
          informativeText: "The error is \(error)",
          buttons: ["OK"])
      }
    }
  }

  private func calculateDockPanelCoords(panelSize size: NSSize) throws -> NSPoint {
    let mouseLocation = mouseLocation()
    let screenFrame = screenWithMouse()!.frame
    var pos = NSPoint(x: mouseLocation.x - (size.width / 2), y: mouseLocation.y - (size.height / 2))

    if pos.x < 0 {
      pos.x = 0
    }
    if (pos.x + size.width) > screenFrame.size.width {
      pos.x = screenFrame.size.width - size.width
    }
    if pos.y < 0 {
      pos.y = 0
    }
    if (pos.y + size.height) > screenFrame.size.height {
      pos.y = screenFrame.size.height - size.height
    }

    return pos
  }

  private func makePanel() -> NSPanel {
    let panel = NSPanel()
    let visualEffect = NSVisualEffectView()

    visualEffect.translatesAutoresizingMaskIntoConstraints = false
    visualEffect.material = .sheet
    visualEffect.layer?.backgroundColor = NSColor.controlColor.cgColor
    visualEffect.state = .active
    visualEffect.wantsLayer = true
    visualEffect.layer?.cornerRadius = 25.0

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
