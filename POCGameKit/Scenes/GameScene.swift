//
//  GameScene.swift
//  POCGameKit
//
//  Created by Andrei Rech on 05/11/25.
//

import SwiftUI
import Speech

struct GameScene: View {
    @State var matchManager: MatchManager
    @State private var speechManager = SpeechManager()
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            VolumeButtonHandler(matchManager: matchManager)
                .frame(width: 0, height: 0)
            
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
        .onAppear {
            speechManager.startListening(matchManager: matchManager)
        }
        .onDisappear {
            speechManager.stopListening()
        }
    }
}

#Preview {
    GameScene(matchManager: MatchManager())
}
