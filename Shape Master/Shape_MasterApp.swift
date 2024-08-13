//
//  Shape_MasterApp.swift
//  Shape Master
//
//  Created by Thamindu Gamage on 2024-06-07.
//

import SwiftUI

@main
struct Shape_MasterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
