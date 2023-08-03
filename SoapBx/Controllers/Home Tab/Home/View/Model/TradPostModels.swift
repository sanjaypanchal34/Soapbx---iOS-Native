//
//  TradPostModels.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

struct PostModel: Codable {
    let id, userID: Int?
    let title, description: String?
    let status: Int?
    let createdAt, updatedAt: String?
    var commentsCount, likeCount, dislikeCount, savedsCount: Int?
    var saveStatus, likeStatus, dislikeStatus: Int?
    let images: [PostImage]?
    let user: PostUser?
    let trendTags: [PostTag]?
    let politicianTags: [PostTag]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case title, description, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case commentsCount = "comments_count"
        case likeCount = "like_count"
        case dislikeCount = "dislike_count"
        case savedsCount = "saveds_count"
        case saveStatus = "save_status"
        case likeStatus = "like_status"
        case dislikeStatus = "dislike_status"
        case images, user
        case trendTags = "trend_tags"
        case politicianTags = "politician_tags"
    }
    
    
}

    // MARK: - Image
struct PostImage: Codable {
    let id, postID: Int?
    let image: String?
    let createdAt, updatedAt: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case imageURL = "image_url"
    }
}

    // MARK: - Tag
struct PostTag: Codable {
    let id, postID, trendID, politicianID: Int?
    let type: Int?
    let createdAt, updatedAt: String?
    let politician: PostUser?
    let trend: PostTrend?
    
    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case trendID = "trend_id"
        case politicianID = "politician_id"
        case type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case politician, trend
    }
}

    // MARK: - User
struct PostUser: Codable {
    let id: Int?
    let firstName, lastName, name: String?
    let profilePhoto: String?
    let coverPhoto: String?
    let location: String?
    let coverPhotoURL: String?
    let coverPhotoThumbURL: String?
    let profilePhotoURL: String?
    let profilePhotoThumbURL: String?
    let followers, politician, following, voters: Int?
    let statusUser, statusPoli: Int?
    let fullName: String?
    let endDateSubscription: String?
    let subscriptionType: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case name
        case profilePhoto = "profile_photo"
        case coverPhoto = "cover_photo"
        case location
        case coverPhotoURL = "cover_photo_url"
        case coverPhotoThumbURL = "cover_photo_thumb_url"
        case profilePhotoURL = "profile_photo_url"
        case profilePhotoThumbURL = "profile_photo_thumb_url"
        case followers, politician, following, voters
        case statusUser = "status_user"
        case statusPoli = "status_poli"
        case fullName = "full_name"
        case endDateSubscription = "end_date_subscription"
        case subscriptionType = "subscription_type"
    }
}

    // MARK: - Trend
struct PostTrend: Codable {
    let id, categoryID, subCategoryID: Int?
    let name, image: String?
    let active: Int?
    let createdAt, updatedAt: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case subCategoryID = "sub_category_id"
        case name, image, active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case imageURL = "image_url"
    }
}
