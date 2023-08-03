//
//  CommentModels.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

struct CommentModel: Codable {
    let id, postID, userID: Int?
    let comment, createdAt, updatedAt: String?
    let user: PostUser?
    
    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case userID = "user_id"
        case comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
    }
    
    init(id: Int?, postID: Int?, userID: Int?, comment: String?, createdAt: String?, updatedAt: String?, user: PostUser?) {
        self.id = id
        self.postID = postID
        self.userID = userID
        self.comment = comment
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.user = user
    }
}
