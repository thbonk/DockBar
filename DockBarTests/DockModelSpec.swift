//
//  DockModelSpec.swift
//  DockBarTests
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

import Foundation
import Quick
import Nimble

@testable import DockBar

final class DockModelSpec: QuickSpec {

  override func spec() {

    describe("Loading and evaluating the Dock configuration") {

      var dockModel: DockModel? = nil

      it("Instantiate the Dock model") {
        dockModel = DockModel()

        expect(dockModel).notTo(beNil())
      }

      it("Check whether the persistent apps are available") {
        let apps = dockModel?.applications

        expect(apps).notTo(beNil())
        apps?.forEach { entry  in
          expect(entry.label).toNot(beEmpty())
          expect(entry.bundleIdentifier).toNot(beEmpty())
          expect(entry.url).toNot(beNil())
          expect(entry.icon).toNot(beNil())
        }
      }
    }
  }

}
