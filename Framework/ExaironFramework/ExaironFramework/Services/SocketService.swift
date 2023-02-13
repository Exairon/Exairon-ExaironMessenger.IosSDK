//
//  SocketService.swift
//  ExaironFramework
//
//  Created by Exairon on 8.02.2023.
//

import Foundation
import SocketIO

class SocketService {
    let manager = SocketManager(socketURL: URL(string: "https://test.services.exairon.com")!, config: [.log(false), .path("/socket")])
    func connect(completion: @escaping (_ success: Bool) -> Void) {
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) {data, ack in
            completion(true)
        }
        socket.connect()
    }
    
    func socketEmit(eventName: String, object: SocketData) {
        let socket = manager.defaultSocket
        socket.emit(eventName, object)
    }
    
    func getSocket() -> SocketIOClient {
        return manager.defaultSocket
    }
}
