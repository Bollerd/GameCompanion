//
//  WhosNextView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 26.08.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import SwiftUI

struct WhosNextView: View {
    @Binding var isActiveWhosNext: Bool
    @EnvironmentObject var app: App
    @ObservedObject var whosNext: WhosNextFeatures
    
    var body: some View {
        ZStack {
            BackgroundLayout()
            VStack {
                self.winnerOrCurrentView
                Spacer()
                VStack {
                    if self.whosNext.noOfActivePlayers > 1 {
                        Button(action: {
                            if self.whosNext.noOfActivePlayers > 1 {
                                self.whosNext.setNextPlayer()
                            }
                        }, label: {
                            HStack {
                                Spacer()
                                Image(systemName: "forward.fill").foregroundColor(whosNext.playersButtonColor)
                                Text("Next player").font(.headline).foregroundColor(whosNext.playersButtonColor)
                                Spacer()
                            }
                        }).padding(.bottom,CGFloat(10))
                        Button(action: {
                            self.whosNext.setCurrentPlayerFinished()
                            if self.whosNext.noOfActivePlayers > 1 {
                                self.whosNext.setNextPlayer()
                            }
                            
                        }, label: {
                            HStack {
                                Spacer()
                                Image(systemName: "stop.fill").foregroundColor(whosNext.playersButtonColor)
                                Text("Player finished").font(.headline).foregroundColor(self.whosNext.playersButtonColor)
                                Spacer()
                            }
                        }).padding(.bottom,CGFloat(10))
                    }
                   
                    Button(action: {
                        self.whosNext.resetPlayersFinished(players: self.app.players)
                    }, label: {
                        HStack {
                            if FULL_WIDTH_BUTTONS == true {
                                Spacer()
                            }
                            Image(systemName: "gobackward")
                            Text("Restart").font(.headline)
                            if FULL_WIDTH_BUTTONS == true {
                                Spacer()
                            }
                        }
                    }).buttonStyle(GradientButtonStyle())
                        .padding(10)
                }
            }.padding()
        }.onAppear {
            self.whosNext.resetPlayersFinished(players: self.app.players)
            self.whosNext.setNextPlayer()
        }.navigationBarTitle(Text("Whos next"))
    }
    
    // return the view to be currently displayed
    private var winnerOrCurrentView: some View {
        switch self.whosNext.noOfActivePlayers {
        case 1:
            return AnyView(
                VStack {
                    HStack {
                        Text("Winner is \(self.whosNext.winnerName)").font(.largeTitle)
                    }.padding(.bottom, 20)
                    HStack {
                        Text("Looser is \(self.whosNext.looserName)").font(.headline)
                    }
                }
            )
        default:
            return AnyView(Text("\(self.whosNext.nextPlayer.name)").font(.largeTitle))
        }
    }
}

struct WhosNextView_Previews: PreviewProvider {
    @State static var isActive = true
    @State static var whosNext = WhosNextFeatures(players: DEFAULT_PLAYERS_OBJECTS)
    
    static var previews: some View {
        WhosNextView(isActiveWhosNext:$isActive, whosNext: whosNext).environmentObject(App())
    }
}
