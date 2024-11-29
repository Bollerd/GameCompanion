//
//  SLFAnswersView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 06.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//
//  this is the view containing the answers of
//  each user per round

import SwiftUI


struct SLFAnswersView: View {
    @Binding var isActiveSLF: Bool
    @EnvironmentObject var app: App
    @ObservedObject var slf: SLFFeatures
    @State var needRefresh: Bool = false
    @State var id = UUID()
    var body: some View {
        VStack {
            Text(self.slf.nextQuestion.question).font(.headline)
            if self.slf.processAllActiveQuestions {
                Text("\(self.slf.currentRound) / \(self.app.noOfActiveSLFQuestions)").font(.footnote)
               
            } else {
                Text("\(self.slf.currentRound) / \(self.slf.totalRounds)").font(.footnote)
               
            }
            List {
                ForEach($slf.players, id: \.id) { $player in
                    HStack {
                        VStack(alignment: .leading, spacing: 2.0) {
                            Text(player.name).font(.title3)
                            //Spacer()
                            /*
                            Text(String(player.slfAnswer)).id(id)
                             */
                            TextField("Answer", text: $player.slfAnswer).textFieldStyle(OrangeRoundedBorderStyle())
                            Text("\(translateText(keyText: "This round")) \(String(self.slf.getPointsSinglePlayer(player: player)))").id(id).font(.footnote)
                            Text("\(translateText(keyText: "Total before")) \(String(player.slfTotalPoints))").font(.footnote)
                        }
                        Spacer()
                        Button(action: {
                            player.setSLFAnswer(answer: "")
                            self.needRefresh.toggle()
                            self.id = UUID()
                        }, label: {
                            HStack {
                                Image(systemName: "trash.fill")
                                    .onTapGesture(count: 2) {
                                            player.resetSLFAnswer()
                                            self.needRefresh.toggle()
                                            self.id = UUID()
                                        }
                            }
                            
                            }).buttonStyle(BigGradientButtonStyle())
                            .frame(alignment: .trailing)
                    }.listRowBackground(Color.clear)
                }
            }.listStyle(.plain)
            Spacer()
            Button(action: {
                self.slf.calculatePoints()
            }, label: {
                HStack {
                    if FULL_WIDTH_BUTTONS == true {
                        Spacer()
                    }
                    Text("Calculate points")
                    if FULL_WIDTH_BUTTONS == true {
                        Spacer()
                    }
                }
                
            }).buttonStyle(GradientButtonStyle())
            .padding(10)
        }
    }
}

struct SLFAnswersView_Previews: PreviewProvider {
    @State static var isActive = true
    @State static var slf = SLFFeatures(players: DEFAULT_PLAYERS_OBJECTS, questions: DEFAULT_QUESTIONS_OBJECTS, questionType: .own, rounds: SLF_FIXED_ROUNDS, seconds: SLF_FIXED_SECONDS, possibleCharacters: DEFAULT_SLF_CHARS, processAllActiveQuestions: false)
    
    static var previews: some View {
        SLFAnswersView(isActiveSLF:$isActive, slf: slf).environmentObject(App())
    }
}

