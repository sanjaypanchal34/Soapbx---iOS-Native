//
//  PollsModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 15/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

struct PollModel: Codable {
    let id, userID: Int?
    let name, question: String?
    let active: Int?
    let createdAt, updatedAt, endDate, startDate: String?
    let approved, readStatus, votesCount: Int?
    var pollPercent: [String: DoubleCast]?
    let selectStatus: Int?
    let user: PostUser?
    var options: [Option]?
    var tag: [Tag]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name, question, active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case endDate = "end_date"
        case startDate = "start_date"
        case approved
        case readStatus = "read_status"
        case votesCount = "votes_count"
        case pollPercent = "poll_percent"
        case selectStatus = "select_status"
        case user, options, tag
    }
}

    // MARK: - Option
struct Option: Codable {
    let id, pollID: Int?
    let option, createdAt, updatedAt: String?
    var selectStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case pollID = "poll_id"
        case option
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case selectStatus = "select_status"
    }
}

    // MARK: - Tag
struct Tag: Codable {
    let id, userID, pollID, trendID: Int?
    let createdAt, updatedAt: String?
    var trend: TrendsModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case pollID = "poll_id"
        case trendID = "trend_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case trend
    }
}
