import SwiftUI

extension UIScreen{
    static var screenWidth = UIScreen.main.bounds.size.width
    static var screenHeight = UIScreen.main.bounds.size.height
    static var screenSize = UIScreen.main.bounds.size
    static var screenDimension: CGFloat {
        get {
            if screenWidth > screenHeight {
                return screenHeight - 250
            } else {
                return screenWidth - 250
            }
        }
    }
}

class Target: Identifiable {
    let id = UUID()
    var active: Bool
    var row: Int
    var col: Int
    init(row: Int, col: Int) {
        active = false
        self.row = row
        self.col = col
    }
}

class TargetRow: Identifiable {
    let id = UUID()
    var cols: [Target]
    
    init(cols: [Target]) {
        self.cols = cols
    }
} 

var noTargets = 4

class TargetFeatures : ObservableObject {
    var rows = 1...noTargets
    var cols = 1...noTargets
    var rounds = 20
    var imageSize = CGFloat(( Int(UIScreen.screenDimension) - noTargets * 50 ) / noTargets)
    @Published var runningGame = false
    @Published var hitTarget = false
    @Published var backgroundColor = Color.clear
    @Published var gameboard = [TargetRow]()
    @Published var hits = 0
    @Published var updateUI = false
    @Published var progress: CGFloat = 0.0
    
    var players = DEFAULT_PLAYERS_OBJECTS
    @Published var finishedPlayers = DEFAULT_PLAYERS_OBJECTS
    var nextPlayerIndex = 0
    @Published var nextPlayer = DEFAULT_PLAYERS_OBJECTS[0]
    @Published var playersButtonColor = BUTTON_COLOR
    @Published var allPlayersPlayed = false
    @Published var currentPlayerPlayed = false
    private var timeStampTargetVisible:Int64 = 0
    private var totalTimestamp: Int64 = 0
    
    var noOfActivePlayers : Int {
        return players.count
    }
    
    /// initializer of the class
    /// - Parameter rows: number of rows for target
    /// - Parameter cols: number of cols for target
    /// - Parameter rounds: number of rounds to play
    /// - Parameter minTime: seconds the target is at least visible
    /// - Parameter maxTime: seconds the target is maximum visible
    /// - Parameter players: array of players to be member of the game
    init(rows: Int, cols: Int, rounds: Int, minTime: Double, maxTime: Double, players: [Player]) {
        self.resetTarget(rows: rows, cols: cols, rounds: rounds, minTime: minTime, maxTime: maxTime)
        self.resetPlayersFinished(players: players)
    }
    
    /// reset the class to new start
    /// - Parameter rows: number of rows for target
    /// - Parameter cols: number of cols for target
    /// - Parameter rounds: number of rounds to play
    /// - Parameter minTime: seconds the target is at least visible
    /// - Parameter maxTime: seconds the target is maximum visible
    /// - Parameter players: array of players to be member of the game
    func resetTarget(rows: Int, cols: Int, rounds: Int, minTime: Double, maxTime: Double) {
        self.rows = 1...rows
        self.cols = 1...cols
        self.rounds = rounds
        TARGET_MAX_TIME = maxTime
        TARGET_MIN_TIME = minTime
        self.nextPlayerIndex = 1
        self.allPlayersPlayed = false
        self.runningGame = false
        if cols > rows {
            noTargets = cols
        } else {
            noTargets = rows
        }
        
        gameboard.removeAll(keepingCapacity: true)
        for row in self.rows {
            var currentRow = TargetRow(cols:[Target]())
            
            for col in self.cols {
                let target = Target(row: row, col: col)
                currentRow.cols.append(target)
            }
            
            gameboard.append(currentRow)
        }
    }
    
    /// reset the class to new start
    /// - Parameter players: array of players to be member of the game
    func resetPlayersFinished(players: [Player]) {
        self.nextPlayerIndex = 1
        self.allPlayersPlayed = false
        self.players = players
        self.nextPlayer = self.players[self.nextPlayerIndex - 1]
        self.currentPlayerPlayed = false
        self.runningGame = false
        self.finishedPlayers.removeAll()
    }
    
    func setNextPlayer() {
        self.hits = 0
        self.totalTimestamp = 0
        self.finishedPlayers.append(self.nextPlayer)
        
        if self.noOfActivePlayers == 1 {
            self.allPlayersPlayed = true
            self.updateUI.toggle()
            return
        }
        
        var newPlayerIndex = self.nextPlayerIndex + 1
        
        if newPlayerIndex > self.noOfActivePlayers {
            self.allPlayersPlayed = true
            self.finishedPlayers = self.finishedPlayers.sorted {
                //($0.targetsPoints,$0.targetsTime) > ($1.targetsPoints,$1.targetsTime)
                if $0.targetsPoints != $1.targetsPoints { // first, compare by last names
                    return $0.targetsPoints > $1.targetsPoints
                }
                else  {
                    return $0.targetsTime < $1.targetsTime
                }
            }
            self.updateUI.toggle()
            return
        }
        self.nextPlayer = self.players[newPlayerIndex - 1]
        self.nextPlayerIndex = newPlayerIndex
        self.currentPlayerPlayed = false
    }
    
    func setScreenSize(width: CGFloat, height: CGFloat) {
        var screenDimension = width
        
        if height < width {
            screenDimension = height
        }
        
        self.imageSize = CGFloat(( Int(screenDimension) - noTargets * 30 ) / noTargets)
    }
    
    func getActiveTarget() {
        let randomRow = Int.random(in: rows)
        let randomCol = Int.random(in: cols)
        timeStampTargetVisible = Date.currentTimeStamp
        for targetRow in gameboard {
            for target in targetRow.cols {
                if target.row == randomRow && target.col == randomCol {
                    target.active = true
                } else {
                    target.active = false
                }
            }
        }
    }
    
    func startGame() {
        self.hits = 0
        tickTimer()
    }
    
    func tickTimer() {
        self.runningGame = true
        let lowerRange = TARGET_MIN_TIME
        let upperRange = TARGET_MAX_TIME
        let interval = Double.random(in: lowerRange...upperRange)
        Timer.scheduledTimer(withTimeInterval: interval, repeats: false) {
            timer in
            self.progress += 1 / CGFloat(self.rounds)
            self.updateUI.toggle()
            if self.progress > 1 {
                self.progress = 0
                self.runningGame = false
                self.nextPlayer.targetsPoints = self.hits
                self.nextPlayer.targetsTime = self.totalTimestamp
                self.currentPlayerPlayed = true
                
                // if the last player played, we want to show the result immediatly
                if self.noOfActivePlayers == self.nextPlayerIndex {
                    self.setNextPlayer()
                }
            } else {
                self.nextPlayer.targetsPoints = self.hits
                self.hitTarget = false
                self.getActiveTarget()
                self.tickTimer()
            }
        }
    }
    
    func missedTarget() {
        if hitTarget == true || self.currentPlayerPlayed == true {
            return
        }
        hitTarget = true
        hits -= 1
        self.updateUI.toggle()
    }
    
    func hitTarget(col: Int, row: Int) {
        if hitTarget == true || self.currentPlayerPlayed == true {
            return
        }
        
        hitTarget = true
        for targetRow in gameboard {
            for target in targetRow.cols {
                if target.row == row && target.col == col {
                    //    target.active.toggle()
                    if target.active == true {
                        totalTimestamp = totalTimestamp + Date.currentTimeStamp - timeStampTargetVisible
                        hits += 1
                    } else {
                        hits -= 1
                    }
                    self.updateUI.toggle()
                    return
                }
            }
        }
    }
}
