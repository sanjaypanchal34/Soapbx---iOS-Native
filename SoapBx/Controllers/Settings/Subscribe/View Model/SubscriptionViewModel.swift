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
        SubscribeNotesModel(title: LocalStrings.SUB_ITEM_BLOG.rawValue.addLocalizableString(), freemium: "1/Month", premium: "1/Day",canSymbol: false),
        SubscribeNotesModel(title: LocalStrings.SUB_ITEM_CONDUCT.rawValue.addLocalizableString(), freemium: "1", premium: "1/Week",canSymbol: false),
        SubscribeNotesModel(title: LocalStrings.SUB_ITEM_PRIORITY.rawValue.addLocalizableString(), freemium: "n", premium: "y"),
        SubscribeNotesModel(title: LocalStrings.SUB_ITEM_CHOOSE.rawValue.addLocalizableString(), freemium: "y", premium: "y"),
        SubscribeNotesModel(title: LocalStrings.SUB_ITEM_SOAPBX.rawValue.addLocalizableString(), freemium: "n", premium: "y"),
        SubscribeNotesModel(title: LocalStrings.SUB_ITEM_FEATURE.rawValue.addLocalizableString(), freemium: "n", premium: "y"),
        SubscribeNotesModel(title: LocalStrings.SUB_ITEM_REWARD.rawValue.addLocalizableString(), freemium: "n", premium: "y"),
        SubscribeNotesModel(title: LocalStrings.SUB_ITEM_INVITE.rawValue.addLocalizableString(), freemium: "y", premium: "y"),
        SubscribeNotesModel(title: LocalStrings.SUB_ITEM_BLOG.rawValue.addLocalizableString(), freemium: "y", premium: "y"),
        SubscribeNotesModel(title: LocalStrings.SUB_ITEM_F_POLL.rawValue.addLocalizableString(), freemium: "n", premium: "y"),
    ]
    
    var arrSubsciption: [SubscribeModel] = []
    var isFreemiumSelected = true
    var subscription_id = 1
    var tempSubscription_id = 1
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
                        if let data = data.body?["subscription_id"] as? Int {
                            self.subscription_id = data
                            self.tempSubscription_id = data
                            if data != 1 {
                                self.isFreemiumSelected = false
                            } else {
                                self.isFreemiumSelected = true
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
