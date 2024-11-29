//
//  LifesFeatures.swift
//  gameCompanion
//
//  Created by Dirk Boller on 06.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import Foundation
import SwiftUI

enum LifesFeaturesUpperViewType {
    case finished
    case playerList
}
class LifesFeatures: ObservableObject {
    var players = DEFAULT_PLAYERS_OBJECTS
    var activePlayers = DEFAULT_PLAYERS_OBJECTS
    
    @Published var playersButtonColor = BUTTON_COLOR
    @Published var winnerName = ""
    @Published var looserName = ""
    @Published var viewStatus = LifesFeaturesUpperViewType.playerList
    
    var noOfActivePlayers : Int {
        return activePlayers.count
    }
    var noOfPlayers : Int {
        return players.count
    }
    
    /// initializer of the class
    /// - Parameter players: array of players to be member of the game
    init(players: [Player]) {
        self.resetPlayersFinished(players: players)
    }
    
    
    /// remove a life for the given player object. also sets winner and looser if the last of first player of the game lost his life and sorts the array of the players by their current lifes
    /// - Parameter player: player who lost his life
    func setPlayerLostLife(player: Player) {
        // dont do anything if only one player is left, set winner name and finished view
        if self.noOfActivePlayers == 1 {
            self.winnerName  = player.name
            self.viewStatus = .finished
            return
        }
        
        // remove a life from the players lifes and sort the player table
        player.setPlayerLostLife()
        self.activePlayers = self.activePlayers.sorted(by: { $0.lifesCurrentLifes > $1.lifesCurrentLifes })
        
        // if player died, we must remove him
        if player.isActive == true {
            return
        }
        
        // if first player died, set the looser
        if self.noOfActivePlayers == self.noOfPlayers {
            self.looserName  = player.name
        }
        
        // remove the current player from the array of all players
        let uuid = player.id
        var currentPlayerIndex = 0
        for activePlayer in self.activePlayers {
            if activePlayer.id == uuid {
                self.activePlayers.remove(at: currentPlayerIndex)
            }
            currentPlayerIndex += 1
        }
        
        // if last player died, set winner name and change view status
        if self.noOfActivePlayers == 1 {
            self.winnerName = self.activePlayers[0].name
            self.viewStatus = .finished
        }
        
    }
    
    /// reinitialize the game by resetting all players to default, winner and looser and the view status
    /// - Parameter players: array of players who are member of the game
    func resetPlayersFinished(players: [Player]) {
        self.players.removeAll()
        for player in players {
            player.resetPlayerEnded()
            if player.enabled == true {
                self.players.append(player)
            }
        }
        self.activePlayers = self.players
        self.playersButtonColor = BUTTON_COLOR
        self.winnerName = ""
        self.looserName = ""
        self.viewStatus = .playerList
    }
}
