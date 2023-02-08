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
    @State var value: Int? = nil
    @State var comment: String = ""
    @State var disabled: Bool = true
    
    var body: some View {
        VStack {
            Text(Localization.init().locale(key: "howWasYourExp"))
                .foregroundColor(.gray)
                .font(.system(size: 20))
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
            TextField(Localization.init().locale(key: "surveyHint"),
                      text: $comment, axis: .vertical)
                .lineLimit(5, reservesSpace: true)
                //.background(.gray.opacity(0.1))
                .padding(.horizontal, 30)
                .textFieldStyle(.roundedBorder)
                .onChange(of: comment) {
                    print($0)
                    changeButtonDisabled()
                }
                .onSubmit {
                    sendSurvey()
                }
            LargeButton(title: AnyView(Text(Localization.init().locale(key: "submit"))),
                        disabled: disabled,
                backgroundColor: Color(hex: widgetSettings.data.color.buttonBackColor) ?? Color.black,
                foregroundColor: Color(hex: widgetSettings.data.color.buttonFontColor) ?? Color.white)  {
                    sendSurvey()
                }
        }
    }
    
    func changeButtonDisabled() {
        if (comment.count > 0 && value != nil) {
            disabled = false
        } else {
            disabled = true
        }
    }
    
    func sendSurvey() {
        if value == nil {
            return
        } else {
            print(value ?? "")
            print(comment)
        }
    }
}
