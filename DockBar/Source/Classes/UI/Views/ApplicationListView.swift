//
//  ApplicationListView.swift
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
import Combine
import SwiftUI

struct ApplicationListView: View {

  // MARK: - Public Properties

  var body: some View {
    VStack {
      ApplicationList()
    }
  }


  // MARK: - Private Properties

  @EnvironmentObject
  private var dockModelProvider: DockModelProvider
  @EnvironmentObject
  private var statusBarController: StatusBarController

  @State
  private var selectedEntry: DockEntry!


  // MARK: - Private Methods

  private func ApplicationList() -> AnyView {
    do {
      let view = AnyView(
        List(try dockModelProvider.model().applications, id: \.self, selection: $selectedEntry) { app in
          HStack {
            Image(nsImage: app.icon!)
            Text(app.label)
            Spacer()
          }
          .padding(.all, 3)
          .cornerRadius(5)
      })

      DispatchQueue.main.async {
        if let entry = self.selectedEntry {
          DispatchQueue.main.async {
            self.statusBarController.launch(application: entry)
          }
        }
      }

      return view
    } catch {
      NSAlert.showModalAlert(
                  style: .critical,
            messageText: "Error while reading the macOS Dock configuration.",
        informativeText: "The error is \(error)",
                buttons: ["OK"])
      return AnyView(Text("Error retrieving the applications from the Dock."))
    }
  }
}

