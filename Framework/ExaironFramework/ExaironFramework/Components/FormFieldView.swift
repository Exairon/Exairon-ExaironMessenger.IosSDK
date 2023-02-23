//
//  FormFieldView.swift
//  ExaironFramework
//
//  Created by Exairon on 3.02.2023.
//

import SwiftUI

struct FormFieldView: View {
    @ObservedObject var formViewModel: FormViewModel
    @State var chatViewModel: ChatViewModel
    @State var title: String
    @State var placeholder: String
    @State var required: Bool
        
    var body: some View {
        let binding = Binding<String>(get: {
            self.title == "name" ? self.formViewModel.customer.name : self.title == "surname" ? self.formViewModel.customer.surname : self.title == "email" ? self.formViewModel.customer.email : self.formViewModel.customer.phone
       }, set: {
           formViewModel.invalidFormFields = formViewModel.invalidFormFields.filter(){$0 != title}
           switch title {
           case "name":
               self.formViewModel.customer.name = $0
           case "surname":
               self.formViewModel.customer.surname = $0
           case "email":
               self.formViewModel.customer.email = $0
           case "phone":
               self.formViewModel.customer.phone = $0
           default: break
           }

       })
        VStack {
            HStack {
                Text(Localization.init().locale(key: title) + (required ? " *" : ""))
                    .font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 18))
                Spacer()
            }
            .padding(.top, 10)
            TextField(Localization.init().locale(key: placeholder), text: binding)
            .padding()
            .background(Color(hex: "#1E1E1E20"))
            .border(formViewModel.invalidFormFields.contains(title) ? Color.red : .gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding(.horizontal, 30)
    }
}
