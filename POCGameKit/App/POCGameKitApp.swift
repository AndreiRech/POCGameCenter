//
//  POCGameKitApp.swift
//  POCGameKit
//
//  Created by Andrei Rech on 05/11/25.
//

import SwiftUI

@main
struct POCGameKitApp: App {
    var body: some Scene {
        WindowGroup {
            ControllerView(matchManager: MatchManager())
        }
    }
}
