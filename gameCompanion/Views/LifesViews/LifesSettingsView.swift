//
//  LifesSettingsView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 06.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import SwiftUI

struct LifesSettingsView: View {
    @Binding var isActiveLifesSettings: Bool
    @EnvironmentObject var app: App
    
    var body: some View {
        ZStack {
            BackgroundLayout()
            VStack {
                LifesSettingsViewInternal(lifes: String(LIFES_TOTAL_LIFES)).padding()
            }.onTapGesture {
                self.hideKeyboard()
            }.navigationBarTitle("Lifes")
        }
    }
}

struct LifesSettingsView_Previews: PreviewProvider {
    @State static var isActive = true
    
    static var previews: some View {
        LifesSettingsView(isActiveLifesSettings: $isActive).environmentObject(App())
    }
}

struct LifesSettingsViewInternal: View {
    @EnvironmentObject var app: App
    @State var lifes: String
    var body: some View {
        VStack {
            Text("Number of lifes")
            HStack {
                Spacer()
                TextField("Number of lifes before player dies", text: $lifes).keyboardType(.numberPad)
                    .textFieldStyle(OrangeRoundedBorderStyle())
                    .onChange(of: lifes) { newValue in
                        let check = Int(newValue) ?? -1
                        
                        if check < 1 && newValue != "" {
                            self.lifes = "3"
                        }
                    }
                Spacer()
            }
            Spacer()
        }.onAppear {
            self.lifes = String(LIFES_TOTAL_LIFES)
        }
        .onDisappear {
            self.app.setLifesTotalLifes(lifes: self.lifes)
        }
    }
}

