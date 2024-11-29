//
//  LifesPlayersView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 06.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import SwiftUI

struct LifesPlayersView: View {
    @Binding var isActiveLifes: Bool
    @EnvironmentObject var app: App
    @ObservedObject var lifes: LifesFeatures
    @State private var updateWorkaround: Int32 = 0 {
        didSet { self.needsUpdate = true }
    }
    @State private var needsUpdate = false {
        didSet { if self.needsUpdate { self.needsUpdate = false } }
    }
    
    var body: some View {
        VStack {
            List(lifes.activePlayers, id: \.id) { player in HStack {
                VStack(alignment: .leading, spacing: 2.0) {
                    Text(player.name).font(.caption)
                    Text(String(player.lifesCurrentLifes))
                }
                Spacer()
                Button(action: {
                    self.lifes.setPlayerLostLife(player: player)
                    self.updateWorkaround += 1
                }, label: {
                    HStack {
                        Image(systemName: "bolt.circle")
                    }
                }).buttonStyle(BigGradientButtonStyle())
                    .frame(alignment: .trailing)
            }.listRowBackground(Color.clear)
            }.listStyle(.plain)
        }.background(Text("\(needsUpdate.description)").hidden())
    }
}

struct LifesPlayersView_Previews: PreviewProvider {
    @State static var isActive = true
    @State static var lifes = LifesFeatures(players: DEFAULT_PLAYERS_OBJECTS)
    
    static var previews: some View {
        LifesPlayersView(isActiveLifes:$isActive, lifes: lifes).environmentObject(App())
    }
}
