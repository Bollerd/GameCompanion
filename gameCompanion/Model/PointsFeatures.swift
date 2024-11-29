//
//  PointsFeatures.swift
//  gameCompanion
//
//  Created by Dirk Boller on 08.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import Foundation

enum PointsFeaturesUpperViewType {
    case finished
    case playerList
    case enterPoints
}

class PointsFeatures: ObservableObject {
    var players = DEFAULT_PLAYERS_OBJECTS
    
    @Published var viewStatus = PointsFeaturesUpperViewType.enterPoints
    @Published var nextPlayer = DEFAULT_PLAYERS_OBJECTS[0]
    
    var currentPlayer = 1
    
    var noOfPlayers : Int {
        return players.count
    }
    var currentPlayerIndex : Int {
        return currentPlayer - 1
    }
    
    /// initializer of the class
    /// - Parameter players: array of players to be member of the game
    init(players: [Player]) {
        self.resetPlayersFinished(players: players)
    }
    
    /// get the next player to enter the data, switches the view status to answerview if the last player of a round was processed
    func getNextPlayer() {
        self.players[self.currentPlayerIndex].addPoints()
        
        self.currentPlayer += 1
        
        // if current player is the last player, we must set the current player to the first one and change the ui view
        if ( self.currentPlayer > self.noOfPlayers ) {
            self.viewStatus = .playerList
            self.currentPlayer = 1
        }
        
        self.nextPlayer = self.players[self.currentPlayerIndex]
    }
    
    /// change upper view status to input status
    func switchToInputView() {
        self.viewStatus = .enterPoints
        
        for player in self.players  {
            player.pointsCurrentPoints = ""
        }
    }
    
    /// change upper view status to input status and sort player list
    func switchToFinishedView() {
        self.viewStatus = .finished
        self.players = self.players.sorted(by: { $0.pointsTotalPoints > $1.pointsTotalPoints })
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
        self.nextPlayer = self.players[self.currentPlayerIndex]
        self.viewStatus = .enterPoints
    }
}
