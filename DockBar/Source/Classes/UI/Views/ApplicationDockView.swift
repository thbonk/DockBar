//
//  ApplicationDockView.swift
//  DockBar
//
//  Created by Thomas Bonk on 17.07.21.
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

struct ApplicationDockView: View {

  // MARK: - Public Properties
  
  var body: some View {
    HStack {
      Spacer()
      ApplicationTiles()
      Spacer()
    }
  }


  // MARK: - Private Methods

  private func ApplicationTiles() -> AnyView {
    do {
      let model = try dockModelProvider.model()

      return AnyView(
        ForEach(model.applications) { app in
        Image(nsImage: app.icon!)
          .padding(.horizontal, 2)
          .padding(.vertical, 5)
          .onTapGesture {
            dockPanelController.launch(application: app)
          }
      })
    } catch {
      NSAlert.showModalAlert(
                  style: .critical,
            messageText: "Error while reading the macOS Dock configuration.",
        informativeText: "The error is \(error)",
                buttons: ["OK"])
      return AnyView(Text("Error while retrieving the applications from the Dock."))
    }
  }

  // MARK: - Private Properties

  private var columns = Array(repeating: GridItem(.flexible()), count: 5)

  @EnvironmentObject
  private var dockModelProvider: DockModelProvider
  @EnvironmentObject
  private var dockPanelController: DockPanelController
}

struct ApplicationDockView_Previews: PreviewProvider {
  static var previews: some View {
    ApplicationDockView()
  }
}
