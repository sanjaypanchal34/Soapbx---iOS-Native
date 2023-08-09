//
//  TradPostModels.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation
import UIKit

struct PostModel: Codable {
    let id, userID: Int?
    var title, description: String?
    let status: Int?
    let createdAt, updatedAt: String?
    var commentsCount, likeCount, dislikeCount, savedsCount: Int?
    var saveStatus, likeStatus, dislikeStatus: Int?
    var images: [PostImage]?
    let user: PostUser?
    var trendTags: [PostTag]?
    var politicianTags: [PostTag]?
    
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
    
    mutating func updateValue(title: String, description: String, images: [PostImage], politician: [PostUser], trend: [TrendsModel]) {
        self.title = title
        self.description = description
        self.images = images
        self.politicianTags = politician.compactMap({ user in
            var politician: PostTag? = nil
            for poli in (self.politicianTags ?? []) {
                if poli.politician?.id == user.id {
                    politician = poli
                    politician?.politician = user
                }
            }
            return politician
        })
        self.trendTags = trend.compactMap({ user in
            var politician: PostTag? = nil
            for poli in (self.trendTags ?? []) {
                if poli.trend?.id == user.id {
                    politician = poli
                    politician?.trend = user
                }
            }
            return politician
        })
    }
}

    // MARK: - Image
struct PostImage: Codable {
    let id, postID: Int?
    let image: String?
    let createdAt, updatedAt: String?
    let imageURL: String?
    var localImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case imageURL = "image_url"
    }
    
    init(image: UIImage) {
        self.id = nil
        self.postID = nil
        self.image = nil
        self.createdAt = nil
        self.updatedAt = nil
        self.imageURL = nil
        self.localImage = image
    }
}

    // MARK: - Tag
struct PostTag: Codable {
    let id, postID, trendID, politicianID: Int?
    let type: Int?
    let createdAt, updatedAt: String?
    var politician: PostUser?
    var trend: TrendsModel?
    
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
    
    init(name: String) {
        
        id = nil
        firstName = ""
        lastName = ""
        self.name = name
        profilePhoto = ""
        coverPhoto = ""
        location = ""
        coverPhotoURL = ""
        coverPhotoThumbURL = ""
        profilePhotoURL = ""
        profilePhotoThumbURL = ""
        followers = 0
        politician = 0
        following = 0
        voters = 0
        statusUser = 0
        statusPoli = 0
        fullName = ""
        endDateSubscription = ""
        subscriptionType = 0
    }
}

//    // MARK: - Trend
//struct PostTrend: Codable {
//    let id, categoryID, subCategoryID: Int?
//    let name, image: String?
//    let active: Int?
//    let createdAt, updatedAt: String?
//    let imageURL: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case categoryID = "category_id"
//        case subCategoryID = "sub_category_id"
//        case name, image, active
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case imageURL = "image_url"
//    }
//}
