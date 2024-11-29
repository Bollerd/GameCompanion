//
//  DiceSettingsView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 23.06.22.
//  Copyright © 2022 Dirk Boller. All rights reserved.
//

import SwiftUI

struct DiceSettingsView: View {
    @Binding var isActiveDiceSettings: Bool
    @EnvironmentObject var app: App
    
    var body: some View {
        ZStack {
            BackgroundLayout()
            VStack {
                DiceSettingsViewInternal(diceSides: String(DICES_SIDES), diceAmount: String(DICES_AMOUNT))
            }.padding()
        }.onTapGesture {
            self.hideKeyboard()
        }.navigationBarTitle("Dices")
        
    }
}

struct DiceSettingsViewInternal: View {
    @EnvironmentObject var app: App
    @State var diceSides: String
    @State var diceAmount: String
    var body: some View {
        VStack {
            Text("Sides each dice")
            HStack {
                Spacer()
                
                TextField("Number of sides per dice", text: $diceSides).keyboardType(.numberPad)
                    .textFieldStyle(OrangeRoundedBorderStyle())
                    .onChange(of: diceSides) { newValue in
                        let check = Int(newValue) ?? -1

                        if check < 1  && newValue != "" {
                            self.diceSides = "6"
                        }
                    }
                Spacer()
            }
            Text("Number of dices")
            HStack {
                Spacer()
                TextField("Number of dices rolled", text: $diceAmount).keyboardType(.numberPad)
                    .textFieldStyle(OrangeRoundedBorderStyle())
                    .onChange(of: diceAmount) { newValue in
                        let check = Int(newValue) ?? -1

                        if check < 1 && newValue != "" {
                            self.diceAmount = "5"
                        }
                    }
                Spacer()
            }
            Spacer()
        }.onAppear {
            self.diceSides = String(DICES_SIDES)
            self.diceAmount = String(DICES_AMOUNT)
        }
        .onDisappear {
            self.app.setDicesSetttings(dices: self.diceAmount, sides: self.diceSides)
        }
    }
}

struct DiceSettingsView_Previews: PreviewProvider {
    @State static var isActive = true
    
    static var previews: some View {
        DiceSettingsView(isActiveDiceSettings: $isActive).environmentObject(App())
    }
}
