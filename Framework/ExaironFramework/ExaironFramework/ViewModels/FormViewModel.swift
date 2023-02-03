//
//  FormViewModel.swift
//  ExaironFramework
//
//  Created by Exairon on 4.02.2023.
//

import Foundation

class FormViewModel: ObservableObject {
    @Published var invalidFormFields: [String] = []
    @Published var customer: CustomerForm = CustomerForm()
    
    func startSession(formFields: FormFields) {
        invalidFormFields = []
        if formFields.nameFieldRequired && customer.name == "" {
            invalidFormFields.append("name")
        }
        if formFields.surnameFieldRequired && customer.surname == "" {
            invalidFormFields.append("surname")
        }
        if formFields.emailFieldRequired && customer.email == "" {
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

