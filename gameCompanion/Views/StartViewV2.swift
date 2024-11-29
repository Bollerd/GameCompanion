//
//  ContentView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 21.08.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import SwiftUI

struct StartViewV2: View {
    @State var isActivePlayers = false
    @State var isActiveSLFQuestions = false
    @State var isActivePopup = false
    @State var isActiveWhosNext = false
    @State var isActiveSLF = false
    @State var isActiveLifes = false
    @State var isActiveDices = false
    @State var isActiveTarget = false
    @State var isActiveDicesStandalone = false
    @State var isActivePoints = false
    @State var isActiveSettings = false
    @EnvironmentObject var app: App
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                BackgroundLayout()
                VStack {
                    ScrollView {
                        Spacer().frame(height: 30.0, alignment: Alignment.center)
                        
                        NavigationLink(destination: SettingsView(isActiveSettings: $isActiveSettings).environmentObject(self.app),
                                       isActive: $isActiveSettings,
                                       label: {
                            Button(action: {
                                self.isActiveSettings = true
                            }, label: {
                                HStack {
                                    Image(systemName: "gear")
                                    Text("Settings").font(.headline)
                                }
                            }).buttonStyle(GradientButtonStyle())
                        }).padding(.bottom, self.app.buttonSpacer)
                        
                        NavigationLink(destination: WhosNextView(isActiveWhosNext:  $isActiveWhosNext, whosNext: WhosNextFeatures(players: self.app.players)).environmentObject(self.app),
                                       isActive: $isActiveWhosNext,
                                       label: {
                            Button(action: {
                                self.isActiveWhosNext = true
                            }, label: {
                                HStack {
                                    Image(systemName: "rectangle.stack.person.crop")
                                    Text("Whos next").font(.headline)
                                }
                            }).buttonStyle(GradientButtonStyle())
                        }).padding(.bottom, self.app.buttonSpacer)
                        
                        NavigationLink(destination: SLFView(isActiveSLF:  $isActiveSLF, slf: SLFFeatures(players: self.app.players, questions: self.app.slfQuestions, questionType: self.app.specialQuestions, rounds: self.app.SLF_TOTAL_ROUNDS, seconds: self.app.SLF_MAX_SECONDS, possibleCharacters: self.app.possibleStartCharacters, processAllActiveQuestions: self.app.SLF_PLAY_ALL_QUESTIONS)).environmentObject(self.app),
                                       isActive: $isActiveSLF,
                                       label: {
                            Menu {
                                 Button("Sonstiges", action: {
                                    self.app.specialQuestions = .others
                                    self.isActiveSLF = true
                                 })
                                 Button("Kinder", action: {
                                    self.app.specialQuestions = .kids
                                    self.isActiveSLF = true
                                 })
                                 Button("Unterhaltung", action: {
                                    self.app.specialQuestions = .entertainment
                                    self.isActiveSLF = true
                                 })
                                 Button("Mensch", action: {
                                    self.app.specialQuestions = .human
                                    self.isActiveSLF = true
                                 })
                                 Button("Essen und Trinken", action: {
                                    self.app.specialQuestions = .meals
                                    self.isActiveSLF = true
                                 })
                                 Button("Natur", action: {
                                    self.app.specialQuestions = .nature
                                    self.isActiveSLF = true
                                 })
                                 Button("Perönlichkeiten", action: { 
                                    self.app.specialQuestions = .celebs
                                    self.isActiveSLF = true
                                 })
                            } label: {
                                HStack {
                                    Image(systemName: "globe")
                                    Text("SLF").font(.headline)
                                }
                            }.menuStyle(GradientMenuStyle())
                        }).padding(.bottom, self.app.buttonSpacer)
                        
                        NavigationLink(destination: LifesView(isActiveLifes:  $isActiveLifes, lifes: LifesFeatures(players: self.app.players)).environmentObject(self.app),
                                       isActive: $isActiveLifes,
                                       label: {
                            Button(action: {
                                self.isActiveLifes = true
                            }, label: {
                                HStack {
                                    Image(systemName: "hand.thumbsdown.fill")
                                    Text("Lifes").font(.headline)
                                }
                            }).buttonStyle(GradientButtonStyle())
                        }).padding(.bottom, self.app.buttonSpacer)
                        
                        NavigationLink(destination: DiceView(isActiveDices:  $isActiveDices).environmentObject(self.app),
                                       isActive: $isActiveDices,
                                       label: {
                            Button(action: {
                                self.isActiveDices = true
                            }, label: {
                                HStack {
                                    Image(systemName: "dice")
                                    Text("Dices").font(.headline)
                                }
                            }).buttonStyle(GradientButtonStyle())
                        }).padding(.bottom, self.app.buttonSpacer)
                        
                        NavigationLink(destination: TargetView(isActiveTarget:  $isActiveTarget).environmentObject(self.app),
                                       isActive: $isActiveTarget,
                                       label: {
                            Button(action: {
                                self.isActiveTarget = true
                            }, label: {
                                HStack {
                                    Image(systemName: "target")
                                    Text("Hit the target").font(.headline)
                                }
                            }).buttonStyle(GradientButtonStyle())
                        }).padding(.bottom, self.app.buttonSpacer)
                        
                        NavigationLink(destination: PointsView(isActivePoints:  $isActivePoints, points: PointsFeatures(players: self.app.players)).environmentObject(self.app),
                                       isActive: $isActivePoints,
                                       label: {
                            Button(action: {
                                self.isActivePoints = true
                            }, label: {
                                HStack {
                                    Image(systemName: "equal.square.fill")
                                    Text("Points").font(.headline)
                                }
                            }).buttonStyle(GradientButtonStyle())
                        }).padding(.bottom, self.app.buttonSpacer)
                    }
                    Spacer()
                    Text("Made with ❤️ in SwiftUI by Dirk v \(VERSION) (\(BUILD))").font(.footnote)
                    //   .padding(.bottom,5)
                }.navigationBarTitle(Text("Game Companion"))
            }.background(Color.blue).navigationViewStyle(StackNavigationViewStyle())
                .onAppear{
                    debug_print("selection appear")
                    debug_print("current player no \(self.app.players.count)")
                }.onDisappear{
                    debug_print("selection disappear")
                    debug_print("current player no \(self.app.players.count)")
                }
        }.accentColor(NAVIGATION_ACCENT_COLOR)
    }
}

struct StartViewV2_Previews: PreviewProvider {
    static var previews: some View {
        StartViewV2().environmentObject(App())
    }
}
