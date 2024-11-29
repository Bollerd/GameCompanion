//
//  App.swift
//  gameCompanion
//
//  Created by Dirk Boller on 21.08.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import Foundation
import SwiftUI



class App: ObservableObject {
    /// Determine Color Schema
    @AppStorage("APP_COLORING") var appColoring:AppColoring = .colored
    @Published var players = DEFAULT_PLAYERS_OBJECTS
    @Published var newPlayer = ""
    @Published var slfQuestions = DEFAULT_QUESTIONS_OBJECTS
    @Published var newSLFQuestion = ""
    @Published var specialQuestions = SLFSpecialQuestions.own
    /// number of rounds to play in SLF
    @Published var SLF_TOTAL_ROUNDS = 5
    // play all question from SLF?
    @Published var SLF_PLAY_ALL_QUESTIONS = true
   // number of seconds until answer must be entered in SLF
    @Published var SLF_MAX_SECONDS = 10
    // Characters allowed as start character in SLF questions
    @Published var possibleStartCharacters = "ABCDEFGHIJKLMNOPRSTUVWZ"
    /// Text type to be bound on the view
    var SLF_TOTAL_ROUNDS_TXT = "5" {
        didSet {
            SLF_TOTAL_ROUNDS = Int(SLF_TOTAL_ROUNDS_TXT) ?? SLF_FIXED_ROUNDS
        }
    }
    /// Text type to be bound on the view
    var SLF_MAX_SECONDS_TXT = "30" {
        didSet {
            SLF_MAX_SECONDS = Int(SLF_MAX_SECONDS_TXT) ?? SLF_FIXED_SECONDS
        }
    }
    var buttonSpacer = CGFloat(20.0)
    
    var noOfPlayers: Int {
        return players.count
    }
    var noOfSLFQuestions: Int {
        return slfQuestions.count
    }
    var noOfActiveSLFQuestions: Int {
        var count = 0
        for q in slfQuestions {
            if q.enabled == true {
                count += 1
            }
        }
        return count
    }
    
    let defaults = UserDefaults.standard
    var keyStore = NSUbiquitousKeyValueStore()
    
    // initializer of the class, sychronizes iCloud storage and reads default values
    init() {
        keyStore.synchronize()
        
        self.loadPlayersDefaults()
        self.loadSLFQuestionDefaults()
        self.loadLifesDefaults()
        self.loadDiceDefaults()
		self.loadTargetDefaults()
    }
    
    /// load the saved player names from the icloud storage
    func savePlayersDefaults() {
        var playerArray = [String]()
        var playerActiveArray = [Bool]()
        
        for player in self.players {
            debug_print("Saving Player name: \(player.name)")
            playerArray.append(player.name)
        }
        
        for player in self.players {
            debug_print("Saving Player status: \(player.enabled)")
            playerActiveArray.append(player.enabled)
        }
        
        keyStore.set(playerArray, forKey: "SavedPlayers")
        keyStore.set(playerActiveArray, forKey: "SavedPlayersActive")
        keyStore.synchronize()
    }
    
    /// save rounds to play in SLF to iCloud storage
    /// - Parameter rounds: rounds to be played
    func setRoundsSLF(rounds: String) {
        SLF_TOTAL_ROUNDS = Int(rounds) ?? SLF_FIXED_ROUNDS
        keyStore.set(SLF_TOTAL_ROUNDS, forKey: "SavedSLFQuestionAmount")
        debug_print("Set total rounds in SLF to \(rounds)")
        
        keyStore.synchronize()
    }
    
    /// save setting to play all questions or not  in SLF to iCloud storage
    /// - Parameter playAllQuestions: bool if all questiosn should be played
    func setPlayAllQuestionsSLF(playAllQuestions: Bool) {
        keyStore.set(SLF_PLAY_ALL_QUESTIONS, forKey: "SLFPlayAllQuestions")
        debug_print("Set play all questions in SLF to \(playAllQuestions)")
        
        keyStore.synchronize()
    }
    
    /// save seconds to play in SLF to iCloud storage
    /// - Parameter rounds: rounds to be played
    func setSecondsSLF(seconds: String) {
        SLF_MAX_SECONDS = Int(seconds) ?? SLF_FIXED_SECONDS
        keyStore.set(SLF_MAX_SECONDS, forKey: "SavedSLFSecondsAmount")
        debug_print("Set allowed seconds in SLF to \(seconds)")
        
        keyStore.synchronize()
    }
    
    /// synchronize local data with icloud data and read the saved values to the application parameters
    func synchronizeKeyStore() {
        keyStore.synchronize()
        
        self.loadPlayersDefaults()
        self.loadSLFQuestionDefaults()
        self.loadLifesDefaults()
        self.loadDiceDefaults()
		self.loadTargetDefaults()
    }
    
    /// saves the number of lifes a player has to the icloud storage
    /// - Parameter lifes: number of lifes a player has before he dies
    func setLifesTotalLifes(lifes: String) {
        LIFES_TOTAL_LIFES = Int(lifes) ?? 3
        keyStore.set(LIFES_TOTAL_LIFES, forKey: "SavedTotalLifes")
        debug_print("Set total lifes to \(lifes)")
        
        keyStore.synchronize()
    }
    
    /// saves the number dices and number of sides per dice to the icloud storage
    /// - Parameter dices: number of dices to roll
    /// - Parameter sides: number of sides each dice has
    func setDicesSetttings(dices: String, sides: String) {
        DICES_AMOUNT = Int(dices) ?? 5
        DICES_SIDES = Int(sides) ?? 6
        keyStore.set(DICES_AMOUNT, forKey: "SavedDicesNumbers")
        keyStore.set(DICES_SIDES, forKey: "SavedDicesSides")
        debug_print("Set dice number to \(dices)")
        debug_print("Set dice sides to \(sides)")
        
        keyStore.synchronize()
    }
    
	/// saves the hit the target minigame settings to the icloud storage
    /// - Parameter rows: number of rows to hit in target
    /// - Parameter cols: number of cols to hit in target
	/// - Parameter rounds: number of rounds to play in target
    func setTargetSetttings(rows: String, cols: String, rounds: String, minTime: String, maxTime: String) {
        TARGET_COLS = Int(cols) ?? 5
        TARGET_ROWS = Int(rows) ?? 6
		TARGET_ROUNDS = Int(rounds) ?? 20
        TARGET_MAX_TIME = Double(maxTime.replacing(",", with: ".")) ?? 3.0
        TARGET_MIN_TIME = Double(minTime.replacing(",", with: ".")) ?? 0.5
        keyStore.set(TARGET_ROWS, forKey: "SavedTargetRows")
        keyStore.set(TARGET_COLS, forKey: "SavedTargetCols")
        keyStore.set(TARGET_ROUNDS, forKey: "SavedTargetRounds")
        keyStore.set(TARGET_MAX_TIME, forKey: "SavedTargetMaxTime")
        keyStore.set(TARGET_MIN_TIME, forKey: "SavedTargetMinTime")
        debug_print("Set target rounds to \(rounds)")
        debug_print("Set target cols to \(cols)")
        debug_print("Set target rows to \(rows)")
        debug_print("Set target minTime to \(minTime)")
        debug_print("Set target maxTime to \(maxTime)")
       
        keyStore.synchronize()
    }
    
    /// load the hit the target settings from icloud storage
    func loadTargetDefaults() {
        if let cols = keyStore.object(forKey: "SavedTargetCols")  {
            TARGET_COLS = cols as? Int ?? 5
        } else {
            TARGET_COLS = 5
        }
        if let rows = keyStore.object(forKey: "SavedTargetRows")  {
            TARGET_ROWS = rows as? Int ?? 6
        } else {
            TARGET_ROWS = 6
        }
        if let rounds = keyStore.object(forKey: "SavedTargetRounds")  {
            TARGET_ROUNDS = rounds as? Int ?? 20
        } else {
            TARGET_ROUNDS = 20
        }
        if let minTime = keyStore.object(forKey: "SavedTargetMinTime")  {
            TARGET_MIN_TIME = minTime as? Double ?? 0.5
        } else {
            TARGET_MIN_TIME = 0.5
        }
        if let maxTime = keyStore.object(forKey: "SavedTargetMaxTime")  {
            TARGET_MAX_TIME = maxTime as? Double ?? 3.0
        } else {
            TARGET_MAX_TIME = 3.0
        }
    }
    
    /// load the dice settings  from icloud storage
    func loadDiceDefaults() {
        if let dices = keyStore.object(forKey: "SavedDicesNumbers")  {
            DICES_AMOUNT = dices as? Int ?? 5
        } else {
            DICES_AMOUNT = 5
        }
        if let sides = keyStore.object(forKey: "SavedDicesSides")  {
            DICES_SIDES = sides as? Int ?? 6
        } else {
            DICES_SIDES = 6
        }
    }
    
    /// load the number of lifes a player has from icloud storage
    func loadLifesDefaults() {
        if let lifes = keyStore.object(forKey: "SavedTotalLifes")  {
            LIFES_TOTAL_LIFES = lifes as? Int ?? 3
        } else {
            LIFES_TOTAL_LIFES = 3
        }
    }
    
    /// load the SLF questions and the number of rounds to play
    func loadSLFQuestionDefaults() {
        var questionArray = [String]()
        
        if let questionArrayCloud = keyStore.object(forKey: "SavedSLFQuestions")  {
            questionArray = questionArrayCloud as? [String] ?? DEFAULT_QUESTIONS_TEXT
        } else {
            questionArray = DEFAULT_QUESTIONS_TEXT
        }
        
        self.slfQuestions.removeAll()
        
        for question in questionArray {
            debug_print("Saved SLF question: \(question)")
            self.slfQuestions.append(SLFQuestion(question: question))
        }
        
        if let questionAmount = keyStore.object(forKey: "SavedSLFQuestionAmount")  {
            SLF_TOTAL_ROUNDS = questionAmount as? Int ?? SLF_FIXED_ROUNDS
        } else {
            SLF_TOTAL_ROUNDS = SLF_FIXED_ROUNDS
        }
        
        // set the text field to same value like INT field after loading from keychain
        SLF_TOTAL_ROUNDS_TXT = "\(SLF_TOTAL_ROUNDS)"
        
        if let secondsAmount = keyStore.object(forKey: "SavedSLFSecondsAmount")  {
            SLF_MAX_SECONDS = secondsAmount as? Int ?? SLF_FIXED_SECONDS
        } else {
            SLF_MAX_SECONDS = SLF_FIXED_SECONDS
        }
        
        // set the text field to same value like INT field after loading from keychain
        SLF_MAX_SECONDS_TXT = "\(SLF_MAX_SECONDS)"
        
        var startingChars = String()
        
        if let startingCharsCloud = keyStore.object(forKey: "SavedSLFStartChars")  {
            startingChars = startingCharsCloud as? String ?? DEFAULT_SLF_CHARS
        } else {
            startingChars = DEFAULT_SLF_CHARS
        }
        
        DEFAULT_SLF_CHARS = startingChars
        self.possibleStartCharacters = startingChars
        
        if let playAllQuestions = keyStore.object(forKey: "SLFPlayAllQuestions")  {
            SLF_PLAY_ALL_QUESTIONS = playAllQuestions as? Bool ?? false
        } else {
            SLF_PLAY_ALL_QUESTIONS = false
        }
    }
    
    /// save the array of SLF questions to iCloud storage
    func saveSLFQuestionDefaults() {
        var questionArray = [String]()
        
        for question in self.slfQuestions {
            debug_print("Saving SLF question: \(question.question)")
            questionArray.append(question.question)
        }
        
        keyStore.set(questionArray, forKey: "SavedSLFQuestions")
        keyStore.set(DEFAULT_SLF_CHARS, forKey: "SavedSLFStartChars")
        keyStore.synchronize()
    }
    
    /// load the saved player names from the icloud storage and create the player object array
    func loadPlayersDefaults() {
        var playerActiveArray = [Bool]()
        
        if let playerActiveArrayCloud = keyStore.object(forKey: "SavedPlayersActive")  {
            playerActiveArray = playerActiveArrayCloud as? [Bool] ?? [true]
        } else {
            playerActiveArray = DEFAULT_PLAYERS_STATE
        }
        
        var playerArray = [String]()
        
        if let playerArrayCloud = keyStore.object(forKey: "SavedPlayers")  {
            playerArray = playerArrayCloud as? [String] ?? DEFAULT_PLAYERS_TEXT
        } else {
            playerArray = DEFAULT_PLAYERS_TEXT
        }
        
        self.players.removeAll()
        var activeIndex = 0
        
        for player in playerArray {
            debug_print("Saved Player name: \(player)")
            let currentPlayer = Player(name: player)
            var playerStatus = true
            
            if activeIndex < playerActiveArray.count {
                playerStatus = playerActiveArray[activeIndex]
            }
                
            currentPlayer.enabled = playerStatus
            
            self.players.append(currentPlayer)
            activeIndex += 1
        }
    }
    
    func getEnabledPlayers() -> [Player] {
        var enabledPlayers = [Player]()
        self.players.forEach { player in
            if player.enabled {
                enabledPlayers.append(player)
            }
        }
        return enabledPlayers
    }
}
