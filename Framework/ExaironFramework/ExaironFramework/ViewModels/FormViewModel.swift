//
//  FormViewModel.swift
//  ExaironFramework
//
//  Created by Exairon on 4.02.2023.
//

import Foundation

class FormViewModel: ObservableObject {
    @Published var invalidFormFields: [String] = []
    @Published var customer: CustomerForm = CustomerForm(name: Exairon.shared.name ?? "", surname: Exairon.shared.surname ?? "", email: Exairon.shared.email ?? "", phone: Exairon.shared.phone ?? "")
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func startSession(formFields: FormFields) {
        invalidFormFields = []
        if formFields.nameFieldRequired && customer.name == "" {
            invalidFormFields.append("name")
        }
        if formFields.surnameFieldRequired && customer.surname == "" {
            invalidFormFields.append("surname")
        }
        if (formFields.emailFieldRequired && customer.email == "") || (customer.email.count > 0 && !isValidEmail(customer.email)) {
            invalidFormFields.append("email")
        }
        if formFields.phoneFieldRequired && customer.phone == "" {
            invalidFormFields.append("phone")
        }
        if invalidFormFields.count > 0 {
            print("invalid")
        } else {
            print("valid")
        }
    }
}

