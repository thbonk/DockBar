//
//  NSImage+resize.swift
//  DockBar
//
//  Created by Thomas Bonk on 07.08.21.
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

extension NSImage {
  func resized(width: CGFloat, height: CGFloat) -> NSImage {
    let destSize = NSMakeSize(width, height)
    let newImage = NSImage(size: destSize)

    newImage.lockFocus()

    self.draw(in: NSRect(origin: .zero, size: destSize),
              from: NSRect(origin: .zero, size: self.size),
              operation: .copy,
              fraction: CGFloat(1)
    )

    newImage.unlockFocus()

    guard let data = newImage.tiffRepresentation,
          let result = NSImage(data: data)
    else { return NSImage() }

    return result
  }
}
