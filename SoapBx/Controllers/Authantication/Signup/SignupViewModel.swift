//
//  SignupViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 24/07/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

class SignupViewModel {
   
    var selectedSearch:GMapResult?
    var signupJson: SignupRequestModel?
    
    func register(phone number: String, country code: String = "+1", email: String, verified by: Int, complition: @escaping (ResponseCallBack)) {
        var para: JSON = ["email": email, "verified_by":by]
        if by == 1 {
            para["number"] = number
            para["country_code"] = code
        }
        
        Webservice.Auth.register.requestWith(parameter: para) { result in
            switch result {
            case .fail(let message,let code,_):
                complition(CompanComplition(message: message, code: code ?? 111, status: false))
            case .success(let data):
                if data.code == 200 {
                    complition(CompanComplition(message: data.message, code: data.code, status: true))
                } else {
                    complition(CompanComplition(message: data.message, code: data.code, status: false))
                }
            }
        }
    }
    
    func registerWithVerify( complition: @escaping (ResponseCallBack)) {
        var para: JSON = signupJson?.getJson() ?? [:]
        
        Webservice.Auth.verifySignup.requestWith(parameter: para) { result in
            switch result {
            case .fail(let message,let code,_):
                complition(CompanComplition(message: message, code: code ?? 111, status: false))
            case .success(let data):
                if data.code == 200 {
                    complition(CompanComplition(message: data.message, code: data.code, status: true))
                } else {
                    complition(CompanComplition(message: data.message, code: data.code, status: false))
                }
            }
        }
    }
}
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
//"data": {
//    active = 1;
//    "auth_token" = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDY0ODA4NWMxNzQ1OThjNzYyZTdkYTFlMmMxMmQzZDhmMjk3NjQ4MGQ5YmQ2NzNkZDlkM2ViYzg3MjI4ZDI4NTkxY2Y5ZGI1NzYxMDE5YjAiLCJpYXQiOjE2OTAzOTYxNTMsIm5iZiI6MTY5MDM5NjE1MywiZXhwIjoxNzIyMDE4NTUzLCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.SuAEksSSSXSKfzSuLrbMl0ixs6tt4pcvZcvqO-NvWEov9T0p_QSfLNhJUa4z1cImMOCxKV_GHaYYWdQxEobmyMIrOjXGn9EtpKOxjWYcvahoNn6l6VJ3D5WaEouUkQYhCS8qR_JEEGZoFpMEN7bqnAg51-3V42AtiOawBBCGo5gL5VKwKpu5Vt1wOJ7i_u3CM66giJOPzeBhYVeTFevuQF5_cokJ9Z0lDBO2m_byBKHcFuUSg5_K4JdbGxWJL_h9NAHkA35Djw42jUnhBfCqZR3eWvBBawWqeQk3uT088SJu4iWR73amMDNlklph6-3yHuPxo7S5UMLgyO7pqVI7G9gKULqFxkpV4hrd8zP2F0-tS9H806eVapxBpDvPbwrYcYPNOfK3te1tg1oiXrmMRuDHllVm-a0M3CqQg-9xqBfQruRq5cJ4vn-vvaXqm5R2BwhcHvQSqY4qdinJ4LZuJJMN1KVJ9iFyM0CmQBhqPZ6ZZv6ftW75yYUc1d7kLCUZ5ADF0nEEUBldzZYeDqRYXcNdhyH5U6ED4u3vh7YG8-SV95aC7fsYFX4GXrLzaBMxUU-a0-DbUyIIk9qHu-giIRPwCim0k2QTB4AMvOhzf1pF31j4f2d4itqAldjh22SEQL3hlfvlxVXu_dbYLZoJnIldujS6yfvWU0IBDhrL8Zs";
//    "auth_token2" = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDY0ODA4NWMxNzQ1OThjNzYyZTdkYTFlMmMxMmQzZDhmMjk3NjQ4MGQ5YmQ2NzNkZDlkM2ViYzg3MjI4ZDI4NTkxY2Y5ZGI1NzYxMDE5YjAiLCJpYXQiOjE2OTAzOTYxNTMsIm5iZiI6MTY5MDM5NjE1MywiZXhwIjoxNzIyMDE4NTUzLCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.SuAEksSSSXSKfzSuLrbMl0ixs6tt4pcvZcvqO-NvWEov9T0p_QSfLNhJUa4z1cImMOCxKV_GHaYYWdQxEobmyMIrOjXGn9EtpKOxjWYcvahoNn6l6VJ3D5WaEouUkQYhCS8qR_JEEGZoFpMEN7bqnAg51-3V42AtiOawBBCGo5gL5VKwKpu5Vt1wOJ7i_u3CM66giJOPzeBhYVeTFevuQF5_cokJ9Z0lDBO2m_byBKHcFuUSg5_K4JdbGxWJL_h9NAHkA35Djw42jUnhBfCqZR3eWvBBawWqeQk3uT088SJu4iWR73amMDNlklph6-3yHuPxo7S5UMLgyO7pqVI7G9gKULqFxkpV4hrd8zP2F0-tS9H806eVapxBpDvPbwrYcYPNOfK3te1tg1oiXrmMRuDHllVm-a0M3CqQg-9xqBfQruRq5cJ4vn-vvaXqm5R2BwhcHvQSqY4qdinJ4LZuJJMN1KVJ9iFyM0CmQBhqPZ6ZZv6ftW75yYUc1d7kLCUZ5ADF0nEEUBldzZYeDqRYXcNdhyH5U6ED4u3vh7YG8-SV95aC7fsYFX4GXrLzaBMxUU-a0-DbUyIIk9qHu-giIRPwCim0k2QTB4AMvOhzf1pF31j4f2d4itqAldjh22SEQL3hlfvlxVXu_dbYLZoJnIldujS6yfvWU0IBDhrL8Zs";
//    "country_code" = "+1";
//    "cover_photo_thumb_url" = "http://164.90.178.223:9179/assets/img/user-icon.png";
//    "cover_photo_url" = "http://164.90.178.223:9179/assets/img/user-icon.png";
//    "created_at" = "2023-07-26T18:29:13.000000Z";
//    "device_token" = dummy;
//    "device_type" = ios;
//    email = "test1@yopmail.com";
//    "end_date_subscription" = "<null>";
//    "first_name" = Test1;
//    followers = 0;
//    following = 0;
//    "full_name" = "Test1  Last";
//    id = 5;
//    "last_name" = Last;
//    latitude = 0;
//    location = "<null>";
//    longitude = 0;
//    name = "Test1 Last";
//    "phone_number" = "<null>";
//    politician = 0;
//    "profile_photo_thumb_url" = "http://164.90.178.223:9179/assets/img/user-icon.png";
//    "profile_photo_url" = "http://164.90.178.223:9179/assets/img/sign-logo.png";
//    "referral_code" = aeL5T;
//    "referral_code_used" = "<null>";
//    "role_id" = 2;
//    "status_poli" = 0;
//    "status_user" = 0;
//    step = 2;
//    "subscription_type" = 0;
//    "updated_at" = "2023-07-26T18:29:13.000000Z";
//    uuid = "eb99db9e-3665-4a29-aa7f-fd2206e2efd5";
//    "verified_by" = 0;
//    voters = 100;
//}, "status": 200, "message": Account Verified, Signed up successfully please complete profile
