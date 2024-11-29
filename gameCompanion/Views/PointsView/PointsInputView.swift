//
//  PointsInputView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 08.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import SwiftUI

struct PointsInputView: View {
    @Binding var isActivePoints: Bool
    @EnvironmentObject var app: App
    @ObservedObject var points: PointsFeatures
    @State var needRefresh: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Text("Current player").font(.subheadline)
                Text("\(self.points.nextPlayer.name)").font(.largeTitle)
            }
            VStack {
                HStack {
                    Spacer().frame(width: 50)
                    TextField("Please enter your current points", text: $points.nextPlayer.pointsCurrentPoints, onCommit: {
                        UIApplication.shared.windows.first {$0.isKeyWindow}?.endEditing(true)
                       // UIApplication.shared.keyWindow?.endEditing(true)
                    }).keyboardType(.numberPad).textFieldStyle(OrangeRoundedBorderStyle())
                    Spacer().frame(width: 50)
                }
                Spacer()
                VStack {
                    Button(action: {
                        self.points.getNextPlayer()
                    }, label: {
                        HStack {
                            if FULL_WIDTH_BUTTONS == true {
                                Spacer()
                            }
                            
                            Text("Next player")
                            if FULL_WIDTH_BUTTONS == true {
                                Spacer()
                            }
                            
                        }
                    }).buttonStyle(GradientButtonStyle())
                    .padding()
                }
            }
        }
    }
}

struct PointsInputView_Previews: PreviewProvider {
    @State static var isActive = true
    @State static var points = PointsFeatures(players: DEFAULT_PLAYERS_OBJECTS)
    
    static var previews: some View {
        PointsInputView(isActivePoints:$isActive, points: points).environmentObject(App())
    }
}
