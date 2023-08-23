//
//  PaymentDetailsVIewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 15/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

class PaymentDetailsVIewModel {
    
    var updateViewComplition:(()->Void)?
    var arrList:[PollModel] = []
    private var isDataLoading: Bool = false
    private var intPage = 1 {
        didSet {
            showLoader()
            getTransactions()
        }
    }
    var currentPage: Int {
        set {
            if isPagenationActive {
                if self.isDataLoading == false {
                    if newValue > intPage , newValue <= totalPage{
                        intPage = intPage + 1
                    }
                }
            }
        }
        get {
            return intPage
        }
    }
    var isPagenationActive: Bool = true
    var totalPage: Int = 0
    func setPage(_ page: Int) {
        intPage = page
    }
    
    
    func getTransactions(complition: (ResponseCallBack)? = nil) {
        let para: JSON = [:]
        let queryPara = ["page":"\(currentPage)"]
        
        Webservice.Settings.previousTransactions.requestWith(parameter: para, queryPara: queryPara) { result in
            switch result {
                case .fail(let message,let code,_):
                    self.arrList = []
                    if complition == nil {
                        self.updateViewComplition?()
                    }
                    self.isDataLoading = false
                    complition?(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let data):
                    if data.code == 200 {
                        if let data = data.body?["data"] as? JSON {
                            if self.intPage == 1 {
                                self.arrList = []
                            }
                            let total = data["total"] as? Int ?? 0
                            let perPage = data["per_page"] as? Int ?? 0
                            self.totalPage = Int(CGFloat(total/perPage).rounded(.up))
                            if let polls = data["data"] as? JSONArray {
                                for poll in polls {
                                    do {
                                        let pollData = try JSONSerialization.data(withJSONObject: poll)
                                        let pollModel = try JSONDecoder().decode(PollModel.self, from: pollData)
                                        self.arrList.append(pollModel)
                                    } catch{
                                        print("[TradPostListViewModel] getHomePost response posts try Catch : \(error)")
                                    }
                                }
                            }
                        }
                        if complition == nil {
                            self.updateViewComplition?()
                        }
                        self.isDataLoading = false
                        complition?(CompanComplition(message: data.message, code: data.code, status: true))
                    } else {
                        self.arrList = []
                        if complition == nil {
                            self.updateViewComplition?()
                        }
                        self.isDataLoading = false
                        complition?(CompanComplition(message: data.message, code: data.code, status: false))
                    }
            }
        }
    }
    
    func voteOnPoll(pollId: Int, optionId: Int,complition: @escaping ((CompanComplition, [String:DoubleCast]?)->())) {
        let para: JSON = ["poll_id": pollId,"option_id": optionId]
        
        Webservice.Settings.voteOnPoll.requestWith(parameter: para) { result in
            switch result {
                case .fail(let message,let code,_):
                    complition(CompanComplition(message: message, code: code ?? 111, status: false), nil)
                case .success(let data):
                    if data.code == 200 {
                        var pollPercent: [String:DoubleCast] = [:]
                        if let data = data.body?["data"] as? JSON {
                            if let pollPer = data["poll_percent"] as? JSON {
                                do {
                                    let pollData = try JSONSerialization.data(withJSONObject: pollPer)
                                    pollPercent = try JSONDecoder().decode([String:DoubleCast].self, from: pollData)
                                }
                                catch{
                                    print("[TradPostListViewModel] getHomePost response posts try Catch : \(error)")
                                }
                            }
                        }
                        complition(CompanComplition(message: data.message, code: data.code, status: true), pollPercent)
                    } else {
                        complition(CompanComplition(message: data.message, code: data.code, status: false), nil)
                    }
            }
        }
    }
}
