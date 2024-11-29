//
//  SettingsView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 06.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isActiveSettings: Bool
    @State var isActivePlayers = false
    @State var isActiveSLFQuestions = false
    @State var isActiveLifesSettings = false
    @State var isActiveDiceSettings = false
    @State var isActiveTargetSettings = false
    @State var showCreditsView = false
    @EnvironmentObject var app: App
    //  var buttonSpacer = CGFloat(20.0)
    
    var body: some View {
        /*
        let plainColor: Binding<Bool> = Binding(
            get: {
                switch app.appColoring {
                case .colored:
                    return false
                case .plain:
                    return true
                }
            },
            set: { _ in  }
        )
       */
        var plainColor: Bool {
            get {
                switch app.appColoring {
                case .colored:
                    return false
                case .plain:
                    return true
                }
            }
            set {  }
        }
        
        ZStack {
            BackgroundLayout()
            VStack {
                Spacer().frame(height: 30.0, alignment: Alignment.center)
                
                ScrollView {
                    NavigationLink(destination: PlayersView(isActivePlayers: $isActivePlayers).environmentObject(self.app),
                                   isActive: $isActivePlayers,
                                   label: {
                        Button(action: {
                            self.isActivePlayers = true
                        }, label: {
                            HStack {
                                Image(systemName: "person.3")
                                Text("Players").font(.headline)
                            }
                        }).buttonStyle(GradientSettingsButtonStyle())
                    }).padding(.bottom, self.app.buttonSpacer)
                    
                    NavigationLink(destination: SLFQuestionsView(isActiveSLFQuestions: $isActiveSLFQuestions).environmentObject(self.app),
                                   isActive: $isActiveSLFQuestions,
                                   label: {
                        Button(action: {
                            self.isActiveSLFQuestions = true
                        }, label: {
                            HStack {
                                Image(systemName: "quote.bubble.fill")
                                Text("Questions").font(.headline)
                            }
                        }).buttonStyle(GradientSettingsButtonStyle())
                    }).padding(.bottom, self.app.buttonSpacer)
                    
                    NavigationLink(destination: LifesSettingsView(isActiveLifesSettings: $isActiveLifesSettings).environmentObject(self.app),
                                   isActive: $isActiveLifesSettings,
                                   label: {
                        Button(action: {
                            self.isActiveLifesSettings = true
                        }, label: {
                            HStack {
                                Image(systemName: "hand.thumbsdown")
                                Text("Lifes").font(.headline)
                            }
                        }).buttonStyle(GradientSettingsButtonStyle())
                    }).padding(.bottom, self.app.buttonSpacer)
                    
                    NavigationLink(destination: DiceSettingsView(isActiveDiceSettings: $isActiveDiceSettings).environmentObject(self.app),
                                   isActive: $isActiveDiceSettings,
                                   label: {
                        Button(action: {
                            self.isActiveDiceSettings = true
                        }, label: {
                            HStack {
                                Image(systemName: "dice")
                                Text("Dices").font(.headline)
                            }
                        }).buttonStyle(GradientSettingsButtonStyle())
                    }).padding(.bottom, self.app.buttonSpacer)
                    
                    NavigationLink(destination: TargetSettingsView(isActiveTargetSettings: $isActiveTargetSettings).environmentObject(self.app),
                                   isActive: $isActiveTargetSettings,
                                   label: {
                        Button(action: {
                            self.isActiveTargetSettings = true
                        }, label: {
                            HStack {
                                Image(systemName: "target")
                                Text("Hit the target").font(.headline)
                            }
                        }).buttonStyle(GradientSettingsButtonStyle())
                    }).padding(.bottom, self.app.buttonSpacer)
                    
                    Button(action: {
                        self.showCreditsView.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                            Text("Credits").font(.headline)
                        }
                    }).buttonStyle(GradientSettingsButtonStyle()).sheet(isPresented: $showCreditsView) {
                        CreditsView(plainColor: plainColor).presentationDetents([.medium]).presentationDragIndicator(.visible)
                    }.padding(.bottom, self.app.buttonSpacer)
                    
                    Button(action: {
                        self.app.synchronizeKeyStore()
                    }, label: {
                        HStack {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                            Text("Synchronize").font(.headline)
                        }
                    }).buttonStyle(GradientSettingsButtonStyle())
                    
                }
                
                //   Spacer()
            }.navigationBarTitle("Settings").padding(.bottom)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var isActive = true
    
    static var previews: some View {
        SettingsView(isActiveSettings:$isActive).environmentObject(App())
    }
}

