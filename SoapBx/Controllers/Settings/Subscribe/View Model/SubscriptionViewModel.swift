    //
    //  SubscriptionViewModel.swift
    //  Operators Techno Lab, Ahmedabad
    //
    //  Developed by Harsh Kadiya
    //  Created by OTL-HK on 28/07/2019.
    //  Copyright © 2023 OTL-HK. All rights reserved.
    //

import Foundation

class SubscriptionViewModel {
    
    var arrSubscribeNote = [
        SubscribeNotesModel(title: "Blog and Report", freemium: "1/Month", premium: "1/Day",canSymbol: false),
        SubscribeNotesModel(title: "Conduct Polls", freemium: "1", premium: "1/Week",canSymbol: false),
        SubscribeNotesModel(title: "Priority Support", freemium: "n", premium: "y"),
        SubscribeNotesModel(title: "Choose Trends", freemium: "y", premium: "y"),
        SubscribeNotesModel(title: "Soapbx Initiatives", freemium: "n", premium: "y"),
        SubscribeNotesModel(title: "Featured Member", freemium: "n", premium: "y"),
        SubscribeNotesModel(title: "Rewards", freemium: "n", premium: "y"),
        SubscribeNotesModel(title: "Invite Friends", freemium: "y", premium: "y"),
        SubscribeNotesModel(title: "Featured Blog", freemium: "y", premium: "y"),
        SubscribeNotesModel(title: "Featured Poll", freemium: "n", premium: "y"),
    ]
    
    var arrSubsciption: [SubscribeModel] = []
    var isFreemiumSelected = true
    
    func getSubscriptionPlans( complition: @escaping (ResponseCallBack)) {
        let para: JSON = [:]
        
        Webservice.Settings.getSubscriptionPlans.requestWith(parameter: para) { result in
            switch result {
                case .fail(let message,let code,_):
                    complition(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let data):
                    if data.code == 200 {
                        if let data = data.body?["data"] as? [JSON] {
                            for obj in data {
                                do {
                                    let data = try JSONSerialization.data(withJSONObject: obj)
                                    var model = try JSONDecoder().decode(SubscribeModel.self, from: data)
                                    if (model.price ?? 0) == 0 {
                                        model.isSelected = true
                                    }
                                    self.arrSubsciption.append(model)
                                } catch{
                                    print("[SubscriptionViewModel] getSubscriptionPlans response try Catch : \(error)")
                                }
                            }
                        }
                        complition(CompanComplition(message: data.message, code: data.code, status: true))
                    } else {
                        complition(CompanComplition(message: data.message, code: data.code, status: false))
                    }
            }
        }
    }
    
    func updateSubscriptionPlans(complition: @escaping (ResponseCallBack)) {
        let subscription = arrSubsciption.compactMap { sub in
            if sub.isSelected {
                return sub
            }
            return nil
        }
        if subscription.count > 0 {
            let para: JSON = ["subscription_id": subscription.first?.id ?? 0]
            
            Webservice.Settings.chooseSubscription.requestWith(parameter: para) { result in
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
        } else {
            complition(CompanComplition(message: "Please select subscription plan", code: 12, status: false))
        }
    }
}
