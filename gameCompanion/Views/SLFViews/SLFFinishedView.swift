//
//  SLFFinishedView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 06.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//
//  this is the view with the final result of points
//  and for restarting the game

import SwiftUI

struct SLFFinishedView: View {
    @Binding var isActiveSLF: Bool
    @EnvironmentObject var app: App
    @ObservedObject var slf: SLFFeatures
    @State var needRefresh: Bool = false
    
    var body: some View {
        VStack {
            List {
                ForEach(slf.players) { player in
                    HStack {
                        Text(player.name)
                        Spacer()
                        Text(String(player.slfRoundPoints)).frame(minWidth: 50.0, idealWidth: 50.0, maxWidth: 50.0).hidden()
                        Spacer().frame(minWidth: 50.0, idealWidth: 50.0, maxWidth: 50.0).hidden()
                        Text(String(player.slfTotalPoints)).frame(minWidth: 50.0, idealWidth: 50.0, maxWidth: 50.0)
                    }.listRowBackground(Color.clear)
                }
            }.listStyle(.plain)
            Spacer()
            Button(action: {
                self.slf.resetSLF(players: self.app.players, questions: self.app.slfQuestions, rounds: self.app.SLF_TOTAL_ROUNDS)
            }, label: {
                HStack {
                    if FULL_WIDTH_BUTTONS == true {
                        Spacer()
                    }
                    Image(systemName: "gobackward")
                    Text("Restart")
                    if FULL_WIDTH_BUTTONS == true {
                        Spacer()
                    }
                }
            }).buttonStyle(GradientButtonStyle())
            .padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
    }
    
}

struct SLFFinishedView_Previews: PreviewProvider {
    @State static var isActive = true
    @State static var slf = SLFFeatures(players: DEFAULT_PLAYERS_OBJECTS,questions: DEFAULT_QUESTIONS_OBJECTS, questionType: .own, rounds: SLF_FIXED_ROUNDS, seconds: SLF_FIXED_SECONDS, possibleCharacters: DEFAULT_SLF_CHARS, processAllActiveQuestions: false)
    
    static var previews: some View {
        SLFFinishedView(isActiveSLF:$isActive, slf: slf).environmentObject(App())
    }
}

