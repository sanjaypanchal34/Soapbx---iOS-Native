    //
    //  Webservice.swift
    //  Operators Techno Lab, Ahmedabad
    //
    //  Developed by Harsh Kadiya
    //  Created by OTL-HK on 26/02/2019.
    //  Copyright © 2023 OTL-HK. All rights reserved.
    //

import Foundation
import Alamofire
import UIKit

public protocol OTLRequestExecuter
{
    var apiName: String { get }
    var method: OTLHTTPMethod { get }
    
    func requestWith(parameter: OTLJson,
                     queryPara: OTLStringJson,
                     header: OTLStringJson,
                     completion: @escaping OTLAPIResultBlock)
    func requestWith(multipart items: [OTLMultipartFormData],
                     parameter: OTLJson,
                     queryPara: OTLStringJson,
                     header: OTLStringJson,
                     progress:OTLAPIProgressBlock?,
                     completion: @escaping OTLAPIResultBlock)
}

public extension OTLRequestExecuter
{
        /// request with defult parameters application_type, user_id, login_access_token
    func requestWith(parameter: OTLJson,
                     queryPara: OTLStringJson = [:],
                     header: OTLStringJson = [:],
                     completion: @escaping OTLAPIResultBlock)
    {
        var strUrl = OTLWebserviceConfiguration.instance.baseURL + self.apiName
        if let nsurl = NSURL(string: strUrl),
           UIApplication.shared.canOpenURL(nsurl as URL){
            
            if queryPara.count > 0 {
                var urlComponents = URLComponents(url: nsurl as URL, resolvingAgainstBaseURL: false)
                let qPara = queryPara.compactMap({ object in
                    return URLQueryItem(name: object.key, value: object.value)
                })
                urlComponents?.queryItems = qPara
                strUrl = urlComponents?.url?.absoluteString ?? strUrl
            }
            
            let request = OTLAPIRequest(path: strUrl,
                                        method: self.method,
                                        parameter: parameter,
                                        header: header,
                                        completion: completion)
            request.execute()
        } else {
            completion(.fail("Invalied URL", 12,nil))
        }
    }
    
        /// request with multipart data with defult parameters application_type, user_id, login_access_token
    func requestWith(multipart items: [OTLMultipartFormData],
                     parameter: OTLJson,
                     queryPara: OTLStringJson = [:],
                     header: OTLStringJson = [:],
                     progress:OTLAPIProgressBlock? = nil,
                     completion: @escaping OTLAPIResultBlock)
    {
        var strUrl = OTLWebserviceConfiguration.instance.baseURL + self.apiName
        if let nsurl = NSURL(string: strUrl),
           UIApplication.shared.canOpenURL(nsurl as URL){
            if queryPara.count > 0 {
                var urlComponents = URLComponents(url: nsurl as URL, resolvingAgainstBaseURL: false)
                let qPara = queryPara.compactMap({ object in
                    return URLQueryItem(name: object.key, value: object.value)
                })
                urlComponents?.queryItems = qPara
                strUrl = urlComponents?.url?.absoluteString ?? strUrl
            }
            
            var request = OTLAPIRequest(path: strUrl,
                                        method: self.method,
                                        parameter: parameter,
                                        header: header,
                                        progress: progress,
                                        completion: completion)
            request.multipartItems = items
            request.executeMultiPart()
        } else {
            completion(.fail("Invalied URL", 12,nil))
        }
    }
}

enum Webservice
{
    enum Auth: OTLRequestExecuter {
        case register, login, forgotPassword, logout, verifySignup, completeProfile, verifyOtp, resetPassword
        
        var method: OTLHTTPMethod {
            return .post
        }
        
        var apiName: String {
            switch self {
                case .login:                return "login"
                case .forgotPassword:       return "forgotPassword"
                case .register:             return "signup"
                case .logout:               return "logout"
                case .verifySignup:         return "verifySignup"
                case .completeProfile:      return "completeProfile"
                case .verifyOtp:            return "verifyOtp"
                case .resetPassword:        return "resetPassword"
            }
        }
    }
    
    enum Settings: OTLRequestExecuter {
        case getTrends, chooseTrends, getSubscriptionPlans, chooseSubscription, saveHistory(String), getSavedPosts, getUserTrends, feedback, addPoll, getPolls, voteOnPoll, getBockedUser, unfollowedAccounts, unblockUser(String), acceptRequest, deleteRequest(String)
        
        var method: OTLHTTPMethod {
            switch self {
                case .getTrends:            return .get
                case .getSubscriptionPlans: return .get
                case .saveHistory:          return .get
                case .getSavedPosts:        return .get
                case .getUserTrends:        return .get
                case .getPolls:             return .get
                case .getBockedUser:        return .get
                case .unfollowedAccounts:   return .get
                case .unblockUser:          return .get
                case .deleteRequest:        return .get
                default: return .post
            }
        }
        
        var apiName: String {
            switch self {
                case .getTrends:            return "getTrends"
                case .chooseTrends:         return "chooseTrends"
                case .getSubscriptionPlans: return "getSubscriptionPlans"
                case .chooseSubscription:   return "chooseSubscription"
                case .saveHistory(let id):  return "saveHistory/\(id)"
                case .getSavedPosts:        return "getSavedPosts"
                case .getUserTrends:        return "getUserTrends"
                case .feedback:             return "feedback"
                case .addPoll:              return "addPoll"
                case .voteOnPoll:           return "voteOnPoll"
                case .getPolls:             return "getPolls"
                case .getBockedUser:        return "getBockedUser"
                case .unfollowedAccounts:   return "unfollowedAccounts"
                case .unblockUser(let id):  return "unblockUser/\(id)"
                case .acceptRequest:        return "acceptRequest"
                case .deleteRequest(let id):    return "deleteRequest/\(id)"
            }
        }
    }
    
    enum Home: OTLRequestExecuter {
        case getHomePost, getPost(String), commentOnPost, reportPostComment, likeDislikePost, deletePost(String), saveUnsavePost, blockReportUser, listing, userSearchHistory(String), clearHistory, saveHistory(String), userSearch
       
        var method: OTLHTTPMethod {
            switch self {
                case .getHomePost:          return .get
                case .getPost:              return .get
                case .userSearchHistory:    return .get
                case .clearHistory:         return .get
                case .saveHistory:          return .get
                case .userSearch:           return .get
                default: return .post
            }
        }
        
        var apiName: String {
            switch self {
                case .getHomePost:                  return "homeScreen"
                case .getPost(let id):              return "getPost/\(id)"
                case .commentOnPost:                return "commentOnPost"
                case .reportPostComment:            return "reportPostComment"
                case .likeDislikePost:              return "likeDislikePost"
                case .deletePost(let id):           return "deletePost/\(id)"
                case .saveUnsavePost:               return "saveUnsavePost"
                case .blockReportUser:              return "blockReportUser"
                case .listing:                      return "listing"
                case .userSearchHistory(let id):    return "userSearchHistory/\(id)"
                case .clearHistory:                 return "clearHistory"
                case .saveHistory(let id):          return "saveHistory/\(id)"
                case .userSearch:                   return "userSearch"
            }
        }
    }
    
    enum Post: OTLRequestExecuter {
        case addPost, deleteImage(String), deletePost(String), editPost, getFollowingOfUser(String), getFollowersOfUser(String), getPoliticiansOfUser(String)
        
        var method: OTLHTTPMethod {
            switch self {
                case .getFollowingOfUser:       return .get
                case .getFollowersOfUser:       return .get
                case .getPoliticiansOfUser:     return .get
                default: return .post
            }
        }
        
        var apiName: String {
            switch self {
                case .addPost:                      return "addPost"
                case .deleteImage(let id):          return "deleteImage/\(id)"
                case .deletePost(let id):           return "deletePost/\(id)"
                case .editPost:                     return "editPost"
                case .getFollowingOfUser(let id):   return "getFollowingOfUser/\(id)"
                case .getFollowersOfUser(let id):   return "getFollowersOfUser/\(id)"
                case .getPoliticiansOfUser(let id): return "getPoliticiansOfUser/\(id)"

            }
        }
    }
    
    enum Chat: OTLRequestExecuter {
        case startChat, userChat(String), sendMessage
        
        var method: OTLHTTPMethod {
            switch self {
                case .startChat:       return .get
                case .userChat:       return .get
                case .sendMessage:     return .get
                default: return .post
            }
        }
        
        var apiName: String {
            switch self {
                case .startChat:                      return "startChat"
                case .userChat(let id):          return "userChat/\(id)"
                case .sendMessage:           return "sendMessage"
            }
        }
    }
    
    enum Profile: OTLRequestExecuter {
        case getProfile, updateProfile, deleteAccount, getPoliticianOrUser(String), verifyOTPUpdateProfile, changePassword, notificationStatus, politicianList, unfollowRemoveUser, followPolitician, sendFollowRequest, cancelRequest
        
        var method: OTLHTTPMethod {
            switch self {
                case .getProfile:               return .get
                case .getPoliticianOrUser:      return .get
                case .politicianList:            return .get
                default: return .post
            }
        }
        
        var apiName: String {
            switch self {
                    
                case .getProfile:               return "detail"
                case .updateProfile:            return "updateProfile"
                case .deleteAccount:            return "delete_account"
                case .getPoliticianOrUser(let id):      return "getPoliticianOrUser/\(id)"
                case .verifyOTPUpdateProfile:   return "verifyOtpUpdateProfile"
                case .changePassword:           return "changePassword"
                case .notificationStatus:       return "notificationStatus"
                case .politicianList:           return "politicianList"
                case .unfollowRemoveUser:       return "unfollowRemoveUser"
                case .followPolitician:         return "followPolitician"
                case .sendFollowRequest:        return "sendFollowRequest"
                case .cancelRequest:            return "cancelRequest"
            }
        }
    }
}



