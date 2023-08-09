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
        case getTrends, chooseTrends, getSubscriptionPlans, chooseSubscription, saveHistory(String), getSavedPosts, getUserTrends, feedback, addPoll
        
        var method: OTLHTTPMethod {
            switch self {
                case .getTrends:            return .get
                case .getSubscriptionPlans: return .get
                case .saveHistory:          return .get
                case .getSavedPosts:        return .get
                case .getUserTrends:        return .get
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
            }
        }
    }
    
    enum Home: OTLRequestExecuter {
        case getHomePost, getPost(String), commentOnPost, reportPostComment, likeDislikePost, deletePost(String), saveUnsavePost, blockReportUser, listing
       
        var method: OTLHTTPMethod {
            switch self {
                case .getHomePost:          return .get
                case .getPost:              return .get
                default: return .post
            }
        }
        
        var apiName: String {
            switch self {
                case .getHomePost:          return "homeScreen"
                case .getPost(let id):      return "getPost/\(id)"
                case .commentOnPost:        return "commentOnPost"
                case .reportPostComment:    return "reportPostComment"
                case .likeDislikePost:      return "likeDislikePost"
                case .deletePost(let id):   return "deletePost/\(id)"
                case .saveUnsavePost:       return "saveUnsavePost"
                case .blockReportUser:      return "blockReportUser"
                case .listing:              return "listing"
            }
        }
    }
    
    enum Post: OTLRequestExecuter {
        case addPost, deleteImage(String), deletePost(String), editPost
        
        var method: OTLHTTPMethod {
            switch self {
                default: return .post
            }
        }
        
        var apiName: String {
            switch self {
                case .addPost:                  return "addPost"
                case .deleteImage(let id):      return "deleteImage/\(id)"
                case .deletePost(let id):       return "deletePost/\(id)"
                case .editPost:                 return "editPost"
            }
        }
    }
    
    enum Profile: OTLRequestExecuter {
        case getProfile, updateProfile, deleteAccount, getPoliticianOrUser(String), verifyOTPUpdateProfile, changePassword, notificationStatus
        
        var method: OTLHTTPMethod {
            switch self {
                case .getProfile:               return .get
                case .getPoliticianOrUser:      return .get
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
            }
        }
    }
}



