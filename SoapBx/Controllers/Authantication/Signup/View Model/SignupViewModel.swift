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
        let para: JSON = signupJson?.getJson() ?? [:]
        
        Webservice.Auth.verifySignup.requestWith(parameter: para) { result in
            switch result {
            case .fail(let message,let code,_):
                complition(CompanComplition(message: message, code: code ?? 111, status: false))
            case .success(let data):
                if data.code == 200 {
                    if let data = data.body?["data"] as? JSON {
                        authUser = AuthorizedUser(data)
                    }
                    complition(CompanComplition(message: data.message, code: data.code, status: true))
                } else {
                    complition(CompanComplition(message: data.message, code: data.code, status: false))
                }
            }
        }
    }
    
    func verifyOTP(otp: String ,complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["otp": otp, "email_phone": signupJson?.email ?? ""]
        
        Webservice.Auth.verifyOtp.requestWith(parameter: para) { result in
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
    
    func forgotPassword(email: String, complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["email_phone":email]
        
        Webservice.Auth.forgotPassword.requestWith(parameter: para) { result in
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
