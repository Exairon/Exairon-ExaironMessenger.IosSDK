//
//  SurveyView.swift
//  ExaironFramework
//
//  Created by Exairon on 3.02.2023.
//

import SwiftUI

struct SurveyView: View {
    @State var message: Message
    @State var widgetSettings: WidgetSettings
    @State var chatViewModel: ChatViewModel
    @State var viewRouter: ViewRouter
    @State var value: Int? = nil
    @State var comment: String = ""
    @State var disabled: Bool = true
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text(Localization.init().locale(key: "howWasYourExp"))
                .foregroundColor(.gray)
                .font(.custom("OpenSans", size: 20))
            HStack {
                Button {
                    value = 1
                    changeButtonDisabled()
                } label: {
                    Text("😠")
                        .opacity(value == 1 ? 1 : 0.5)
                        .font(.system(size: 50))
                }
                Spacer()
                Button {
                    value = 2
                    changeButtonDisabled()
                } label: {
                    Text("🙁")
                        .opacity(value == 2 ? 1 : 0.5)
                        .font(.system(size: 50))
                }
                Spacer()
                Button {
                    value = 3
                    changeButtonDisabled()
                } label: {
                    Text("😐")
                        .opacity(value == 3 ? 1 : 0.5)
                        .font(.system(size: 50))
                }
                Spacer()
                Button {
                    value = 4
                    changeButtonDisabled()
                } label: {
                    Text("😁")
                        .opacity(value == 4 ? 1 : 0.5)
                        .font(.system(size: 50))
                }
                Spacer()
                Button {
                    value = 5
                    changeButtonDisabled()
                } label: {
                    Text("😍")
                        .opacity(value == 5 ? 1 : 0.5)
                        .font(.system(size: 50))
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 30)
            if #available(iOS 16.0, *) {
                TextField(Localization.init().locale(key: "surveyHint"),
                          text: $comment)
                    .padding(.horizontal, 30)
                    .lineLimit(5, reservesSpace: true)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: comment) {
                        print($0)
                        changeButtonDisabled()
                    }
                    .onSubmit {
                        if value != nil {
                            chatViewModel.sendSurvey(value: value!, comment: comment)
                        }
                    }
            } else {
                TextField(Localization.init().locale(key: "surveyHint"),
                          text: $comment, onCommit: {
                    if value != nil {
                        chatViewModel.sendSurvey(value: value!, comment: comment)
                    }
                })
                    .padding(.horizontal, 30)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: comment) {
                        print($0)
                        changeButtonDisabled()
                    }
            }
            
            LargeButton(title: AnyView(Text(Localization.init().locale(key: "submit")).font(.custom("OpenSans", size: 18))),
                        disabled: disabled,
                backgroundColor: Color(hex: widgetSettings.data.color.buttonBackColor) ?? Color.black,
                foregroundColor: Color(hex: widgetSettings.data.color.buttonFontColor) ?? Color.white)  {
                    if value != nil {
                        chatViewModel.sendSurvey(value: value!, comment: comment)
                    }
                }
        }
        .onDisappear {
            chatViewModel.changePage(page: .splashView, viewRouter: viewRouter)
            self.mode.wrappedValue.dismiss()
        }
    }
    
    func changeButtonDisabled() {
        if (comment.count > 0 && value != nil) {
            disabled = false
        } else {
            disabled = true
        }
    }
}
