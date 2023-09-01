//
//
// PaymentModel.swift
// SoapBx
//
// Created by Arvind Kanjariya on 01/09/23
//
        

import Foundation

// MARK: - ChatModel
class PaymentModel: Codable {
    var order_id: String?
    var amount: Double?
    var duration: String?
    var created_at: String?
    
    init(order_id: String?, duration: String?, created_at: String?, amount: Double?) {
        self.order_id = order_id
        self.duration = duration
        self.created_at = created_at
        self.amount = amount
    }
}
