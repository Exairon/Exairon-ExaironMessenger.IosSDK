//
//  FormView.swift
//  ExaironFramework
//
//  Created by Exairon on 3.02.2023.
//

import SwiftUI

struct FormView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @StateObject var viewRouter: ViewRouter
    @ObservedObject var formViewModel =  FormViewModel()
    //@State var formFields: FormFields
    
    var body: some View {
        VStack {
            HeaderView(chatViewModel: chatViewModel, viewRouter: viewRouter)
                .padding(.bottom, 20)
            Text(Localization.init().locale(key: "formTitle"))
                .font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 10))
            if getFormFields().showNameField {
                FormFieldView(formViewModel: formViewModel, chatViewModel: chatViewModel, title: "name", placeholder: "namePlaceholder", required: getFormFields().nameFieldRequired)
            }
            if getFormFields().showSurnameField {
                FormFieldView(formViewModel: formViewModel, chatViewModel: chatViewModel ,title: "surname", placeholder: "surnamePlaceholder", required: getFormFields().surnameFieldRequired)
            }
            if getFormFields().showEmailField {
                FormFieldView(formViewModel: formViewModel, chatViewModel: chatViewModel ,title: "email", placeholder: "emailPlaceholder", required: getFormFields().emailFieldRequired)
            }
            if getFormFields().showPhoneField {
                FormFieldView(formViewModel: formViewModel, chatViewModel: chatViewModel, title: "phone", placeholder: "phonePlaceholder", required: getFormFields().phoneFieldRequired)
            }
            Text(Localization.init().locale(key: "formDesc"))
                .font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 10))
                .padding(10)
            LargeButton(title: AnyView(Text(Localization.init().locale(key: "startSession")).font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 18))),
                        backgroundColor: Color(hex: (chatViewModel.widgetSettings?.data.color.headerColor)!) ?? Color.black,
                        foregroundColor: Color(hex: (chatViewModel.widgetSettings?.data.color.headerFontColor)!) ?? Color.white) {
                let isValid = formViewModel.isValid(formFields: getFormFields())
                if (isValid) {
                    startSession()
                }
            }
            Spacer()
        }
    }
    
    func startSession() {
        let userToken: String = chatViewModel.readStringStorage(key: "userToken") ?? UUID().uuidString
        chatViewModel.writeStringStorage(value: userToken, key: "userToken")
        User.shared.name = Exairon.shared.name
        User.shared.surname = Exairon.shared.surname
        User.shared.email = Exairon.shared.email
        User.shared.phone = Exairon.shared.phone
        chatViewModel.changePage(page: .chatView, viewRouter: viewRouter)
    }
    
    func getFormFields() -> FormFields {
        return chatViewModel.widgetSettings?.data.formFields ?? FormFields(emailFieldRequired: false, nameFieldRequired: false, phoneFieldRequired: false, showEmailField: false, showNameField: true, showPhoneField: false, showSurnameField: false, surnameFieldRequired: false)
    }

}
