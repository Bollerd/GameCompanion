//
//  Players.swift
//  gameCompanion
//
//  Created by Dirk Boller on 21.08.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import Foundation

class Player: Identifiable, ObservableObject {
    @Published var id = UUID()
    @Published var name: String
    @Published var enabled = true
    @Published var slfAnswer = ""
    @Published var slfRoundPoints = 0
    @Published var slfTotalPoints = 0
    @Published var lifesCurrentLifes = LIFES_TOTAL_LIFES
    @Published var pointsCurrentPoints = ""
    @Published var pointsTotalPoints = 0
    @Published var targetsPoints = 0
    @Published var targetsTime: Int64 = 0
    
    var isActive = true
    var totalLifes = LIFES_TOTAL_LIFES
    private var slfDeletedAnswer = ""
    
    /// Initializer of class
    /// - Parameter name: name of the player
    init(name: String) {
        self.name = name
    }
    
    /// set player status to inactive
    func setPlayerEnded() {
        self.isActive = false
    }
    
    /// reset all the player attributes to initial values
    func resetPlayerEnded() {
        self.lifesCurrentLifes = LIFES_TOTAL_LIFES
        self.isActive = true
        self.totalLifes = LIFES_TOTAL_LIFES
        self.pointsTotalPoints = 0
        self.pointsCurrentPoints = ""
    }
    
    //*
    // Functions for Points
    //*
    func addPoints() {
        let intPoints = Int(self.pointsCurrentPoints) ?? 0
        self.pointsTotalPoints += intPoints
    }
    
    //*
    // Functions for SLF
    //*
    
    /// subtract 1 of the players lifes and sets isActive to false if the player lost the last life
    func setPlayerLostLife() {
        if self.lifesCurrentLifes == 0 {
            return
        }
        
        self.lifesCurrentLifes -= 1
        debug_print("set current lifes to \(self.lifesCurrentLifes) for \(self.name)")
        
        if self.lifesCurrentLifes == 0 {
            self.isActive = false
        }
        
        self.id = UUID()
    }
    
    //*
    // Functions for SLF
    //*
    
    /// set the SLF answer of the player
    /// - Parameter answer: answer for the SLF question
    func setSLFAnswer(answer: String) {
        if self.slfAnswer != "" && answer == "" {
            self.slfDeletedAnswer = self.slfAnswer
        }
        
        self.slfAnswer = answer
        debug_print("Set slfAnswer for \(self.name) to \(self.slfAnswer)")
        self.id = UUID()
    }
    
    /// reset the SLF answer of the player to the last state remembered in delete attribute
    func resetSLFAnswer() {
        self.slfAnswer = self.slfDeletedAnswer
        debug_print("Set slfAnswer for \(self.name) to \(self.slfAnswer)")
        self.id = UUID()
    }
    
    /// Reset the attributes for SLF
    func resetSLF() {
        self.slfRoundPoints = 0
        self.slfTotalPoints = 0
    }
    
    /// calculate points for SLF by giving 0 points if answer is not the correct starting character, 10 points if someone else has the same answer or 20 points if the answer is a single answer
    /// - Parameters:
    ///   - players: Array of players to compare the answer of current player with
    ///   - startCharacter: Character which is required for the answer as first character
    func calcSLFPoints(players: [Player],startCharacter: String) {
        if self.slfAnswer.prefix(1).capitalized != startCharacter {
             return
        }
        
        self.slfRoundPoints = 20
        
        for player in players {
            if player.id == self.id {
                continue
            }
            
            if player.slfAnswer.trimmingCharacters(in: .whitespacesAndNewlines).capitalized == self.slfAnswer.trimmingCharacters(in: .whitespacesAndNewlines).capitalized {
                self.slfRoundPoints = 10
            }
        }
        
        self.slfTotalPoints += self.slfRoundPoints
    }
    
    /// calculate points for SLF by giving 0 points if answer is not the correct starting character, 10 points if someone else has the same answer or 20 points if the answer is a single answer
    /// - Parameters:
    ///   - players: Array of players to compare the answer of current player with
    ///   - startCharacter: Character which is required for the answer as first character
    func getSLFPointsForPlayer(players: [Player],startCharacter: String) -> String {
        if self.slfAnswer.prefix(1).capitalized != startCharacter {
            return "0"
        }
        
        self.slfRoundPoints = 20
        
        for player in players {
            if player.id == self.id {
                continue
            }
            
            if player.slfAnswer.trimmingCharacters(in: .whitespacesAndNewlines).capitalized == self.slfAnswer.trimmingCharacters(in: .whitespacesAndNewlines).capitalized {
                self.slfRoundPoints = 10
            }
        }
        
        return "\(self.slfRoundPoints)"
    }
}

