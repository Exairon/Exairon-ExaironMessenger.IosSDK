//
//  Localization.swift
//  ExaironFramework
//
//  Created by Exairon on 3.02.2023.
//

import Foundation

fileprivate class Exairon_en {
    func locale(key: String) -> String {
        switch key {
        case "howWasYourExp": return "How was your experience?"
        case "surveyHint": return "Please tell us about your opinion..."
        case "submit": return "Submit"
        default: return ""
        }
    }
}

fileprivate class Exairon_tr {
    func locale(key: String) -> String {
        switch key {
        case "howWasYourExp": return "Deneyimin Nasıldı?"
        case "surveyHint": return "Lütfen bize görüşlerinizi bildirin..."
        case "submit": return "Gönder"
        default: return ""
        }
    }
}


struct Localization {
    func locale(key: String) -> String {
        if (Exairon.shared.language == "tr") {
            return Exairon_tr().locale(key: key)
        }
        return Exairon_en().locale(key: key)
    }
}
