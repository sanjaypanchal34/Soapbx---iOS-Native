//
//  ChatModel.swift
//  SoapBx
//
//  Created by AppSaint Technology on 16/08/23.
//

import Foundation

// MARK: - ChatModel
class ChatModel: Codable {
    var id, chat_relation_id, sender_id, receiver_id: Int?
    var message: String?
    var sName: String?
    var sImage: String?
    var rName: String?
    var rImage: String?
    
    init(id: Int?,chat_relation_id: Int?,sender_id: Int?,receiver_id: Int?, message: String?, sName: String?, sImage: String?, rName: String?, rImage: String?) {
        self.id = id
        self.chat_relation_id = chat_relation_id
        self.sender_id = sender_id
        self.receiver_id = receiver_id
        self.message = message
        self.sName = sName
        self.sImage = sImage
        self.rName = rName
        self.rImage = rImage
    }
}
