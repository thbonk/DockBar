//
//  SetupWizardView.swift
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

import SwiftUI

struct SetupWizardView: View {

  // MARK: - Public Properties

  var body: some View {
    VStack {
      pages[currentPage]

      Spacer()

      HStack {
        Button {
          if currentPage > 0 {
            currentPage = currentPage - 1
          }
        } label: {
          Image(systemName: "arrow.left.circle")
        }
        .disabled(currentPage <= 0)

        Spacer()

        Button {
          if currentPage < pages.count - 1 {
            currentPage = currentPage + 1
          }
        } label: {
          Image(systemName: "arrow.right.circle")
        }
        .disabled(currentPage >= pages.count - 1)
      }
      .padding(.all, 10)
    }
    .frame(width: 500, height: 300, alignment: .center)
  }

  var pages: [AnyView] = [
    AnyView(Step1Information()),
    AnyView(Step2SelectPreferencesFolder()),
  ]

  @State
  var currentPage: Int = 0
}

