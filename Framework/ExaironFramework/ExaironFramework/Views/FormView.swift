//
//  FormView.swift
//  ExaironFramework
//
//  Created by Exairon on 3.02.2023.
//

import SwiftUI

struct FormView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @ObservedObject var formViewModel =  FormViewModel()
    @State var formFields: FormFields
    
    var body: some View {
        VStack {
            HeaderView(chatViewModel: chatViewModel)
                .padding(.bottom, 20)
            Text(Localization.init().locale(key: "formTitle"))
                .font(.system(size: 10))
            if formFields.showNameField {
                FormFieldView(formViewModel: formViewModel, title: "name", placeholder: "namePlaceholder", required: formFields.nameFieldRequired)
            }
            if formFields.showSurnameField {
                FormFieldView(formViewModel: formViewModel, title: "surname", placeholder: "surnamePlaceholder", required: formFields.surnameFieldRequired)
            }
            if formFields.showEmailField {
                FormFieldView(formViewModel: formViewModel, title: "email", placeholder: "emailPlaceholder", required: formFields.emailFieldRequired)
            }
            if formFields.showPhoneField {
                FormFieldView(formViewModel: formViewModel, title: "phone", placeholder: "phonePlaceholder", required: formFields.phoneFieldRequired)
            }
            Text(Localization.init().locale(key: "formDesc"))
                .font(.system(size: 10))
                .padding(10)
            LargeButton(title: AnyView(Text(Localization.init().locale(key: "startSession"))),
                        backgroundColor: Color(hex: (chatViewModel.widgetSettings?.data.color.headerColor)!) ?? Color.black,
                        foregroundColor: Color(hex: (chatViewModel.widgetSettings?.data.color.headerFontColor)!) ?? Color.white) {
                formViewModel.startSession(formFields: formFields)
                        }
            Spacer()
        }
    }
    
    init(chatViewModel: ChatViewModel) {
        self.chatViewModel = chatViewModel
        self.formFields = chatViewModel.widgetSettings?.data.formFields ?? FormFields(emailFieldRequired: false, nameFieldRequired: false, phoneFieldRequired: false, showEmailField: false, showNameField: true, showPhoneField: false, showSurnameField: false, surnameFieldRequired: false)
    }
}
