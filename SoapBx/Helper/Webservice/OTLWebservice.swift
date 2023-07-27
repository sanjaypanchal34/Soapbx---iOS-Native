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
    var isQueryPara: Bool { get }
    
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
            
            if self.isQueryPara {
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
            if self.isQueryPara {
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
        
        var isQueryPara: Bool { return false }
        
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
    //VERIFY_OTP: "verifyOtp",
    //RESET_PASS: "resetPassword",
    //    enum Profile: RequestExecuter {
    //        case updateEmail, updateName, updatePassword, getQRCode, deviceRegister
    //        case updateRegion, updateLanguage
    //        case getSubscriptionPlan, getSubscriptionDetails, buySubscription
    //        case getPhraseCategory, getPhrases
    //        case updateProfile, updateVoice
    //        case transferOwnership
    //        case updateQuickBlox
    //
    //        var isQueryPara: Bool { false}
    //
    //        var method: HTTPMethod {
    //            switch self { default: return .post }
    //        }
    //
    //        var apiName: String {
    //            switch self {
    //            case .updateEmail:                  return "preferences/UpdateUseremail/"
    //            case .updateName:                   return "preferences/UpdateName/"
    //            case .updatePassword:               return "preferences/UpdateUserpassword/"
    //            case .getQRCode:                    return "registerdevice/generateUserQR"
    //            case .deviceRegister:               return "registerdevice/registerDevice"
    //            case .updateRegion:                 return "Preferences/UpdateRegion"
    //            case .updateLanguage:               return "preferences/updateLanguageCode"
    //            case .getSubscriptionPlan:          return "registerdevice/getServices"
    //            case .getSubscriptionDetails:       return "registerdevice/getServicesFeature"
    //            case .buySubscription:              return "SubscriptionPlan/addSubscriptionPlan"
    //            case .getPhraseCategory:            return "phrasemaster/getPhraseCategory"
    //            case .getPhrases:                   return "phrasemaster/getPhrases"
    //            case .updateProfile:                return "preferences/UpdateProfilePicture/"
    //            case .updateVoice:                  return "preferences/updateVoicePreference/"
    //            case .transferOwnership:            return "preferences/transferOwnership"
    //            case .updateQuickBlox:              return "preferences/UpdateQuickBlox"
    //            }
    //        }
    //    }
    //
    //    enum ProfileFriend: RequestExecuter {
    //        case getAllFriendRequest, acceptFriendRequest, rejectFriendRequest, getMyFriendMessages,
    //             inviteFriend, getTranslateUser, getMyAllFriend, unfriend
    //
    //        var isQueryPara: Bool { false}
    //
    //        var method: HTTPMethod {
    //            switch self {
    //            default: return .post
    //            }
    //        }
    //
    //        var apiName: String {
    //            switch self {
    //            case .getAllFriendRequest:                return "friendmaster/getAllFriendRequest"
    //            case .acceptFriendRequest:                return "friendmaster/acceptFriendRequest"
    //            case .rejectFriendRequest:                return "friendmaster/rejectFriendRequest"
    //            case .getMyFriendMessages:                return "Friendmessage/getMyFriendMessages"
    //            case .inviteFriend:                       return "friendmaster/sendFriendRequest"
    //            case .getTranslateUser:                   return "registerdevice/getTranslateUser"
    //            case .getMyAllFriend:                     return "friendmaster/getFriends"
    //            case .unfriend:                           return "friendmaster/removeFriend"
    //            }
    //        }
    //    }
    //
    //    enum Chat: RequestExecuter {
    //        case sendMessages, getFriendMessage, deletefriendMessages
    //
    //        var isQueryPara: Bool { false}
    //
    //        var method: HTTPMethod {
    //            switch self {
    //            default: return .post
    //            }
    //        }
    //
    //        var apiName: String {
    //            switch self {
    //            case .sendMessages:             return "friendmessage/sendMessage"
    //            case .getFriendMessage:         return "Friendmessage/getFriendMessage"
    //            case .deletefriendMessages:     return "Friendmessage/removeFriendMessage"
    //            }
    //        }
    //    }
    //
    //    enum Group: RequestExecuter {
    //        case getList, create, update, remove, addMember, getInfo, removeImage, getMessages, sendMessage, removeMessages
    //
    //
    //        var isQueryPara: Bool { false}
    //
    //        var method: HTTPMethod {
    //            switch self {
    //            default: return .post
    //            }
    //        }
    //
    //        var apiName: String {
    //            switch self {
    //            case .getList:              return "groupmaster/listGroup"
    //            case .create:               return "groupmaster/createGroup"
    //            case .update:               return "groupmaster/updateGroup"
    //            case .remove:               return "groupmaster/removeGroup"
    //            case .addMember:            return "groupmaster/addGroupMember"
    //            case .getInfo:              return "groupmaster/getGroupInfo"
    //            case .removeImage:          return "groupmaster/removeGroupImage"
    //            case .getMessages:          return "groupmaster/getGroupMessage"
    //            case .sendMessage:          return "groupmaster/storeGroupMessage"
    //            case .removeMessages:       return "groupmaster/removeGroupMessage"
    //            }
    //        }
    //    }
    //
    //    enum Global: RequestExecuter {
    //        case getAdvertisement, getTwilioAccessToken
    //
    //        var isQueryPara: Bool { return false }
    //
    //        var method: HTTPMethod {
    //            return .post
    //        }
    //
    //        var apiName: String {
    //            switch self {
    //            case .getAdvertisement:       return "registerdevice/getAdvertisement/"
    //            case .getTwilioAccessToken:   return "GenerateTwilioAccessToken/generateTwilioAccessToken"
    //            }
    //        }
    //    }
    //
    //    enum VoIP: RequestExecuter
    //    {
    //        case getDuration, findTranslator, cancelCallRquestByMyJunoUser, mackCall, endCall, rateTranslator
    //
    //        var isQueryPara: Bool { return false }
    //
    //        var method: HTTPMethod
    //        {
    //            return .post
    //        }
    //
    //        var apiName: String
    //        {
    //            switch self
    //            {
    //            case .getDuration:                  return "Calldurationmaster/listCallDuration"
    //            case .findTranslator:               return "Translator/findTranslator"
    //            case .cancelCallRquestByMyJunoUser: return "Translator/cancelCallRequestByMyjunoUser"
    //            case .mackCall:                     return "Translator/makeCall"
    //            case .endCall:                      return "Translator/endCall"
    //            case .rateTranslator:               return "Translator/rateTranslator"
    //            }
    //        }
    //    }
}



