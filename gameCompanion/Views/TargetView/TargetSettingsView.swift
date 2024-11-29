//
//  TargetSettingsView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 25.07.23.
//  Copyright © 2023 Dirk Boller. All rights reserved.
//

import SwiftUI

struct TargetSettingsView: View {
    @Binding var isActiveTargetSettings: Bool
    @EnvironmentObject var app: App
    
    var body: some View {
        ZStack {
            BackgroundLayout()
            VStack {
                TargetSettingsViewInternal(cols: String(TARGET_COLS), rows: String(TARGET_ROWS),rounds: String(TARGET_ROUNDS), minTime: String(TARGET_MIN_TIME), maxTime: String(TARGET_MAX_TIME))
            }.padding()
            .onTapGesture {
                self.hideKeyboard()
            }.navigationBarTitle("Hit the target")
        }
    }
}

struct TargetSettingsViewInternal: View {
    @EnvironmentObject var app: App
    @State var cols: String
    @State var rows: String
    @State var rounds: String
    @State var minTime: String
    @State var maxTime: String
    var body: some View {
        VStack {
            VStack {
                Text("Number of rows")
                HStack {
                    Spacer()
                    TextField("Number of rows for gameboard", text: $rows).keyboardType(.numberPad)
                        .textFieldStyle(OrangeRoundedBorderStyle())
                        .onChange(of: rows) { newValue in
                            let check = Int(newValue) ?? -1
                            
                            if check < 1  && newValue != "" {
                                self.rows = "6"
                            }
                        }
                    Spacer()
                }
                Text("Number of columns")
                HStack {
                    Spacer()
                    TextField("Number of columns for gameboard", text: $cols).keyboardType(.numberPad)
                        .textFieldStyle(OrangeRoundedBorderStyle())
                        .onChange(of: cols) { newValue in
                            let check = Int(newValue) ?? -1
                            
                            if check < 1 && newValue != "" {
                                self.cols = "5"
                            }
                        }
                    Spacer()
                }
                Text("Number of rounds")
                HStack {
                    Spacer()
                    TextField("Number of rounds to play", text: $rounds).keyboardType(.numberPad)
                        .textFieldStyle(OrangeRoundedBorderStyle())
                        .onChange(of: rounds) { newValue in
                            let check = Int(newValue) ?? -1
                            
                            if check < 1  && newValue != "" {
                                self.rounds = "20"
                            }
                        }
                    Spacer()
                }
            }
            VStack {
                Text("Minimum Time")
                HStack {
                    Spacer()
                    TextField("Min. seconds a target is displayed (eg. 0.5)", text: $minTime).keyboardType(.decimalPad)
                        .textFieldStyle(OrangeRoundedBorderStyle())
                        .onChange(of: minTime) { newValue in
                            /*
                            let check = Double(newValue.replacing(",", with: ".")) ?? -1
                            
                            if check < 0  && newValue != "" {
                                self.minTime = "0.5"
                            }
                             */
                        }
                    Spacer()
                }
                Text("Maximum Time")
                HStack {
                    Spacer()
                    TextField("Max. seconds a target is displayed (eg. 2.5)", text: $maxTime).keyboardType(.decimalPad)
                        .textFieldStyle(OrangeRoundedBorderStyle())
                        .onChange(of: maxTime) { newValue in
                            /*
                            let check = Double(newValue.replacing(",", with: ".")) ?? -1
                            
                            if check < 1  && newValue != "" {
                                self.maxTime = "0.5"
                            }
                             */
                        }
                    Spacer()
                }
            }
            
            Spacer()
        }.onAppear {
            self.rows = String(TARGET_ROWS)
            self.cols = String(TARGET_COLS)
            self.rounds = String(TARGET_ROUNDS)
            self.minTime = String(TARGET_MIN_TIME)
            self.maxTime = String(TARGET_MAX_TIME)
        }
        .onDisappear {
            let checkMin = Double(minTime.replacing(",", with: ".")) ?? -1
            
            if checkMin < 0  && minTime != "" {
                self.minTime = "0.5"
            }
            
            let checkMax = Double(maxTime.replacing(",", with: ".")) ?? -1
            
            if checkMax < 0  && maxTime != "" {
                self.maxTime = "0.5"
            }
            
            self.app.setTargetSetttings(rows: self.rows, cols: self.cols, rounds: self.rounds, minTime: self.minTime, maxTime: self.maxTime)
        }
    }
}

struct TargetSettingsView_Previews: PreviewProvider {
    @State static var isActive = true
    
    static var previews: some View {
        TargetSettingsView(isActiveTargetSettings: $isActive).environmentObject(App())
    }
}
