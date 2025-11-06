//
//  MatchManager+GKMatchmakerViewControllerDelegate.swift
//  POCGameKit
//
//  Created by Andrei Rech on 05/11/25.
//

import Foundation
import GameKit

extension MatchManager: GKMatchmakerViewControllerDelegate {
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true, completion: nil)
        startGame(newMatch: match)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: any Error) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func startGame(newMatch: GKMatch) {
        self.match = newMatch
        match?.delegate = self
        otherPlayer = match?.players.first
        counter = 0
        
        sendString("began:\(playerUUIDKey)")
    }
}
