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
    let id, step, roleID: Int?
    let uuid, customerID: String?
    let subscriptionID: Int?
    let firstName, lastName, name: String?
    let profilePhoto, profilePhotoThumb, coverPhoto, coverPhotoThumb: String?
    let email: String?
    let emailVerifiedAt: String?
    let countryCode, phoneNumber, location: String?
    var latitude, longitude: DoubleCast?
    let electedIn, party: String?
    let phoneVerifiedAt: String?
    let otp: String?
    let verified, active, onlineStatus: Int?
    let deviceToken, deviceType, authToken, createdAt: String?
    let updatedAt: String?
    let notificationStatus: Int?
    let referralCode: String?
    let referralCodeUsed: String?
    let poliID, apiURI, middleName, title: String?
    let dateOfBirth, gender, url, rssURL: String?
    let contactForm, totalVotes, missedVotes, totalPresent: String?
    let office, phone, state, missedVotesPct: String?
    let votesWithPartyPct, votesAgainstPartyPct, twitterAccount, facebookAccount: String?
    let youtubeAccount: String?
    let verifiedBy: Int?
    let suffix, leadershipRole, inOffice, seniority: String?
    let senateClass, stateRank, subscriptionStatus, subscribedFrom: String?
    let coverPhotoURL, coverPhotoThumbURL, profilePhotoURL, profilePhotoThumbURL: String?
    var followers, politician, following, voters: Int?
    var statusUser, statusPoli: Int?
    let fullName: String?
    let endDateSubscription: String?
    let subscriptionType: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, step
        case roleID = "role_id"
        case uuid
        case customerID = "customer_id"
        case subscriptionID = "subscription_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case name
        case profilePhoto = "profile_photo"
        case profilePhotoThumb = "profile_photo_thumb"
        case coverPhoto = "cover_photo"
        case coverPhotoThumb = "cover_photo_thumb"
        case email
        case emailVerifiedAt = "email_verified_at"
        case countryCode = "country_code"
        case phoneNumber = "phone_number"
        case location, longitude, latitude
        case electedIn = "elected_in"
        case party
        case phoneVerifiedAt = "phone_verified_at"
        case otp, verified, active
        case onlineStatus = "online_status"
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case authToken = "auth_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case notificationStatus = "notification_status"
        case referralCode = "referral_code"
        case referralCodeUsed = "referral_code_used"
        case poliID = "poli_id"
        case apiURI = "api_uri"
        case middleName = "middle_name"
        case title
        case dateOfBirth = "date_of_birth"
        case gender, url
        case rssURL = "rss_url"
        case contactForm = "contact_form"
        case totalVotes = "total_votes"
        case missedVotes = "missed_votes"
        case totalPresent = "total_present"
        case office, phone, state
        case missedVotesPct = "missed_votes_pct"
        case votesWithPartyPct = "votes_with_party_pct"
        case votesAgainstPartyPct = "votes_against_party_pct"
        case twitterAccount = "twitter_account"
        case facebookAccount = "facebook_account"
        case youtubeAccount = "youtube_account"
        case verifiedBy = "verified_by"
        case suffix
        case leadershipRole = "leadership_role"
        case inOffice = "in_office"
        case seniority
        case senateClass = "senate_class"
        case stateRank = "state_rank"
        case subscriptionStatus = "subscription_status"
        case subscribedFrom = "subscribed_from"
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
    
    static func object(name: String)->PostUser? {
        let json = ["name": name]
        do {
            let data = try JSONSerialization.data(withJSONObject: json)
            return try JSONDecoder().decode(PostUser.self, from: data)
            
        } catch{
            print("[TradPostListViewModel] getHomePost response posts try Catch : \(error)")
            return nil
        }
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

enum DoubleCast: Codable {
    
    case string(String)
    
    var stringValue: String? {
        switch self {
            case .string(let s):
                return s
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Double.self) {
            self = .string("\(x)")
            return
        }
        if let x = try? container.decode(Int.self) {
            self = .string("\(x)")
            return
        }
        throw DecodingError.typeMismatch(DoubleCast.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MyValue"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .string(let x):
                try container.encode(x)
        }
    }
}
