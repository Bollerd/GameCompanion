//
//  SLFView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 02.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//
//  this is the entry view to start the game - contains
//  at beginning only the button to start the game

import SwiftUI

struct SLFView: View {
    @Binding var isActiveSLF: Bool
    @EnvironmentObject var app: App
    @ObservedObject var slf: SLFFeatures
    @State var needRefresh: Bool = false
    var body: some View {
        ZStack {
            BackgroundLayout()
            VStack {
                self.currentUpperView
                Spacer()
            }.padding().navigationBarTitle(Text("SLF"))
        }
    }
    
    // return the view to be currently displayed
    private var currentUpperView: some View {
        switch self.slf.viewStatus {
        case .question:
            if self.slf.allowedSeconds == 0 || self.slf.allowedSeconds != self.slf.remainingSeconds {
                return AnyView(
                    SLFQuestionView(isActiveSLF: self.$isActiveSLF, slf: self.slf).environmentObject(self.app)
                )
            } else {
                return AnyView(
                    VStack {
                        Spacer()
                        Button {
                            self.slf.startTimer()
                        } label: {
                            HStack {
                                if FULL_WIDTH_BUTTONS == true {
                                    Spacer()
                                }
                                Text("\(translateText(keyText: "Start Timer")) \(self.slf.nextPlayer.name)")
                                if FULL_WIDTH_BUTTONS == true {
                                    Spacer()
                                }
                            }
                        }.buttonStyle(GradientButtonStyle())
                        Spacer()
                    }.padding()
                )
            }
            
        case .answers:
            return AnyView(
                SLFAnswersView(isActiveSLF: self.$isActiveSLF, slf: self.slf).environmentObject(self.app)
            )
        case .finished:
            return AnyView(
                SLFFinishedView(isActiveSLF: self.$isActiveSLF, slf: self.slf).environmentObject(self.app)
            )
        }
    }
    
}

struct SLFView_Previews: PreviewProvider {
    @State static var isActive = true
    @State static var slf = SLFFeatures(players: DEFAULT_PLAYERS_OBJECTS,questions: DEFAULT_QUESTIONS_OBJECTS, questionType: .own, rounds: SLF_FIXED_ROUNDS, seconds: SLF_FIXED_SECONDS, possibleCharacters: DEFAULT_SLF_CHARS, processAllActiveQuestions: false)
    
    static var previews: some View {
        SLFView(isActiveSLF:$isActive, slf: slf).environmentObject(App())
    }
}

