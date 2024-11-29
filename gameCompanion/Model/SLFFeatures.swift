//
//  SLFFeatures.swift
//  gameCompanion
//
//  Created by Dirk Boller on 02.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import Foundation
import SwiftUI

enum SLFFeaturesUpperViewType {
    case question
    case finished
    case answers
}

enum SLFSpecialQuestions {
    case own
    case celebs, nature, meals, human, entertainment, kids, others
}

class SLFFeatures: ObservableObject {
    @Published var players = DEFAULT_PLAYERS_OBJECTS
    var slfQuestions = DEFAULT_QUESTIONS_OBJECTS
    var slfPlayQuestions = DEFAULT_QUESTIONS_OBJECTS
    @Published var nextPlayer = DEFAULT_PLAYERS_OBJECTS[0]
    @Published var playersButtonColor = BUTTON_COLOR
    @Published var winnerName = ""
    @Published var looserName = ""
    @Published var nextQuestion = DEFAULT_QUESTIONS_OBJECTS[0]
    @Published var answer = ""
    @Published var startingCharacter = "A"
    @Published var viewStatus = SLFFeaturesUpperViewType.question
    @Published var totalRounds = 5
    @Published var currentRound = 1
    @Published var allowedSeconds = SLF_FIXED_SECONDS
    @Published var remainingSeconds = SLF_FIXED_SECONDS
    @Published var remainingCircle = Double(1.0)
    @Published var timer: Timer?
    @Published var possibleStartCharacters = DEFAULT_SLF_CHARS
    @Published var processAllActiveQuestions = false
    @Published var currentPlayQuestionIndex = -1
    var noOfActiveSLFQuestions: Int {
        var count = 0
        for q in slfQuestions {
            if q.enabled == true {
                count += 1
            }
        }
        return count
    }
    var currentPlayer = 1
    
    var noOfPlayers : Int {
        return players.count
    }
    var currentPlayerIndex : Int {
        return currentPlayer - 1
    }
    
    /// initiaizer of the class
    /// - Parameters:
    ///   - players: array of players to take part in the game
    ///   - questions: array of questions players has to answer
    init(players: [Player],questions: [SLFQuestion], questionType: SLFSpecialQuestions, rounds: Int, seconds: Int, possibleCharacters: String, processAllActiveQuestions: Bool) {
        // must be first command as resetSLF requires correct setting of processAllActiveQuestions
        self.processAllActiveQuestions = processAllActiveQuestions
        let specialQuestionArray = initSpecialSLFQuestions(questionType: questionType)
        switch questionType {
        case .celebs, .entertainment,.human,.kids,.meals,.nature,.others:
            resetSLF(players: players, questions: specialQuestionArray, rounds: rounds)
        default:
            resetSLF(players: players, questions: questions, rounds: rounds)
        }
        self.totalRounds = rounds
        self.allowedSeconds = seconds
        self.remainingSeconds = seconds
        self.possibleStartCharacters = possibleCharacters
    }
    
    func initSpecialSLFQuestions(questionType: SLFSpecialQuestions) -> [SLFQuestion] {
        var questions = [String()]
        
        switch questionType {
        case .celebs:
            questions = SLF_PERSÖNLICHKEITEN
        case .entertainment:
            questions = SLF_UNTERHALTUNG
        case .human:
            questions = SLF_MENSCH
        case .kids:
            questions = SLF_KINDER
        case .meals:
            questions = SLF_ESSENUNDTRINKEN
        case .nature:
            questions = SLF_NATUR
        case .others:
            questions = SLF_SONSTIGES
       default:
            questions = ["WRONGVALUE"]
        }
        
        var retQuestions = [SLFQuestion]()
        for question in questions {
            let q = SLFQuestion(question: question)
            retQuestions.append(q)
        }
        
        return retQuestions
    }
    
    func startTimer() {
        self.remainingSeconds = self.allowedSeconds
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.remainingSeconds -= 1
            self.remainingCircle = 1 - (Double(self.remainingSeconds) / Double(self.allowedSeconds))
            if self.remainingSeconds <= 0 {
              //  self.timer?.invalidate()
              //  self.remainingSeconds = self.allowedSeconds
                self.getNextPlayer()
            }
        }
    }
    
    /// reinitialize the SLF game by resetting the players, questions and all other attributes
    /// like points, rounds played....
    /// - Parameters:
    ///   - players: array of players to take part in the game
    ///   - questions: array of questions players has to answer
    func resetSLF(players: [Player],questions: [SLFQuestion], rounds: Int) {
        self.currentPlayQuestionIndex = -1
        self.players.removeAll()
        for player in players {
            if player.enabled == true {
                player.resetSLF()
                self.players.append(player)
            }
        }
        self.playersButtonColor = BUTTON_COLOR
        self.winnerName = ""
        self.looserName = ""
        self.slfQuestions = questions
        self.slfPlayQuestions.removeAll()
        for question in questions {
            if question.enabled == true{
                self.slfPlayQuestions.append(question)
            }
        }
        self.currentRound = 1
        self.currentPlayer = 1
        self.totalRounds = rounds
        self.getRandomCharacter()
        self.getRandomQuestions()
        self.nextPlayer = self.players[self.currentPlayerIndex]
        self.viewStatus = .question
    }
    
    /// get the next player to enter the data, switches the view status to answerview if the last player of a round was processed
    func getNextPlayer() {
        self.timer?.invalidate()
        self.remainingSeconds = self.allowedSeconds
        self.remainingCircle = 1.0
       
        self.currentPlayer += 1
        
        // if current player is the last player, we must set the current player to the first one and change the ui view
        if ( self.currentPlayer > self.noOfPlayers ) {
            self.viewStatus = .answers
            self.currentPlayer = 1
        }
        
        self.nextPlayer = self.players[self.currentPlayerIndex]
    }
    
    /// calculate the number of points by checking if the answer of an player is the same answer of a different player or only one player has the answer
    func calculatePoints() {
        // first calculate the points
        for player in self.players {
            player.calcSLFPoints(players: self.players, startCharacter: self.startingCharacter)
            
            debug_print("Current points: \(player.name): \(player.slfTotalPoints)")
        }
        
        // now get new questions and new starting character
        self.getRandomQuestions()
        self.getRandomCharacter()
        self.currentRound += 1
        
        // remove all given answers from the players
        self.removeAnswers()
        
        // if the current round was the last, sort the player list and show the finish view
        if ( self.currentRound > self.totalRounds  && self.processAllActiveQuestions == false ) || ( self.currentRound > self.noOfActiveSLFQuestions  && self.processAllActiveQuestions == true ) {
            self.viewStatus = .finished
            
            self.players = self.players.sorted(by: { $0.slfTotalPoints > $1.slfTotalPoints })
        } else {
            self.viewStatus = .question
        }
    }
    
    /// calculate the number of points by checking if the answer of an player is the same answer of a different player or only one player has the answer
    func getPointsSinglePlayer(player: Player) -> String {
       return player.getSLFPointsForPlayer(players: self.players, startCharacter: self.startingCharacter)
    }
    
    /// loop over all players and remove their answers
    func removeAnswers() {
        for player in self.players {
            player.setSLFAnswer(answer: "")
        }
    }
    
    /// get a random character for which the players must find the answer
    func getRandomCharacter() {
        var availableChars = [String]()
        // default setting if user entered no value
        var startChars = DEFAULT_SLF_CHARS
        
        // if user defined start characters, we use them
        if self.possibleStartCharacters != "" {
            startChars = self.possibleStartCharacters
        }
        
        startChars = startChars.uppercased()
        
        for char in startChars {
            availableChars.append(String(char))
        }
       
        self.startingCharacter = availableChars.randomElement()!
    }
    
    /// get a random question for the players from the list of questions
    func getRandomQuestions() {
        if self.processAllActiveQuestions == true {
            self.currentPlayQuestionIndex += 1
            if self.currentPlayQuestionIndex >= self.slfPlayQuestions.count {
                self.currentPlayQuestionIndex = 0
            }
             self.nextQuestion = self.slfPlayQuestions[self.currentPlayQuestionIndex]
        } else {
            self.nextQuestion = self.slfPlayQuestions.randomElement()!
        }
        if self.nextQuestion.enabled == false {
            getRandomQuestions()
        }
    }
}


