//
//  PlayersView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 21.08.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import SwiftUI
import MobileCoreServices

struct PlayersView: View {
    @Binding var isActivePlayers: Bool
    @EnvironmentObject var app: App
    
    var body: some View {
        ZStack {
            BackgroundLayout()
            PlayerList().padding()
        }
    }
}

struct PlayersView_Previews: PreviewProvider {
    @State static var isActive = true
    
    static var previews: some View {
        PlayersView(isActivePlayers: $isActive).environmentObject(App())
    }
}

struct PlayerList: View {
    @State var isActivePlayerEdit = false
    @EnvironmentObject var app: App
    @State private var editMode = EditMode.inactive
    
    @State var isActiveNewPlayer = false
    @State private var deletedLastPlayer: Player?
    var body: some View {
        VStack {
            List {
                ForEach($app.players) { $player in
                    Toggle(isOn: $player.enabled,
                        label: { Text(player.name)
                    }).listRowBackground(Color.clear)
                }
                .onDelete(perform: onDelete)
                .onMove(perform: onMove)
            }.listStyle(.plain)
        }.onAppear{
            editMode = EditMode.active
            editMode = EditMode.inactive
        }
        .onDisappear{
            if ( self.app.noOfPlayers == 0 ) {
                for player in DEFAULT_PLAYERS_OBJECTS {
                    self.app.players.append(player)
                }
            }
            
            self.app.savePlayersDefaults()
        }
        
        .navigationBarTitle("Players")
        .navigationBarItems(trailing: trailingButtons)
        .environment(\.editMode, $editMode)
        .alert(item: $deletedLastPlayer) { show in
            Alert(title: Text(show.name), message: Text("Last player can't be deleted! Add new one first."), dismissButton: .cancel())
        }
    }
    
    // wrapper for the training buttons as hstack, if more than one must be displayed
    private var trailingButtons: some View {
        return AnyView(HStack {
            addButton
            EditButton()
        })
    }
    
    // return the add Button for the uI in case of edit mode disabled
    private var addButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(
                
                NavigationLink(destination: NewPlayerView(isActiveNewPlayer: $isActiveNewPlayer).environmentObject(app),
                               isActive: $isActiveNewPlayer,
                               label: {
                                Button(action: {
                                    self.isActiveNewPlayer = true
                                }, label: {
                                    HStack {
                                        Image(systemName: "person.crop.circle.badge.plus")
                                        Text("Add")
                                    }
                                })
                               })
            )
        default:
            return AnyView(EmptyView())
        }
    }
    
    // handle deletion of player
    private func onDelete(offsets: IndexSet) {
        if app.players.count == 1 {
            self.deletedLastPlayer = app.players[offsets[offsets.startIndex]]
        } else {
            app.players.remove(atOffsets: offsets)
        }
    }
    
    // drag / drop moving
    func onMove(source: IndexSet, destination: Int) {
        app.players.move(fromOffsets: source, toOffset: destination)
    }
    
}
