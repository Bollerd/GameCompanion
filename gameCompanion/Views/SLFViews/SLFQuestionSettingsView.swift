//
//  SLFQuestionsView.swift
//  gameCompanion
//
//  Created by Dirk Boller on 27.08.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//
//  this is the view with the maintained possible questions
//  and the settings like timer and number of questions

import SwiftUI
import MobileCoreServices

struct SLFQuestionsView: View {
    @Binding var isActiveSLFQuestions: Bool
    @EnvironmentObject var app: App
    
    var body: some View {
        ZStack {
            BackgroundLayout()
            VStack {
                SLFQuestionsSettingsView()
                SLFQuestionList()
            }.padding()
        }
        
        
    }
}

struct SLFQuestionsView_Previews: PreviewProvider {
    @State static var isActive = true
    
    static var previews: some View {
        SLFQuestionsView(isActiveSLFQuestions: $isActive).environmentObject(App())
    }
}

struct SLFQuestionsSettingsView: View {
    @EnvironmentObject var app: App
  //  @State var rounds: String
    var body: some View {
        VStack {
            Text("Number of questions")
            HStack {
                Spacer()
                TextField("Number of questions played", text: $app.SLF_TOTAL_ROUNDS_TXT).keyboardType(.numberPad)
                    .textFieldStyle(OrangeRoundedBorderStyle())
                    .onChange(of: app.SLF_TOTAL_ROUNDS_TXT
                    ) { newValue in
                        let check = Int(newValue) ?? -1
                        
                        if check < 1 && newValue != "" {
                            app.SLF_TOTAL_ROUNDS_TXT = "\(SLF_FIXED_ROUNDS)"
                        }
                    }
                Toggle(isOn: $app.SLF_PLAY_ALL_QUESTIONS) {
                    Text("All questions")
                }
                Spacer()
            }
            Text("Seconds to enter answer (0 = unlimited)")
            HStack {
                Spacer()
                TextField("Number of seconds to enter an answer", text: $app.SLF_MAX_SECONDS_TXT).keyboardType(.numberPad)
                    .textFieldStyle(OrangeRoundedBorderStyle())
                    .onChange(of: app.SLF_MAX_SECONDS_TXT
                    ) { newValue in
                        let check = Int(newValue) ?? -1
                        
                        if check < 0 && newValue != "" {
                            app.SLF_MAX_SECONDS_TXT = "\(SLF_FIXED_SECONDS)"
                        }
                    }
                Spacer()
            }
            Text("Possible starting characters for questions")
            HStack {
                Spacer()
                TextField("Chars allowed as starting char", text: $app.possibleStartCharacters)  .textFieldStyle(OrangeRoundedBorderStyle())
                    .onChange(of: app.possibleStartCharacters
                    ) { newValue in
						
						if newValue == "" {
							DEFAULT_SLF_CHARS = "a"
						} else {
							DEFAULT_SLF_CHARS = newValue
						}
                    }
                Spacer()
            }
        }
        /*
        .onAppear {
            self.rounds = String(SLF_TOTAL_ROUNDS)
        }
         */
        .onDisappear {
            self.app.setRoundsSLF(rounds:  app.SLF_TOTAL_ROUNDS_TXT )
            self.app.setSecondsSLF(seconds: app.SLF_MAX_SECONDS_TXT)
            self.app.setPlayAllQuestionsSLF(playAllQuestions: app.SLF_PLAY_ALL_QUESTIONS)
        }
        
    }
}

struct SLFQuestionList: View {
    @State var isActiveSLFQuestionEdit = false
    @EnvironmentObject var app: App
    @State private var editMode = EditMode.inactive
    
    @State var isActiveNewSFLQuestion = false
    @State private var deletedLastQuestion: SLFQuestion?
    
    var body: some View {
        VStack {
            Text("Possible Questions").font(.title2)
            List {
                ForEach($app.slfQuestions) { $question in
                  //  Text(question.question)
                    Toggle(isOn: $question.enabled,
                        label: { Text(question.question)
                    }).listRowBackground(Color.clear)
                }
                .onDelete(perform: onDelete)
                .onMove(perform: onMove)
            }.listStyle(.plain)
        }.padding(.bottom).onAppear{
            editMode = EditMode.active
            editMode = EditMode.inactive
        }
        .onDisappear{
            if ( self.app.noOfSLFQuestions == 0 ) {
                self.app.slfQuestions.append(DEFAULT_QUESTIONS_OBJECTS[0])
            }
            
            self.app.saveSLFQuestionDefaults()
        }
            
        .navigationBarTitle("Questions")
        .navigationBarItems(trailing: trailingButtons)
        .environment(\.editMode, $editMode)
        .alert(item: $deletedLastQuestion) { show in
            Alert(title: Text(show.question), message: Text("Last question can't be deleted! Add new one first."), dismissButton: .cancel())
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
                
                NavigationLink(destination: NewSLFQuestionView(isActiveNewSLFQuestion: $isActiveNewSFLQuestion).environmentObject(app),
                       isActive: $isActiveNewSFLQuestion,
                       label: {
                        Button(action: {
                            self.isActiveNewSFLQuestion = true
                        }, label: {
                            HStack {
                                Image(systemName: "doc.badge.plus")
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
        if app.slfQuestions.count == 1 {
            self.deletedLastQuestion = app.slfQuestions[offsets[offsets.startIndex]]
        } else {
            app.slfQuestions.remove(atOffsets: offsets)
        }
    }
    
    // drag / drop moving
    func onMove(source: IndexSet, destination: Int) {
        app.slfQuestions.move(fromOffsets: source, toOffset: destination)
    }
}
