//
//  LoginViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 24/07/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    func login(email: String, password: String, complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["email": email, "password":password, "device_token": "dummy", "device_type": "ios"]
        
        Webservice.Auth.login.requestWith(parameter: para) { result in
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
    
    func logout(complition: @escaping (ResponseCallBack)) {
        let para: JSON = [:]
        
        Webservice.Auth.logout.requestWith(parameter: para) { result in
            switch result {
                case .fail(let message,let code,_):
                    complition(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let data):
                    if data.code == 200 {
                        authUser?.logout()
                        complition(CompanComplition(message: data.message, code: data.code, status: true))
                    } else {
                        complition(CompanComplition(message: data.message, code: data.code, status: false))
                    }
            }
        }
    }
    
   
}
