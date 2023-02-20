//
//  FormFieldView.swift
//  ExaironFramework
//
//  Created by Exairon on 3.02.2023.
//

import SwiftUI

struct FormFieldView: View {
    @ObservedObject var formViewModel: FormViewModel
    @State var title: String
    @State var placeholder: String
    @State var required: Bool
        
    var body: some View {
        VStack {
            HStack {
                Text(Localization.init().locale(key: title) + (required ? " *" : ""))
                    .font(.custom("OpenSans", size: 18))
                Spacer()
            }
            .padding(.top, 10)
            TextField(Localization.init().locale(key: placeholder),
                      text: title == "name" ? $formViewModel.customer.name : title == "surname" ? $formViewModel.customer.surname : title == "email" ? $formViewModel.customer.email : $formViewModel.customer.phone)
            .padding()
            .background(Color(hex: "#1E1E1E20"))
            .border(formViewModel.invalidFormFields.contains(title) ? Color.red : .gray.opacity(0.1))
            .cornerRadius(10)
            .onChange(of: title == "name" ? formViewModel.customer.name : title == "surname" ? formViewModel.customer.surname : title == "email" ? formViewModel.customer.email : formViewModel.customer.phone) {
                formViewModel.invalidFormFields = formViewModel.invalidFormFields.filter(){$0 != title}
                print($0)
            }
        }
        .padding(.horizontal, 30)
    }
}
