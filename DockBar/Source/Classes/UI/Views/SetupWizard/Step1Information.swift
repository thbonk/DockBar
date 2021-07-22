//
//  Step1Information.swift
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

struct Step1Information: View {

  // MARK: - Public Properties
  
  var body: some View {
    VStack {
      Text("Information")
        .font(.title)
        .padding(.vertical, 10)

      Text("""
DockBar requires access to the macOS Dock configuration
located in the folder
""").padding([.horizontal, .bottom], 10)
      Text("\(AppDelegate.preferencesFolderUrl.path)")
      Text("""
In the next step, you have to select that folder, such that
access is granted by macOS.
""").padding([.horizontal, .top], 10).lineLimit(10)
    }
  }
}

struct Step1Information_Previews: PreviewProvider {
  static var previews: some View {
    Step1Information()
  }
}
