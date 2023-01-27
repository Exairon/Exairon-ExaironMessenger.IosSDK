//
//  ChatViewModel.swift
//  ExaironFramework
//
//  Created by Exairon on 27.01.2023.
//

import Foundation

class ChatViewModel: ObservableObject {
    let apiService = ApiService()
    
    func getWidgetSettings(completion: @escaping(_ widgetSettings: WidgetSettings) -> Void) {
        apiService.getWidgetSettingsApiCall() { result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    completion(data)
            }
        }
    }
}
