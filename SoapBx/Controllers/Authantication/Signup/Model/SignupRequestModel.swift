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
    
    func getJson()-> JSON {
        return [
            "first_name": first_name,
            "last_name": last_name,
            "email": email,
            "phone_number": phone_number,
            "password": password,
            "confirm_password": confirm_password,
            "country_code": country_code,
            "location": location,
            "longitude": longitude,
            "latitude": latitude,
            "verified_by": verified_by,
            "otp": otp,
            "device_token": device_token,
            "device_type": device_type,
        ]
    }
}
