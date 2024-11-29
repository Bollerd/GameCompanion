//
//  NewSLFQuestionView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 27.08.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//
//  this is the view to maintain new questions
//  contains just field for new question

import SwiftUI

struct NewSLFQuestionView: View {
    @Binding var isActiveNewSLFQuestion: Bool
    @EnvironmentObject var app: App
    
    var body: some View {
        ZStack {
            BackgroundLayout()
            VStack {
                Text("Question:")
                HStack {
                    Spacer()
                    TextField("Enter question", text: $app.newSLFQuestion).textFieldStyle(OrangeRoundedBorderStyle())
                    Spacer()
                    
                }
                Spacer()
            }.padding().navigationBarTitle("New question")
                .onDisappear{
                    debug_print("disappear new slf question")
                    if self.app.newSLFQuestion != "" {
                        self.app.slfQuestions.append(SLFQuestion(question:self.app.newSLFQuestion))
                    }
                    self.app.newSLFQuestion = ""
                }
        }
    }
}

struct NewSLFQuestionView_Previews: PreviewProvider {
    @State static var isActive = true
    
    static var previews: some View {
        NewSLFQuestionView(isActiveNewSLFQuestion: $isActive).environmentObject(App())
    }
}
