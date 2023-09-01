//
//
// MessageModel.swift
// SoapBx
//
// Created by Arvind Kanjariya on 01/09/23
//
        

import Foundation

// MARK: - ChatModel
class MessageModel: Codable {
    var uniqueId, chat_relation_id, sender_id, receiver_id: Int?
    var message: String?
    var sName: String?
    var rName: String?
    var rImage: String?
    var created_at: String?
    
    init(uniqueId: Int?,chat_relation_id: Int?,sender_id: Int?,receiver_id: Int?, message: String?, sName: String?, rName: String?, rImage: String?, created_at: String?) {
        self.uniqueId = uniqueId
        self.chat_relation_id = chat_relation_id
        self.sender_id = sender_id
        self.receiver_id = receiver_id
        self.message = message
        self.sName = sName
        self.rName = rName
        self.rImage = rImage
        self.created_at = created_at
    }
}
