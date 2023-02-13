//
//  SurveyResultModel.swift
//  ExaironFramework
//
//  Created by Exairon on 13.02.2023.
//

import Foundation
import SocketIO

struct SurveyRequest: SocketData {
    let channelId: String
    let session_id: String
    let surveyResult: Dictionary<String, Any>
    func socketRepresentation() -> SocketData {
        return ["channelId": channelId, "session_id": session_id, "surveyResult": surveyResult]
    }
}
