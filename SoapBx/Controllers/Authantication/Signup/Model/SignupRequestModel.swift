    //
    //  SignupRequestModel.swift
    //  Operators Techno Lab, Ahmedabad
    //
    //  Developed by Harsh Kadiya
    //  Created by OTL-HK on 24/07/2023.
    //  Copyright © 2023 OTL-HK. All rights reserved.
    //

import Foundation

struct SignupRequestModel {
    var first_name: String = ""
    var last_name: String = ""
    var email: String = ""
    var phone_number: String = ""
    var password: String = ""
    var confirm_password: String = ""
    var country_code: String = "+1"
    var location: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    var verified_by: Int = 0
    var otp: String = ""
    var device_token: String = "dummy"
    let device_type = "ios"
    var canVerifyUpdate: Bool {
        get {
            if authUser?.user?.verified_by == 0, authUser?.user?.email != email{
                    // if old email and new email are same then not need to change but if any change then need to verify email agin
                return true
            } else if authUser?.user?.verified_by == 1, authUser?.user?.phone_number != phone_number{
                    // if old phone number and new phone number are same then not need to change but if any change then need to verify phone number agin
                return true
            }
            return false
        }
    }
    
    
    func getJson()-> JSON {
        return [
            "first_name": first_name,
            "last_name": last_name,
            "email": email,
            "phone_number": phone_number,
            "password": password,
            "confirm_password": confirm_password,
            "country_code": "+" + country_code,
            "location": location,
            "longitude": longitude,
            "latitude": latitude,
            "verified_by": verified_by,
            "otp": otp,
            "device_token": device_token,
            "device_type": device_type,
        ]
    }
    
    func getUpdateProfile() -> JSON{
        let requestObj: JSON = ["first_name": first_name,
                                "last_name": last_name,
                                "email": email,
                                "country_code": country_code,
                                "phone_number": phone_number,
                                "location": location,
                                "longitude": longitude,
                                "latitude": latitude,
                                "change_status": canVerifyUpdate ? 1 : 0]
        return requestObj
    }
}
