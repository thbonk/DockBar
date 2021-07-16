//
//  StatusBarController.swift
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

import AppKit
import SwiftUI

class StatusBarController: NSObject, ObservableObject {

  // MARK: - Private Properties

  private var statusBarItem: NSStatusItem!
  private var popover: NSPopover!
  private var applicationListView: AnyView!
  private var dockModelProvider = DockModelProvider()


  // MARK: - Initialization

  override func awakeFromNib() {
    statusBarItem = NSStatusBar.system.statusItem(withLength: 28.0)

    if let statusBarButton = statusBarItem.button {
      statusBarButton.image =
        NSImage(
                  systemSymbolName: "menubar.dock.rectangle",
          accessibilityDescription: "Button to show the content of the macOS Dock")
      statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
      statusBarButton.image?.isTemplate = true
      statusBarButton.action = #selector(toggleDockList(sender:))
      statusBarButton.target = self
    }

    applicationListView =
      AnyView(
        ApplicationListView()
          .environmentObject(dockModelProvider)
          .environmentObject(self))
    popover = NSPopover()
    popover.contentViewController = NSHostingController(rootView: applicationListView)
  }


  // MARK: - Public Methods

  func launch(application: DockEntry) {
    DispatchQueue.main.async {
      NSWorkspace.shared.open(application.url!)
    }

    popover.close()
  }


  // MARK: - Private Methods

  @objc private func toggleDockList(sender: NSStatusBarButton) {
    if popover.isShown {
      popover.close()
    } else {
      if let popoverHeight = popoverHeight() {
        popover.contentSize = NSSize(width: 240, height: popoverHeight)
      }
      popover.show(relativeTo: statusBarItem.button!.bounds, of: statusBarItem.button!, preferredEdge: .maxY)
    }
  }

  func popoverHeight() -> Int? {
    if let screen = screenWithMouse() {
      let screenHeight = screen.frame.height

      return min(
        (Int(screenHeight - (NSApplication.shared.mainMenu?.menuBarHeight ?? 64) - 32)),
        (dockModelProvider.model().applications.count * 32))
    }

    return nil
  }

  func screenWithMouse() -> NSScreen? {
    let mouseLocation = NSEvent.mouseLocation
    let screens = NSScreen.screens
    let screenWithMouse = (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })

    return screenWithMouse
  }
}
