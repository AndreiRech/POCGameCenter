//
//  GameScene.swift
//  POCGameKit
//
//  Created by Andrei Rech on 05/11/25.
//

import SwiftUI

struct GameScene: View {
    @State var matchManager: MatchManager
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text(matchManager.counter.description)
                    .font(Font.system(size: 200))
                    .fontWeight(.heavy)
                    .foregroundStyle(Color(.label))
                    .padding()
                
                HStack(spacing: 50) {
                    Button {
                        matchManager.incrementCounter()
                    } label: {
                        Text("Add counter")
                            .foregroundStyle(Color(.secondarySystemBackground))
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Capsule().fill(.green))
                    
                    Button {
                        matchManager.endGame()
                    } label: {
                        Text("Finish game")
                            .foregroundStyle(Color(.secondarySystemBackground))
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Capsule().fill(.red))
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    GameScene(matchManager: MatchManager())
}
