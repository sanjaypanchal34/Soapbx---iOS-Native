//
//  ChangePasswordViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 24/07/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

class ChangePasswordViewModel {
    
    var otp: String = ""
    var email: String = ""
    
    func resetForgotPassword(new password: String, confirmPassword: String ,complition: @escaping (ResponseCallBack)) {
            let para: JSON = [
                "email_phone": email,
                "otp": otp,
                "new_password": password,
                "confirm_password": confirmPassword
            ]
            
            Webservice.Auth.resetPassword.requestWith(parameter: para) { result in
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
