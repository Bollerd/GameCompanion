//
//  NewPlayer.swift
//  gameCompanion
//
//  Created by Dirk Boller on 26.08.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import SwiftUI

struct NewPlayerView: View {
    @Binding var isActiveNewPlayer: Bool
    @EnvironmentObject var app: App
    
    var body: some View {
        ZStack {
            BackgroundLayout()
            VStack {
                Text("Name:")
                HStack {
                    Spacer()
                    TextField("Enter name", text: $app.newPlayer).textFieldStyle(OrangeRoundedBorderStyle())
                    Spacer()
                }
                Spacer()
            }.padding().navigationBarTitle("New Player")
                .onDisappear{
                    debug_print("disappear new player")
                    if self.app.newPlayer != "" {
                        self.app.players.append(Player(name:self.app.newPlayer.trimmingCharacters(in: .whitespacesAndNewlines)))
                    }
                    self.app.newPlayer = ""
                }
        }
    }
}

struct NewPlayerView_Previews: PreviewProvider {
    @State static var isActive = true
    
    static var previews: some View {
        NewPlayerView(isActiveNewPlayer: $isActive).environmentObject(App())
    }
}
