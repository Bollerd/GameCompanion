//
//  LifesFinishedView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 06.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import SwiftUI

struct LifesFinishedView: View {
    @Binding var isActiveLifes: Bool
    @EnvironmentObject var app: App
    @ObservedObject var lifes: LifesFeatures
    @State var needRefresh: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Winner is \(self.lifes.winnerName)").font(.largeTitle)
            }.padding(.bottom, 20)
            HStack {
                Text("Looser is \(self.lifes.looserName)").font(.headline)
            }
        }
    }
}

struct LifesFinishedView_Previews: PreviewProvider {
    @State static var isActive = true
    @State static var lifes = LifesFeatures(players: DEFAULT_PLAYERS_OBJECTS)
    
    static var previews: some View {
        LifesFinishedView(isActiveLifes:$isActive, lifes: lifes).environmentObject(App())
    }
}
