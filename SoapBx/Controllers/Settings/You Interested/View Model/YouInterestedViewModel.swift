//
//  YouInterestedViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

class YouInterestedViewModel {
    
    var arrList: [TrendsModel] = []
    var arrSelectedId:[Int] = []
    let maxSelection = 3
    
    func getTrends( complition: @escaping (ResponseCallBack)) {
        let para: JSON = [:]
        
        Webservice.Settings.getTrends.requestWith(parameter: para) { result in
            switch result {
            case .fail(let message,let code,_):
                complition(CompanComplition(message: message, code: code ?? 111, status: false))
            case .success(let data):
                if data.code == 200 {
                    if let data = data.body?["data"] as? JSONArray {
                        for obj in data {
                            do {
                                let data = try JSONSerialization.data(withJSONObject: obj)
                                let model = try JSONDecoder().decode(TrendsModel.self, from: data)
                                self.arrList.append(model)
                            } catch{
                                print("[YouInterestedViewModel] getTrends response try Catch : \(error)")
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
    
    func updateTrends( complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["trends": arrSelectedId]
        
        Webservice.Settings.chooseTrends.requestWith(parameter: para) { result in
            switch result {
            case .fail(let message,let code,_):
                complition(CompanComplition(message: message, code: code ?? 111, status: false))
            case .success(let data):
                if data.code == 200 {
                    authUser?.user?.step = 4
                    authUser?.updateProfile()
                    complition(CompanComplition(message: data.message, code: data.code, status: true))
                } else {
                    complition(CompanComplition(message: data.message, code: data.code, status: false))
                }
            }
        }
    }
    
    func getUserTrends(complition: @escaping (ResponseCallBack)) {
        
        let para: JSON = [:]
        
        Webservice.Settings.getUserTrends.requestWith(parameter: para) { result in
            switch result {
                case .fail(let message,let code,_):
                    complition(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let data):
                    if data.code == 200 {
                        if let trends = data.body?["data"] as? JSONArray {
                            self.arrSelectedId = trends.compactMap { trend in
                                return trend["trend_id"] as? Int
                            }
                        }
                        complition(CompanComplition(message: data.message, code: data.code, status: true))
                    } else {
                        complition(CompanComplition(message: data.message, code: data.code, status: false))
                    }
            }
        }
    }
}
