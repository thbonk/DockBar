//
//  SetupWizardController.swift
//  DockBar
//
//  Created by Thomas Bonk on 20.07.21.
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

class SetupWizardController: NSHostingController<SetupWizardView> {

  // MARK: - Initialization

  init() {
    super.init(rootView: SetupWizardView())
  }

  @objc required dynamic init?(coder: NSCoder) {
    super.init(rootView: SetupWizardView())
  }
}
