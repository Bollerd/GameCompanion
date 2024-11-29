//
//  Constants.swift
//  gameCompanion
//
//  Created by Dirk Boller on 21.08.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import Foundation
import SwiftUI

enum AppColoring: Int {
    case colored = 0
    case plain = 1
   
}

/// App main model class
let app = App()

/// space for a button to his bottom
let BOTTOM_BUTTON_SPACER_BOTTOM = CGFloat(20.0)
/// space for a button to his left and right
let BOTTOM_BUTTON_SPACER_HORIZONTAL = CGFloat(20.0)
/// number of lifes in lifes play
var LIFES_TOTAL_LIFES = 3
/// number of sides a dice has
var DICES_SIDES = 6
/// number of dices to be used
var DICES_AMOUNT = 5
/// Default number of rounds for Stadt, Land, Fluss
var SLF_FIXED_ROUNDS = 5
/// Default number of seconds to enter answer for Stadt, Land, Fluss
var SLF_FIXED_SECONDS = 30
/// number of rows for playing target
var TARGET_ROWS = 6
/// number of columns for playing target
var TARGET_COLS = 5
/// number of rounds for playing target
var TARGET_ROUNDS = 20
/// number of rows for playing target
var TARGET_MIN_TIME = 0.7
/// number of columns for playing target
var TARGET_MAX_TIME = 5.0

/// App Color Information
var NAVIGATION_ACCENT_COLOR: Color {
get {
    switch app.appColoring {
    case .plain:
        return Color("AccentColorPlain")
    case .colored:
        return Color("AccentColor")
    }
}
}
var BUTTON_COLOR: Color {
    get {
        switch app.appColoring {
        case .plain:
            return Color("UIButtonPlain")
        case .colored:
            return Color("UIBackground")
        }
    }
}
var BACKGROUD_COLOR: Color {
    get {
        switch app.appColoring {
        case .plain:
            return Color("UIBackgroundPlain")
        case .colored:
            return Color("UIBackground")
        }
    }
}
var FOREGROUND_COLOR: Color {
    get {
        switch app.appColoring {
        case .plain:
            return Color("UIBackgroundOverlayPlain")
        case .colored:
            return Color("UIBackgroundOverlay")
        }
    }
}

/// Default allowed starting characters for SLF
var DEFAULT_SLF_CHARS =  "ABCDEFGHIJKLMNOPRSTUVWZ"

// default players (and for previews)
let DEFAULT_PLAYERS_OBJECTS = [Player(name: "\(translateText(keyText: "Player")) \(translateText(keyText: "One"))"),Player(name: "\(translateText(keyText: "Player")) \(translateText(keyText: "Two"))"),Player(name: "\(translateText(keyText: "Player")) \(translateText(keyText: "Three"))")]

/// default questions (and for previews)
let DEFAULT_QUESTIONS_OBJECTS = [SLFQuestion(question: "\(translateText(keyText: "Country"))"),SLFQuestion(question: "\(translateText(keyText: "City"))"),SLFQuestion(question: "\(translateText(keyText: "River"))"),SLFQuestion(question: "\(translateText(keyText: "Something green"))"),SLFQuestion(question: "\(translateText(keyText: "Something that can fly"))"),SLFQuestion(question: "\(translateText(keyText: "Something that makes noises"))"),SLFQuestion(question: "\(translateText(keyText: "Something cold"))")]

/// default players (and for previews)
let DEFAULT_PLAYERS_TEXT = [ "\(translateText(keyText: "Player")) \(translateText(keyText: "One"))",  "\(translateText(keyText: "Player")) \(translateText(keyText: "Two"))", "\(translateText(keyText: "Player")) \(translateText(keyText: "Three"))"]

/// default players (and for previews)
let DEFAULT_PLAYERS_STATE = [ true, true ]

/// default questions (and for previews)
let DEFAULT_QUESTIONS_TEXT = ["\(translateText(keyText: "Country"))", "\(translateText(keyText: "City"))", "\(translateText(keyText: "River"))", "\(translateText(keyText: "Something green"))","\(translateText(keyText: "Something that can fly"))","\(translateText(keyText: "Something that makes noises"))","\(translateText(keyText: "Something cold"))"]

/// display full screen buttons or smaller
let FULL_WIDTH_BUTTONS = false

/// UI App Information
let BUILD = "41"
let VERSION = "1.3.5"
