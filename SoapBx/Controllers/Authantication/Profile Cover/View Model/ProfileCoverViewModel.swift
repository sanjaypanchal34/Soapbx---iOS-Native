//
//  ProfileCoverViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation
import UIKit

class ProfileCoverViewModel {
    
    
    func register(profile: UIImage,
                  cover: UIImage?,
                  complition: @escaping (ResponseCallBack)) {
        let para: JSON = [:]
        var formdata:[OTLMultipartFormData] = []
        if let profileData = profile.jpegData(compressionQuality: 0.8) {
            formdata.append(OTLMultipartFormData(name: "profile_photo", filename: "profile_photo", data: profileData))
        }
        
        if let coverImage = cover,
           let profileData = coverImage.jpegData(compressionQuality: 0.8) {
            formdata.append(OTLMultipartFormData(name: "cover_photo", filename: "cover_photo", data: profileData))
        }
        
        Webservice.Auth.completeProfile.requestWith(multipart: formdata, parameter: para ) { result in
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
}
