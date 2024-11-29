//
//  PointsListView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 08.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import SwiftUI

struct PointsListView: View {
    @Binding var isActivePoints: Bool
    @EnvironmentObject var app: App
    @ObservedObject var points: PointsFeatures
    @State var needRefresh: Bool = false
    
    var body: some View {
        VStack {
            List {
                ForEach(points.players) { player in
                    HStack {
                        Text(player.name)
                        Spacer()
                        Text(String(player.pointsTotalPoints)).frame(minWidth: 50.0, idealWidth: 50.0, maxWidth: 50.0)
                    }.listRowBackground(Color.clear)
                }
            }.listStyle(.plain).padding()
            Spacer()
        }
    }
}

struct PointsListView_Previews: PreviewProvider {
    @State static var isActive = true
    @State static var points = PointsFeatures(players: DEFAULT_PLAYERS_OBJECTS)
    
    static var previews: some View {
        PointsListView(isActivePoints:$isActive, points: points).environmentObject(App())
    }
}
