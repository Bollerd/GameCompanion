//
//  DiceView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 23.06.22.
//  Copyright © 2022 Dirk Boller. All rights reserved.
//

import SwiftUI

var diceTimer = Timer()

struct DiceView: View {
    @Binding var isActiveDices: Bool
    @EnvironmentObject var app: App
    @ObservedObject var model = DiceFeatures(sides: DICES_SIDES, amount: DICES_AMOUNT, players: [Player(name: "Default")])
    @State var playerNo = 0
    @State var delay = 0.2
    private let defaultDelay = 0.2
    private let maxDelay = 2.0
    let columnLayout = Array(repeating: GridItem(), count: 3)
    var animation: Animation {
        Animation.linear
    }
    
    var body: some View {
        ZStack {
            BackgroundLayout()
            VStack {
                Text("\(self.model.nextPlayer.name)").font(.largeTitle)
                Spacer()
                ScrollView {
                    LazyVGrid(columns: columnLayout) {
                        ForEach((0...self.model.diceNumberObjects.count-1), id: \.self) {
                            //Text("\($0)…")
                            ColView(model: model, index: Binding.constant($0))
                        }
                    }
                }
                Spacer()
                if (self.model.isAnimating == false ) {
                    
                    VStack {
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
                        Button(action: {
                            self.model.setCurrentPlayerFinished()
                        }, label: {
                            HStack {
                                Spacer()
                                Image(systemName: "stop.fill").foregroundColor(self.model.playersButtonColor)
                                Text("Player finished").font(.headline).foregroundColor(self.model.playersButtonColor)
                                Spacer()
                            }
                        }).padding(.bottom,CGFloat(10))
                        Button(action: {
                            self.model.resetPlayersFinished(players: self.app.players)
                        }, label: {
                            HStack {
                                Spacer()
                                Image(systemName: "gobackward").foregroundColor(self.model.playersButtonColor)
                                Text("Restart").font(.headline).foregroundColor(self.model.playersButtonColor)
                                Spacer()
                            }
                        }).padding(.bottom,CGFloat(10))
                    }
                    Button(action: {
                        withAnimation(.easeInOut) {
                            //
                        }
                        rollDice()
                    }, label: {
                        HStack {
                            if FULL_WIDTH_BUTTONS == true {
                                Spacer()
                            }
                            Text("Roll dices")
                            if FULL_WIDTH_BUTTONS == true {
                                Spacer()
                            }
                        }
                    }).padding().buttonStyle(GradientButtonStyle())
                }
                
            }.padding().onAppear {
                self.model.resetSides(sides: DICES_SIDES, amount: DICES_AMOUNT)
                self.model.resetPlayersFinished(players: app.players)
            }.navigationBarTitle(Text("Dices"))
        }
    }
    private func rollDice() {
        self.model.isAnimating = true
        self.model.isRotated.toggle()
        self.model.getNumbers()
        delay = delay * 2
        if delay < 2 {
            diceTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { _ in
                rollDice()
            })
        } else {
            delay = 0.2
            self.model.isAnimating = false
        }
    }
}

struct ColView: View {
    @ObservedObject var model: DiceFeatures
    @Binding var index: Int
    @State private var presentAlert = false
    @State private var setValue = ""
    var animation: Animation {
        Animation.linear
        //.repeatForever(autoreverses: false)
    }
    
    var body: some View {
        ZStack {
            if   model.diceNumberObjects[index].locked == true {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)).foregroundColor(model.diceNumberObjects[index].color)
                    .frame(width: 100, height: 100)
                    .rotation3DEffect(Angle.degrees(model.isRotated ? 180 : 0), axis: (x: CGFloat(self.model.diceNumberObjects[index].rotationX), y:CGFloat(self.model.diceNumberObjects[index].rotationY), z: 0))
                //     .animation(animation, value: model.isRotated)
                    .onTapGesture {
                        if model.isAnimating == true {
                            print("Still dicing (rectangle locked)")
                        } else {
                            model.diceNumberObjects[index].locked.toggle()
                            model.isLocked.toggle()
                            debug_print("\(model.diceNumberObjects[index].locked)")
                        }
                    }
                
            } else {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)).foregroundColor(model.diceNumberObjects[index].color)
                    .frame(width: 100, height: 100)
                    .rotation3DEffect(Angle.degrees(model.isRotated ? 180 : 0), axis: (x: CGFloat(self.model.diceNumberObjects[index].rotationX), y:CGFloat(self.model.diceNumberObjects[index].rotationY), z: 0))
                    .animation(animation, value: model.isRotated)
                    .onTapGesture {
                        if model.isAnimating == true {
                            debug_print("Still dicing (rectangle unlocked)")
                        } else {        model.diceNumberObjects[index].locked.toggle()
                            model.isLocked.toggle()
                            debug_print("\(model.diceNumberObjects[index].locked)")
                        }
                    }
                
            }
            Text("\(model.diceNumberObjects[index].number)").font(.system(size: (80)))
                .onTapGesture {
                    if model.isAnimating == true {
                        debug_print("Still dicing (textview)")
                    } else {        model.diceNumberObjects[index].locked.toggle()
                        model.isLocked.toggle()
                        debug_print("\(model.diceNumberObjects[index].locked)")
                    }
                }/*
                  .gesture(LongPressGesture(minimumDuration: 0.5).onEnded({ value in
                 //   model.diceNumberObjects[index].number = 1
                   setValue = String(model.diceNumberObjects[index].number)
                    presentAlert = true
                })).alert("Convert number", isPresented: $presentAlert, actions: {
                    // Any view other than Button would be ignored
                    TextField("New value", text: $setValue).onChange(of: setValue) { newValue in
                        model.diceNumberObjects[index].number = Int(newValue) ?? 6
                    }
                }, message: {
                    // Any view other than Text would be ignored
                    TextField("Convert number", text: .constant("Change the current dice number to a different one"))
                })
                  */
                .gesture(LongPressGesture(minimumDuration: 0.5).onEnded({ value in
                 //   model.diceNumberObjects[index].number = 1
                   setValue = String(model.diceNumberObjects[index].number)
                    presentAlert = true
                })).alert("Convert number", isPresented: $presentAlert, actions: {
                    // Any view other than Button would be ignored
                    TextField("New value", text: $setValue).onChange(of: setValue) { newValue in
                        model.diceNumberObjects[index].number = Int(newValue) ?? 6
                    }
                }, message: {
                    // Any view other than Text would be ignored
                    Text("Change the current dice number to a different one")
                })
        }
    }
}

struct DiceView_Previews: PreviewProvider {
    @State static var isActive = true
    
    static var previews: some View {
        DiceView(isActiveDices: $isActive).environmentObject(App())
    }
}
