//
//  GameOverScene.swift
//  POCGameKit
//
//  Created by Andrei Rech on 05/11/25.
//

import SwiftUI

struct GameOverScene: View {
    @State var matchManager: MatchManager
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: -32) {
                    Text(matchManager.counter.description)
                        .font(Font.system(size: 200))
                        .fontWeight(.heavy)
                        .foregroundStyle(Color(.label))
                    
                    Text("Final Score")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(.label))
                }
                .padding(.bottom, 50)
                
                Button {
                    matchManager.returnToMenu()
                } label: {
                    Text("Return")
                        .foregroundStyle(Color(.secondarySystemBackground))
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding()
                .background(Capsule().fill(.green))
                
                Spacer()
            }
        }
    }
}

#Preview {
    GameOverScene(matchManager: MatchManager())
}
