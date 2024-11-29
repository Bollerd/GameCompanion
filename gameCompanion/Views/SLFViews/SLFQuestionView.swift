//
//  SLFQuestionView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 06.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//
//  this is the view where the user can enter the answer and with the timer display

import SwiftUI

struct SLFQuestionView: View {
    @Binding var isActiveSLF: Bool
    @EnvironmentObject var app: App
    @ObservedObject var slf: SLFFeatures
    @State var needRefresh: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Text("Current player").font(.subheadline)
                Text("\(self.slf.nextPlayer.name)").font(.largeTitle)
                Text("Character").font(.subheadline)
                Text("\(self.slf.startingCharacter)").font(.largeTitle)
                Text("Question").font(.subheadline)
                Text("\(self.slf.nextQuestion.question)").font(.headline)
            }
            VStack {
                HStack {
                    Spacer().frame(width: 50)
                    TextField("Answer", text: $slf.nextPlayer.slfAnswer, onCommit: {
                        UIApplication.shared.windows.first {$0.isKeyWindow}?.endEditing(true)
                        //    UIApplication.shared.keyWindow?.endEditing(true)
                    }).textFieldStyle(OrangeRoundedBorderStyle())
                    Spacer().frame(width: 50)
                }
                Spacer()
                if ( self.slf.allowedSeconds != 0 ) {
                    ZStack {
                        ProgressBar(slf: slf)
                            //.frame(width: 150.0, height: 150.0)
                            .frame(minWidth: 10.0, idealWidth: 125.0, maxWidth: 150.0, minHeight: 10.0,idealHeight: 125.0,maxHeight: 150.0)
                            .padding(20)
                    }
                    Spacer()
                }
                
                Button(action: {
                    self.slf.getNextPlayer()
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
                    .padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct ProgressBar: View {
    @ObservedObject var slf: SLFFeatures
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.slf.remainingCircle, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            Text("\(self.slf.remainingSeconds)")
                .font(.largeTitle)
                .bold()
        }
    }
}

struct SLFQuestionView_Previews: PreviewProvider {
    @State static var isActive = true
    @State static var slf = SLFFeatures(players: DEFAULT_PLAYERS_OBJECTS,questions: DEFAULT_QUESTIONS_OBJECTS, questionType: .own, rounds: SLF_FIXED_ROUNDS, seconds: SLF_FIXED_SECONDS, possibleCharacters: DEFAULT_SLF_CHARS, processAllActiveQuestions: false)
    
    static var previews: some View {
        SLFQuestionView(isActiveSLF:$isActive, slf: slf).environmentObject(App())
    }
}

