//
//  DiceFeatures.swift
//  gameCompanion
//
//  Created by Dirk Boller on 23.06.22.
//  Copyright © 2022 Dirk Boller. All rights reserved.
//

import Foundation

import SwiftUI

extension Int {
    func times(body: () -> Void)  {
        for _ in 1...self {
            body()
        }
    }
}
 
class Dice: ObservableObject {
    @Published var rotationX = 1
    @Published var rotationY = 0
    @Published var number = 0
    @Published var locked = false {
        didSet {
            if locked == true {
                self.color = .red
            } else {
                self.color = .gray
            }
        }
    }
    @Published var color = Color.gray
    func rollDice(maxDice: String) {
        let max: Int = Int(maxDice) ?? 6
        self.number = Int.random(in: 1...max)
        self.rotationX = Int.random(in: 0...1)
        if self.rotationX == 1 {
            self.rotationY = 0
        } else {
            self.rotationY = 1
        }
    }
}

class DiceFeatures: ObservableObject {
    @Published var maxDice = "6"
    @Published var dicesInput = "1"
    @Published var isRotated = false
    @Published var isLocked = false
    @Published var isAnimating = false
    var dices: Int {
    get {
        return Int(self.dicesInput) ?? 1
    }}
    @Published var diceNumberObjects = [Dice()]
    
    var players = DEFAULT_PLAYERS_OBJECTS
    var activePlayers = DEFAULT_PLAYERS_OBJECTS
    var nextPlayerIndex = 0
    @Published var nextPlayer = DEFAULT_PLAYERS_OBJECTS[0]
    @Published var playersButtonColor = BUTTON_COLOR
    
    var noOfActivePlayers : Int {
        return activePlayers.count
    }
    
    
    /// initializer of the class
    /// - Parameter sides: number of sides each dice
    /// - Parameter amount: number of dices to play with
    /// - Parameter players: array of players to be member of the game
    init(sides: Int, amount: Int, players: [Player]) {
        self.resetPlayersFinished(players: players)
        debug_print("Initializing Dice Model with \(amount) dices and \(sides) sides")
        self.maxDice = String(sides)
        self.dicesInput = String(amount)
        getNumbers()
    }
    
    /// reset the class
    /// - Parameter sides: number of sides each dice
    /// - Parameter amount: number of dices to play with
   func resetSides(sides: Int, amount: Int) {
        debug_print("Resetting Dice Model with \(amount) dices and \(sides) sides")
        self.maxDice = String(sides)
        self.dicesInput = String(amount)
        getNumbers()
    }
    
    /// create new random numbers for all not locked dices
    func getNumbers() {
        diceNumberObjects.removeAll{$0.locked == false}
        let newDices = self.dices - diceNumberObjects.count
        debug_print("removing dices")
        newDices.times {
            let numberObject = Dice()
            numberObject.rollDice(maxDice: self.maxDice)
            diceNumberObjects.append(numberObject)
        }
    }
    
    /// get a random number of the current active players and set the random player as next active player
    func setNextPlayer() {
        if self.noOfActivePlayers == 1 {
            return
        }
        
        self.nextPlayerIndex += 1
        
        if self.nextPlayerIndex == self.noOfActivePlayers {
            self.nextPlayerIndex = 0
        }
        self.nextPlayer = self.activePlayers[nextPlayerIndex]
        diceNumberObjects.removeAll()
        self.getNumbers()
    }
    
    /// set the currents player status to inactive, because he finished the game
    func setCurrentPlayerFinished() {
        if self.noOfActivePlayers == 1 {
            return
        }
        
        self.nextPlayer.setPlayerEnded()
        self.activePlayers.remove(at: self.nextPlayerIndex)
     
        // if last player finshed, set winner name and change button color status
        if self.noOfActivePlayers == 1 {
            self.playersButtonColor = Color.red
        }
        
        if self.nextPlayerIndex == self.noOfActivePlayers {
            self.nextPlayerIndex = self.noOfActivePlayers - 1
        }
        self.nextPlayer = self.activePlayers[nextPlayerIndex]
    }
    
    /// reinitialize the game. sets the players to the players added and clears all properties to
    /// initial values
    /// - Parameter players: array of player to participate in the game
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
        self.nextPlayerIndex = 0
        self.nextPlayer = self.activePlayers[nextPlayerIndex]
        self.diceNumberObjects.removeAll()
        self.getNumbers()
    }
}
