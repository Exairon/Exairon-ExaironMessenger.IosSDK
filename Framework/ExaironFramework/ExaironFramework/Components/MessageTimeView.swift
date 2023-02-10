//
//  MessageTimeView.swift
//  ExaironFramework
//
//  Created by Exairon on 1.02.2023.
//

import SwiftUI

struct MessageTimeView: View {
    @State var message: Message
    
    var body: some View {
        HStack {
            if message.sender.contains("user_uttered") {
                Spacer()
            }
            Text(dateFormatter(time: message.timeStamp!))
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
                .foregroundColor(Color(hex: "6C6D6F"))
                .font(.system(size: 12))
            if message.sender.contains("bot_uttered") {
                Spacer()
            }
        }
    }
    
    func dateFormatter(time: Int64) -> String{
        let dateFormatterPrintToday = DateFormatter()
        dateFormatterPrintToday.dateFormat = "HH:mm"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/M/yyyy HH:mm"
        
        let messageDate = Date(milliseconds: time)
        if Calendar.current.isDateInToday(messageDate) {
            return dateFormatterPrintToday.string(from: messageDate)
        } else {
            return dateFormatterPrint.string(from: messageDate)
        }
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
