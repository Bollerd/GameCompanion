//
//  WhosNextFeatures.swift
//  gameCompanion
//
//  Created by Dirk Boller on 27.08.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import Foundation
import SwiftUI

class WhosNextFeatures: ObservableObject {
    var players = DEFAULT_PLAYERS_OBJECTS
    var activePlayers = DEFAULT_PLAYERS_OBJECTS
    
    @Published var nextPlayer = DEFAULT_PLAYERS_OBJECTS[0]
    @Published var playersButtonColor = BUTTON_COLOR
    @Published var winnerName = ""
    @Published var looserName = ""
    
    var noOfActivePlayers : Int {
        return activePlayers.count
    }
    
    /// initializer of the class
    /// - Parameter players: array of players to be member of the game
    init(players: [Player]) {
        self.resetPlayersFinished(players: players)
    }
    
    /// get a random number of the current active players and set the random player as next active player
    func setNextPlayer() {
        if self.noOfActivePlayers == 1 {
            return
        }
        let nextPlayerIndex = Int.random(in: 0..<self.noOfActivePlayers)
        self.nextPlayer = self.activePlayers[nextPlayerIndex]
    }
    
    /// set the currents player status to inactive, because he finished the game
    func setCurrentPlayerFinished() {
        if self.noOfActivePlayers == 1 {
            return
        }
        
        self.nextPlayer.setPlayerEnded()
        
        // if first player is finished, this palyer is the winner
        if self.winnerName == "" {
            self.winnerName = self.nextPlayer.name
        }
        
        // remove the current player from the index of players
        let uuid = self.nextPlayer.id
        var currentPlayerIndex = 0
        for activePlayer in self.activePlayers {
            if activePlayer.id == uuid {
                self.activePlayers.remove(at: currentPlayerIndex)
            }
            currentPlayerIndex += 1
        }
        
        // if last player finshed, set winner name and change button color status
        if self.noOfActivePlayers == 1 {
            self.playersButtonColor = Color.red
            self.looserName = self.activePlayers[0].name
        }
    }
    
    /// reinitialize the game. sets the players to the players added and clears all properties to
    /// initial values
    /// - Parameter players: array of player to participate in the game
    func resetPlayersFinished(players: [Player]) {
        self.players = players
        self.activePlayers.removeAll()
        for player in self.players {
            player.resetPlayerEnded()
            if player.enabled == true {
                self.activePlayers.append(player)
            }
        }
        self.playersButtonColor = BUTTON_COLOR
        self.winnerName = ""
        self.looserName = ""
    }
    
}
