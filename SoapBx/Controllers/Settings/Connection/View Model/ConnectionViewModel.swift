//
//  ConnectionViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 15/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

enum ConnectionTab {
    case blocked, unfollowed
}

class ConnectionViewModel {
    
    var selectedTab = ConnectionTab.blocked {
        didSet {
            intPage = 1
        }
    }
    var updateViewComplition:(()->Void)?
    var arrList:[PostUser] = []
    private var isDataLoading: Bool = false
    private var intPage = 1 {
        didSet {
            showLoader()
            if selectedTab == .blocked {
                getBockedUser()
            } else {
                getUnfollowedAccounts()
            }
        }
    }
    var currentPage: Int {
        set {
            if isPagenationActive {
                if self.isDataLoading == false {
                    if newValue > intPage {
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
    func setPage(_ page: Int){
        self.intPage = page
    }
    
    func getBockedUser(complition: (ResponseCallBack)? = nil) {
        if self.isDataLoading{
            return
        }
        let para: JSON = [:]
        let queryPara = ["page": "\(intPage)"]
        
        self.isDataLoading = true
        Webservice.Settings.getBockedUser.requestWith(parameter: para, queryPara: queryPara) { result in
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
                            if let politicians = data["data"] as? JSONArray {
                                for obj in politicians {
                                    if let politician = obj["user"] as? JSON {
                                        do {
                                            let politicianData = try JSONSerialization.data(withJSONObject: politician)
                                            let politicianModel = try JSONDecoder().decode(PostUser.self, from: politicianData)
                                            self.arrList.append(politicianModel)
                                        } catch{
                                            print("[TradPostListViewModel] getHomePost response posts try Catch : \(error)")
                                        }
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
    
    func getUnfollowedAccounts(complition: (ResponseCallBack)? = nil) {
        if self.isDataLoading{
            return
        }
        let para: JSON = [:]
        var queryPara = ["page": "\(intPage)"]
        
        self.isDataLoading = true
        Webservice.Settings.unfollowedAccounts.requestWith(parameter: para, queryPara: queryPara) { result in
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
                            if let politicians = data["data"] as? JSONArray {
                                for obj in politicians {
                                    if let politician = obj["politician"] as? JSON {
                                        do {
                                            let politicianData = try JSONSerialization.data(withJSONObject: politician)
                                            let politicianModel = try JSONDecoder().decode(PostUser.self, from: politicianData)
                                            self.arrList.append(politicianModel)
                                        } catch{
                                            print("[TradPostListViewModel] getHomePost response posts try Catch : \(error)")
                                        }
                                    }
                                    if let politician = obj["user"] as? JSON {
                                        do {
                                            let politicianData = try JSONSerialization.data(withJSONObject: politician)
                                            let politicianModel = try JSONDecoder().decode(PostUser.self, from: politicianData)
                                            self.arrList.append(politicianModel)
                                        } catch{
                                            print("[TradPostListViewModel] getHomePost response posts try Catch : \(error)")
                                        }
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
    
    func unbockedUser(user id: Int, complition: @escaping (ResponseCallBack)) {
        let para: JSON = [:]
       
        Webservice.Settings.unblockUser("\(id)").requestWith(parameter: para) { result in
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
