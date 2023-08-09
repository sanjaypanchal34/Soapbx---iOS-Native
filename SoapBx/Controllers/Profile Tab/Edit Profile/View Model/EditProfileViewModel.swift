//
//  EditProfileViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 24/07/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation
import UIKit

class EditProfileViewModel {
    
    var selectedSearch:GMapResult?
    var profileImage: UIImage?
    var coverImage: UIImage?
    var requestObj: SignupRequestModel?
    
    
    func updateProfile(complition: @escaping (ResponseCallBack)) {
        let para: JSON = requestObj?.getUpdateProfile() ?? [:]
        var formdata:[OTLMultipartFormData] = []
        if let profile = profileImage,
           let profileData = profile.jpegData(compressionQuality: 0.8) {
            formdata.append(OTLMultipartFormData(name: "profile_photo", filename: "profile_photo", data: profileData))
        }
        
        if let coverImage = coverImage,
           let profileData = coverImage.jpegData(compressionQuality: 0.8) {
            formdata.append(OTLMultipartFormData(name: "cover_photo", filename: "cover_photo", data: profileData))
        }
        
        Webservice.Profile.updateProfile.requestWith(multipart: formdata, parameter: para ) { result in
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
    
    func verifyUpdateProfileOTP(otp: String, complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["email_phone": requestObj?.email ?? "", "otp":otp]
        
        Webservice.Profile.verifyOTPUpdateProfile.requestWith(parameter: para ) { result in
            switch result {
                case .fail(let message,let code,_):
                    complition(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let data):
                    if data.code == 200 {
                        self.updateProfile(complition: complition)
                    } else {
                        complition(CompanComplition(message: data.message, code: data.code, status: false))
                    }
            }
        }
    }
}
