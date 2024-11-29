//
//  PointsView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 08.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import SwiftUI

struct PointsView: View {
    @Binding var isActivePoints: Bool
    @EnvironmentObject var app: App
    @ObservedObject var points: PointsFeatures
    @State var needRefresh: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundLayout()
            VStack {
                self.currentUpperView
                self.currentLowerView
                //   Spacer().frame(height:10)
            }.padding().onAppear {
                self.points.resetPlayersFinished(players: self.app.players)
            }.navigationBarTitle(Text("Points"))
        }
    }
    
    // return the view to be currently displayed
    private var currentUpperView: some View {
        switch self.points.viewStatus {
        case .playerList, .finished:
            return AnyView(
                PointsListView(isActivePoints: self.$isActivePoints, points: self.points).environmentObject(self.app)
            )
        case .enterPoints:
            return AnyView(
                PointsInputView(isActivePoints: self.$isActivePoints, points: self.points).environmentObject(self.app)
            )
        }
    }
    
    // return the view to be currently displayed
    private var currentLowerView: some View {
        switch self.points.viewStatus {
        case .playerList:
            return AnyView(
                VStack {
                    Button(action: {
                        self.points.switchToInputView()
                    }, label: {
                        HStack {
                            if FULL_WIDTH_BUTTONS == true {
                                Spacer()
                            }
                            Image(systemName: "play.fill")
                            Text("Next round")
                            if FULL_WIDTH_BUTTONS == true {
                                Spacer()
                            }
                        }
                    }).buttonStyle(GradientButtonStyle())
                        .padding(.horizontal, CGFloat(10))
                    Button(action: {
                        self.points.switchToFinishedView()
                    }, label: {
                        HStack {
                            if FULL_WIDTH_BUTTONS == true {
                                Spacer()
                            }
                            Image(systemName: "stop.fill")
                            Text("Finish game")
                            if FULL_WIDTH_BUTTONS == true {
                                Spacer()
                            }
                        }
                    }).buttonStyle(GradientButtonStyle())
                        .padding(CGFloat(10))
                }
            )
        case .finished:
            return AnyView(
                VStack {
                    Button(action: {
                        self.points.resetPlayersFinished(players: self.app.players)
                    }, label: {
                        HStack {
                            Spacer()
                            Image(systemName: "gobackward")
                            Text("Restart")
                            Spacer()
                        }
                    }).buttonStyle(GradientButtonStyle()).padding(CGFloat(10))
                }
                
            )
        case .enterPoints:
            return AnyView(EmptyView())
        }
    }
}

struct PointsView_Previews: PreviewProvider {
    @State static var isActive = true
    @State static var points = PointsFeatures(players: DEFAULT_PLAYERS_OBJECTS)
    
    static var previews: some View {
        PointsView(isActivePoints:$isActive, points: points).environmentObject(App())
    }
}
