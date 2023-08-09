//
//  SuggestFeatureViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 04/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

class SuggestFeatureViewModel {
    
    
    func updateSubscriptionPlans(
        name: String,
        type: SuggestFeatureScreenType,
        email: String,
        comment: String,
        location: String,
        number: String,
        complition: @escaping (ResponseCallBack)) {
            
            let para: JSON = [
                "name": name,
                "type": type == .feedback ? 1 : 2,
                "email": email,
                "comment": comment,
                "location": location,
                "number": number,
            ]
            
            Webservice.Settings.feedback.requestWith(parameter: para) { result in
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
    
