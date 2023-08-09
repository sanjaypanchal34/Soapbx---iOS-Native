//
//  UserNotificationModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 24/07/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

class UserNotificationModel: Codable {
    let connection:Int
    let direct:Int
    let like:Int
    let push:Int
    let tag:Int
    
    enum CodingKeys: String, CodingKey {
        case connection
        case direct
        case like
        case push
        case tag
    }
    
    init(connection: Int = 0, direct: Int = 0, like: Int = 0, push: Int = 0, tag: Int = 0) {
        self.connection = connection
        self.direct = direct
        self.like = like
        self.push = push
        self.tag = tag
    }
}
