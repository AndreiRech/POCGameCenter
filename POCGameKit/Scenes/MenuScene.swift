//
//  MenuScene.swift
//  POCGameKit
//
//  Created by Andrei Rech on 05/11/25.
//

import SwiftUI

struct MenuScene: View {
    @State var matchManager: MatchManager
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "globe")
                .resizable()
                .scaledToFit()
                .padding(30)
                .foregroundStyle(Color.green)
            
            Spacer()
            
            Button {
                matchManager.startMatchmaking()
            } label: {
                Text("Play")
                    .foregroundStyle(Color(.secondarySystemBackground))
                    .font(.largeTitle)
                    .bold()
            }
            .disabled(
                matchManager.authenticatingState != .authenticated
                || matchManager.inGame
            )
            .padding(.vertical, 20)
            .padding(.horizontal, 100)
            .background(
                Capsule()
                    .fill(
                        matchManager.authenticatingState != .authenticated
                        || matchManager.inGame
                        ? .gray : .green
                    )
            )
            
            Text(matchManager.authenticatingState.rawValue)
                .foregroundStyle(Color(.label))
                .font(.headline)
                .fontWeight(.semibold)
                .padding()
            
            Spacer()
        }
        .background(
            Color(.secondarySystemBackground)
        )
        .ignoresSafeArea()
    }
}

#Preview {
    MenuScene(matchManager: MatchManager())
}
