//
//  BackgroundLayout.swift
//  gameCompanion
//
//  Created by Dirk Boller on 16.08.23.
//  Copyright © 2023 Dirk Boller. All rights reserved.
//

import SwiftUI

struct BackgroundLayout: View {
    @EnvironmentObject var app: App
    var body: some View {
        VStack {
        }._fill().background(BACKGROUD_COLOR)
        VStack {
        }._fill().background(FOREGROUND_COLOR).cornerRadius(20, antialiased: true).padding(.horizontal).padding(.bottom)
    }
}

struct BackgroundLayoutSheet: View {
    var body: some View {
        VStack {
        }._fill().background(BACKGROUD_COLOR)
        VStack {
        }._fill().background(FOREGROUND_COLOR).cornerRadius(20, antialiased: true).padding(.horizontal).padding(.bottom).padding(.top)
    }
}

struct BackgroundLayout_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundLayout()
    }
}
