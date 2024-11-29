//
//  LifesView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 06.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import SwiftUI

struct LifesView: View {
    @Binding var isActiveLifes: Bool
    @EnvironmentObject var app: App
    @ObservedObject var lifes: LifesFeatures
    @State var needRefresh: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundLayout()
            VStack {
                VStack {
                    self.currentUpperView
                }
                Spacer()
                VStack {
                    Button(action: {
                        self.lifes.resetPlayersFinished(players: self.app.players)
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
            self.lifes.resetPlayersFinished(players: self.app.players)
        }.navigationBarTitle(Text("Lifes"))
    }
    
    // return the view to be currently displayed
    private var currentUpperView: some View {
        switch self.lifes.viewStatus {
        case .playerList:
            return AnyView(
                LifesPlayersView(isActiveLifes: self.$isActiveLifes, lifes: self.lifes).environmentObject(self.app)
            )
        case .finished:
            return AnyView(
                LifesFinishedView(isActiveLifes: self.$isActiveLifes, lifes: self.lifes).environmentObject(self.app)
            )
        }
    }
}

struct LifesView_Previews: PreviewProvider {
    @State static var isActive = true
    @State static var lifes = LifesFeatures(players: DEFAULT_PLAYERS_OBJECTS)
    
    static var previews: some View {
        LifesView(isActiveLifes:$isActive, lifes: lifes).environmentObject(App())
    }
}
