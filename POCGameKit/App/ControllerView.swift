//
//  ControllerView.swift
//  POCGameKit
//
//  Created by Andrei Rech on 05/11/25.
//

import SwiftUI

struct ControllerView: View {
    @State var matchManager: MatchManager
    
    var body: some View {
        ZStack {
            if matchManager.isGameOver {
                GameOverScene(matchManager: matchManager)
            } else if matchManager.inGame {
                GameScene(matchManager: matchManager)
            } else {
                MenuScene(matchManager: matchManager)
            }
        }
        .onAppear {
            matchManager.authenticatePlayer()
        }
    }
}

#Preview {
    ControllerView(matchManager: MatchManager())
}
