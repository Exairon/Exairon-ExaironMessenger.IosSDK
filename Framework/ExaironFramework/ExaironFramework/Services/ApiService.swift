//
//  ApiService.swift
//  ExaironFramework
//
//  Created by Exairon on 27.01.2023.
//

import Foundation

class ApiService{
    let preferences = UserDefaults.standard

    func getWidgetSettingsApiCall(completion: @escaping (Result<WidgetSettings, ApiErrors>)->Void) {
        guard let url = URL(string: "\(Exairon.shared.src)/api/v1/channels/widgetSettings/\(Exairon.shared.channelId)") else{
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else { return completion(.failure(.NotFound)) }
            guard let widgetSettings = try? JSONDecoder().decode(WidgetSettings.self, from: data) else { return completion(.failure(.DataNotProcessing)) }
            completion(.success(widgetSettings))
        }.resume()
    }
    
    func getNewMessagesApiCall(timestamp: String, conversationId: String, completion: @escaping (Result<MissingMessageResponse, ApiErrors>)->Void) {
        guard let url = URL(string: "\(Exairon.shared.src)/api/v1/messages/getNewMessages/\(timestamp)/\(conversationId)") else{
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else { return completion(.failure(.NotFound)) }
            guard let missingMessageRes = try? JSONDecoder().decode(MissingMessageResponse.self, from: data) else { return completion(.failure(.DataNotProcessing)) }
            completion(.success(missingMessageRes))
        }.resume()
    }
}

enum ApiErrors: Error{
    case UrlError
    case NotFound
    case DataNotProcessing
}
