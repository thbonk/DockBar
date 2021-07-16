//
//  DockModelProvider.swift
//  DockBar
//
//  Created by Thomas Bonk on 15.07.21.
//

import Foundation

class DockModelProvider: ObservableObject {

  // MARK: - Public Properties

  func model() -> DockModel {
    return DockModel()
  }
}
