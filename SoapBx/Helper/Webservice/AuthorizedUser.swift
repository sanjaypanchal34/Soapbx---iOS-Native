//
//  AuthorizedUser.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 26/02/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

var authUser : AuthorizedUser?


struct OTLAppKey {
    static let isFirstTime = "OTL_isFirstTime"
    static let loginUser = "OTL_loginUser"
    static let isGuestUser = "OTL_isGuestUser"
}

enum UserLoginType{
      case userLogin,guestLogin
}
class AuthorizedUser {

    var user: UserAuthModel?
    var loginType = UserLoginType.guestLogin

      init(_ json: JSON) {
            let user = UserAuthModel(json)
            self.user = user
            loginType = .userLogin
          UserDefaults.standard.set(false, forKey: OTLAppKey.isGuestUser)
          UserDefaults.standard.set(user.getJson(), forKey: OTLAppKey.loginUser)
            UserDefaults.standard.synchronize()
          OTLWebserviceConfiguration.instance.header = ["Accept":"application/json",
                                                        "Authorization": "Bearer  \(user.auth_token)"]
      }

    init(_ isGuest: Bool) {
        loginType = isGuest ? .guestLogin : .userLogin
        UserDefaults.standard.set(isGuest, forKey: OTLAppKey.isGuestUser)
        UserDefaults.standard.synchronize()
        
    }
    
      class func isUserSessionAvailable()->Bool {
            if UserDefaults.standard.value(forKey: OTLAppKey.loginUser) != nil {
                  if let json = UserDefaults.standard.value(forKey: OTLAppKey.loginUser) as? [String:Any] {
                        authUser = AuthorizedUser(json)
                        return true
                  }
            }
          else if UserDefaults.standard.value(forKey: OTLAppKey.isGuestUser) != nil {
              if let isGuest = UserDefaults.standard.value(forKey: OTLAppKey.isGuestUser) as? Bool {
                  authUser = AuthorizedUser(isGuest)
                  return true
              }
          }
            return false
      }

      func updateProfile() {
            UserDefaults.standard.set(user?.getJson(), forKey: OTLAppKey.loginUser)
            UserDefaults.standard.synchronize()
      }

      func logout() {
            UserDefaults.standard.removeObject(forKey: OTLAppKey.loginUser)
            UserDefaults.standard.removeObject(forKey: OTLAppKey.isGuestUser)
            UserDefaults.standard.synchronize()
            authUser = nil
//            loginType = .guestLogin
      }

}

enum SubscriptionPlan: String {

      case free = "free", free_ = "" , register_as_premium = "register_as_premium", bisness = "register_as_bisness", premium = "premium"

}

struct UserAuthModel {
    var active = 0
    var auth_token: String = ""
    var auth_token2: String = ""
    var country_code: String = ""
    var cover_photo_thumb_url: String = ""
    var cover_photo_url: String = ""
    var created_at: String = ""
    var device_token: String = ""
    var device_type: String = ""
    var email: String = ""
    var end_date_subscription: String = ""
    var first_name: String = ""
    var followers = 0
    var following = 0
    var full_name: String = ""
    var id = 0
    var last_name: String = ""
    var latitude: Double = 0
    var location: String = ""
    var longitude: Double = 0
    var name: String = ""
    var phone_number: String = ""
    var politician = 0;
    var profile_photo_thumb_url: String = ""
    var profile_photo_url: String = ""
    var referral_code: String = ""
    var referral_code_used: String = ""
    var role_id = 2
    var status_poli = 0
    var status_user = 0
    var step = 1 // 1 == Home, 2 == profile update, 3 == Trends, 4 == subscription
    var subscription_type = 0
    var subscription_id = 0
    var updated_at: String = ""
    var uuid: String = ""
    var verified_by = 0
    var voters = 100
    
     init(_ json: JSON) {
        
        self.active             = json["active"] as? Int ?? 0
        self.auth_token         = json["auth_token"] as? String ?? ""
        self.auth_token2        = json["auth_token2"] as? String ?? ""
        self.country_code       = json["country_code"] as? String ?? ""
        self.cover_photo_thumb_url = json["cover_photo_thumb_url"] as? String ?? ""
        self.cover_photo_url    = json["cover_photo_url"] as? String ?? ""
        self.created_at         = json["created_at"] as? String ?? ""
        self.device_token       = json["device_token"] as? String ?? ""
        self.device_type        = json["device_type"] as? String ?? ""
        self.email              = json["email"] as? String ?? ""
        self.end_date_subscription = json["end_date_subscription"] as? String ?? ""
        self.first_name         = json["first_name"] as? String ?? ""
        self.followers          = json["followers"] as? Int ?? 0
        self.following          = json["following"] as? Int ?? 0
        self.full_name          = json["full_name"] as? String ?? ""
        self.id                 = json["id"] as? Int ?? 0
        self.last_name          = json["last_name"] as? String ?? ""
        self.latitude           = json["latitude"] as? Double ?? 0
        self.location           = json["location"] as? String ?? ""
        self.longitude          = json["longitude"] as? Double ?? 0
        self.name               = json["name"] as? String ?? ""
        self.phone_number       = json["phone_number"] as? String ?? ""
        self.politician         = json["politician"] as? Int ?? 0
        self.profile_photo_thumb_url = json["profile_photo_thumb_url"] as? String ?? ""
        self.profile_photo_url  = json["profile_photo_url"] as? String ?? ""
        self.referral_code      = json["referral_code"] as? String ?? ""
        self.referral_code_used = json["referral_code_used"] as? String ?? ""
        self.role_id            = json["role_id"] as? Int ?? 0
        self.status_poli        = json["status_poli"] as? Int ?? 0
        self.status_user        = json["status_user"] as? Int ?? 0
        self.step               = json["step"] as? Int ?? 0
        self.subscription_type  = json["subscription_type"] as? Int ?? 0
        self.subscription_id    = json["subscription_id"] as? Int ?? 0
        self.updated_at         = json["updated_at"] as? String ?? ""
        self.uuid               = json["uuid"] as? String ?? ""
        self.verified_by        = json["verified_by"] as? Int ?? 0
        self.voters             = json["voters"] as? Int ?? 0
    }
    
    func getJson() -> JSON{
        return ["active": self.active,
        "auth_token": self.auth_token,
        "auth_token2": self.auth_token2,
        "country_code": self.country_code,
        "cover_photo_thumb_url": self.cover_photo_thumb_url,
        "cover_photo_url": self.cover_photo_url,
        "created_at": self.created_at,
        "device_token": self.device_token,
        "device_type": self.device_type,
        "email": self.email,
        "end_date_subscription": self.end_date_subscription,
        "first_name": self.first_name,
        "followers": self.followers,
        "following": self.following,
        "full_name": self.full_name,
        "id": self.id,
        "last_name": self.last_name,
        "latitude": self.latitude,
        "location": self.location,
        "longitude": self.longitude,
        "name": self.name,
        "phone_number": self.phone_number,
        "politician": self.politician,
        "profile_photo_thumb_url": self.profile_photo_thumb_url,
        "profile_photo_url": self.profile_photo_url,
        "referral_code": self.referral_code,
        "referral_code_used": self.referral_code_used,
        "role_id": self.role_id,
        "status_poli": self.status_poli,
        "status_user": self.status_user,
        "step": self.step,
        "subscription_type": self.subscription_type,
        "updated_at": self.updated_at,
        "uuid": self.uuid,
        "verified_by": self.verified_by,
        "voters": self.voters]
    }
}
