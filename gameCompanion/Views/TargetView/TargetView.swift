//
//  TargetView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 25.07.23.
//  Copyright © 2023 Dirk Boller. All rights reserved.
//

import SwiftUI

struct ProgressBarTarget: View {
    @Binding var progress: CGFloat
    @EnvironmentObject var app: App
    @ObservedObject var model = TargetFeatures(rows: TARGET_ROWS, cols: TARGET_COLS, rounds: TARGET_ROUNDS, minTime: TARGET_MIN_TIME, maxTime: TARGET_MAX_TIME, players: [Player(name: "Default")])
    private var barColor: Color
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Main Bar
                Rectangle()
                    .fill(barColor.opacity(0.3))
                // Progress Bar
                Rectangle()
                    .fill(barColor)
                    .frame(width: min(geo.size.width, geo.size.width * progress))
                    .animation(.linear, value: model.updateUI)
            }.cornerRadius(45.0)
        }
    }
    
    public init(initialProgress: Binding<CGFloat>, color: Color, targetFeatures: TargetFeatures) {
        self._progress = initialProgress
        self.barColor = color
        self.model = targetFeatures
    }
}

struct TargetView: View {
    @Binding var isActiveTarget: Bool
    @EnvironmentObject var app: App
    @ObservedObject var model = TargetFeatures(rows: TARGET_ROWS, cols: TARGET_COLS, rounds: TARGET_ROUNDS, minTime: TARGET_MIN_TIME, maxTime: TARGET_MAX_TIME, players: [Player(name: "Default")])
    @State var playerNo = 0
    let columnLayout = Array(repeating: GridItem(), count: 3)
    var animation: Animation {
        Animation.linear
    }
    
    var body: some View {
        ZStack {
            BackgroundLayout()
            VStack {
                if model.allPlayersPlayed == false {
                    VStack {
                        Text("Treffer: \(model.hits)").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        GeometryReader(content: { geometry in
                            if model.runningGame == true {
                                VStack {
                                    ProgressBarTarget(initialProgress: $model.progress, color: .red, targetFeatures: model)
                                        .frame(height: 20)
                                        .padding()
                                    
                                    ForEach(model.gameboard) { row in
                                        HStack {
                                            Spacer()
                                            ForEach(row.cols) {
                                                col in
                                                HStack {
                                                    if col.active == true && model.hitTarget == false {
                                                        Image("Target").resizable().frame(width: model.imageSize,height: model.imageSize)
                                                    } else {
                                                        Image("Empty").resizable().frame(width: model.imageSize,height: model.imageSize)
                                                    }
                                                }.onTapGesture {
                                                    model.hitTarget(col: col.col, row: col.row)
                                                }.padding(15)
                                            }
                                            Spacer()
                                        }.onTapGesture {
                                            model.missedTarget()
                                        }//.background(Color.green)
                                    }
                                }.onRotate { newOrientation in
                                    model.setScreenSize(width: geometry.size.width, height: geometry.size.height)
                                }.onAppear {
                                    model.setScreenSize(width: geometry.size.width, height: geometry.size.height)
                                }.onTapGesture {
                                    model.missedTarget()
                                }//.background(Color.purple)
                            }
                        })
                    }.background(model.backgroundColor)
                    Text("\(self.model.nextPlayer.name)").font(.largeTitle)
                    Spacer()
                } else {
                    VStack {
                        List {
                            ForEach(model.finishedPlayers) { player in
                                HStack {
                                    Text(player.name)
                                    Spacer()
                                    VStack {
                                        Text(String(player.targetsPoints)).frame(minWidth: 50.0, idealWidth: 50.0, maxWidth: 50.0)
                                        Text("\(player.targetsTime) ms").font(Font.caption2).frame(minWidth: 50.0, idealWidth: 50.0, maxWidth: 50.0)
                                    }
                                }.listRowBackground(Color.clear)
                            }
                        }.listStyle(.plain)
                    }
                }
                
                VStack {
                    if model.allPlayersPlayed == false && model.currentPlayerPlayed == true {
                        Button(action: {
                            if self.model.noOfActivePlayers > 1 {
                                self.model.setNextPlayer()
                            }
                        }, label: {
                            HStack {
                                Spacer()
                                Image(systemName: "forward.fill").foregroundColor(self.model.playersButtonColor)
                                Text("Next player").font(.headline).foregroundColor(self.model.playersButtonColor)
                                Spacer()
                            }
                        }).padding(.bottom,CGFloat(10))
                    }
                    if model.allPlayersPlayed == true {
                        Button(action: {
                            self.model.resetPlayersFinished(players: self.app.getEnabledPlayers())
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
                        }).padding().buttonStyle(GradientButtonStyle())
                    }
                }
                VStack {
                    
                    if model.runningGame == false && model.allPlayersPlayed == false && model.currentPlayerPlayed == false {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                //
                            }
                            self.model.startGame()
                        }, label: {
                            HStack {
                                if FULL_WIDTH_BUTTONS == true {
                                    Spacer()
                                }
                                Text("Start")
                                if FULL_WIDTH_BUTTONS == true {
                                    Spacer()
                                }
                            }
                        }).buttonStyle(GradientButtonStyle()).padding()
                    }
                }
                
            }.padding(20)
                .onAppear {
                    self.model.resetTarget(rows: TARGET_ROWS, cols: TARGET_COLS, rounds: TARGET_ROUNDS, minTime: TARGET_MIN_TIME, maxTime: TARGET_MAX_TIME)
                    self.model.resetPlayersFinished(players: app.getEnabledPlayers())
                }.navigationBarTitle(Text("Hit the target"))
        }
    }
}

struct TargetView_Previews: PreviewProvider {
    @State static var isActive = true
    
    static var previews: some View {
        TargetView(isActiveTarget: $isActive).environmentObject(App())
    }
}

