//
//  MatchManager+GKMatchDelegate.swift
//  POCGameKit
//
//  Created by Andrei Rech on 05/11/25.
//

import Foundation
import GameKit

extension MatchManager: GKMatchDelegate {
    func incrementCounter() {
        counter += 1
        sendString("increment")
    }
    
    func endGame() {
        inGame = false
        isGameOver = true
        sendString("gameOver")
    }

    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let content = String(decoding: data, as: UTF8.self)
        
        if content.starts(with: "strData:") {
            let message = content.replacing("strData:", with: "")
            receivedString(message)
        }
    }
    
    func receivedString(_ message: String) {
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else { return }
        
        let parameter = String(messageSplit.last ?? "")
        
        switch messagePrefix {
        case "began":
            if parameter == playerUUIDKey {
                playerUUIDKey = UUID().uuidString
                sendString("began:\(playerUUIDKey)")
                break
            }
            inGame = true
            
        case "increment":
            counter += 1
            
        case "gameOver":
            inGame = false
            isGameOver = true
            
        default:
            break
        }
    }
    
    func sendString(_ message: String) {
        guard let enconded = "strData:\(message)".data(using: .utf8) else { return }
        sendData(enconded, mode: .reliable)
    }
    
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        do {
            try match?.sendData(toAllPlayers: data, with: mode)
        } catch {
            print(error)
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        endGame()
    }
}
