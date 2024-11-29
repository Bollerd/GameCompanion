//
//  CreditsView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 31.07.23.
//  Copyright © 2023 Dirk Boller. All rights reserved.
//

import SwiftUI

struct CreditsView: View {
    @State var plainColor: Bool
    @EnvironmentObject var app: App
    var body: some View {
        ZStack {
            BackgroundLayoutSheet()
            VStack {
                Text("App Settings").font(.largeTitle)
                HStack {
                    Toggle(isOn: $plainColor) {
                        Text("Plain Background Colors")
                    }.onChange(of: plainColor) { newValue in
                        if newValue {
                            app.appColoring = .plain
                        } else {
                            app.appColoring = .colored
                        }
                    }
                }.padding(.horizontal)
                Text("Dice and Card Icon of App Icon are designed by Freepik").padding()
                
            }.padding()
        }
      
    }
}

struct CreditsView_Previews: PreviewProvider {
    @State static var plainColor = false
    static var previews: some View {
        CreditsView(plainColor: plainColor)
    }
}
