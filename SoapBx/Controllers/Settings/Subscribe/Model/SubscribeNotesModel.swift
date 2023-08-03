//
//  SubscribeNotesModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

struct SubscribeNotesModel {
    let title: String
    let freemium: String
    let premium: String
    let canSymbol: Bool
    let isFreemiumSelected: Bool = true
    
    init(title: String, freemium: String, premium: String, canSymbol: Bool = true) {
        self.title = title
        self.freemium = freemium
        self.premium = premium
        self.canSymbol = canSymbol
    }
    
}

struct SubscribeModel: Codable {
    let id: Int?
    let name: String?
    let plan_id: String?
    let description: String?
    let type: Int?
    let price: Double?
    let duration: String?
    let active: Int?
    let created_at: String?
    let updated_at: String?
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, name, plan_id, description, type, price, duration, active, created_at, updated_at
    }
    
}

//{
//    "id": 1,
//    "name": "Free",
//    "plan_id": null,
//    "description": "This is free one",
//    "type": 2,
//    "price": 0,
//    "duration": null,
//    "active": 1,
//    "created_at": "2023-07-25T06:47:29.000000Z",
//    "updated_at": "2023-07-25T06:47:29.000000Z"
//}
