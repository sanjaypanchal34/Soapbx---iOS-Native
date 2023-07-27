//
//  AuthorizedUser.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 26/02/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

//var authUser : AuthorizedUser?
//struct AppKey {
//    static let isFirstTime = "OTL_isFirstTime"
//}

//enum UserLoginType{
//      case userLogin,guestLogin
//}
//class AuthorizedUser {
//
//
//      var loginType = UserLoginType.guestLogin
//
//      init(_ json: JSON) {
//            let user = Mapper<AccountUser>().map(JSON: json)
//            self.user = user
//            loginType = .userLogin
//            UserDefaults.standard.set(json, forKey: AppKey.loginUser)
//            UserDefaults.standard.synchronize()
//      }
//
//      init() {
//            self.user = Mapper<AccountUser>().map(JSON: [:])
//      }
//
//      class func isUserSessionAvailable()->Bool {
//            if UserDefaults.standard.value(forKey: AppKey.loginUser) != nil {
//                  if let json = UserDefaults.standard.value(forKey: AppKey.loginUser) as? [String:Any] {
//                        authUser = AuthorizedUser(json)
//                        return true
//                  }
//            }
//            authUser = AuthorizedUser()
//            return false
//      }
//
//      func updateProfile() {
//            UserDefaults.standard.set(user?.toJSON(), forKey: AppKey.loginUser)
//            UserDefaults.standard.synchronize()
//      }
//
//      func logout() {
//            UserDefaults.standard.removeObject(forKey: AppKey.loginUser)
//            UserDefaults.standard.synchronize()
//            authUser = AuthorizedUser()
//            loginType = .guestLogin
//      }
//
//      class func isUserFirstTime()->Bool {
//            if let status = UserDefaults.standard.value(forKey: AppKey.onboarding) as? Bool {
//                  return status
//            }
//            return true
//      }
//
//      //MARK:- Device Tokens methods
//      class func getDeviceToken() -> String {
//            if let token = UserDefaults.standard.value(forKey: AppKey.deviceToken) as? String {
//                  return token
//            }
//            return ""
//      }
//
//      class func updateDeviceToken( token: String) {
//            App.deviceToken = token
//            UserDefaults.standard.setValue(token, forKey: AppKey.deviceToken)
//            UserDefaults.standard.synchronize()
//      }
//}
//
//enum SubscriptionPlan: String {
//
//      case free = "free", free_ = "" , register_as_premium = "register_as_premium", bisness = "register_as_bisness", premium = "premium"
//
//}
