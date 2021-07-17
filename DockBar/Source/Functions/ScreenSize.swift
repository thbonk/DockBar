//
//  ScreenSize.swift
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

import AppKit

func mouseLocation() -> NSPoint {
  return NSEvent.mouseLocation
}

func screenWithMouseSize() -> NSSize? {
  let mouseLocation = mouseLocation()
  let screens = NSScreen.screens
  let screenWithMouse = (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })

  return screenWithMouse?.frame.size
}

func screenWithMouseWidth() -> Int? {
  guard let size = screenWithMouseSize() else {
    return nil
  }

  return Int(size.width)
}

func screenWithMouseHeight() -> Int? {
  guard let size = screenWithMouseSize() else {
    return nil
  }

  return Int(size.height)
}
