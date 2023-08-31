//
//
// NotificationModel.swift
// SoapBx
//
// Created by Arvind Kanjariya on 31/08/23
//
        

import Foundation

class NotificationModel: Codable {
    var id, user_id, sender_id: Int?
    var title: String?
    var description: String?
    var notification_type: String?
    var read_status: String?
    var created_at: String?
    
    init(id: Int?,user_id: Int?,sender_id: Int?, title: String?, description: String?, notification_type: String?, read_status: String?, created_at: String?) {
        self.id = id
        self.user_id = user_id
        self.sender_id = sender_id
        self.title = title
        self.description = description
        self.notification_type = notification_type
        self.read_status = read_status
        self.created_at = created_at
    }
}
