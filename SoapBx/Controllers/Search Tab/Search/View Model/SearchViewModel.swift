//
//  SearchViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 04/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation
enum ListingType {
    case friends, politician, myFriends
    
    var id: Int {
        switch self {
            case .friends:      return 3
            case .politician:   return 4
            case .myFriends:    return 5
        }
    }
}

class SearchViewModel {
    
    var type: ListingType = .politician {
        didSet {
            intPage = 1
        }
    }
    var screenType = SearchScreenType.searchTab
    var updateViewComplition:(()->Void)?
    var arrList:[PostUser] = []
    var arrSearchList:[PostUser] = []
    var arrSelectedId:[Int] = []
    private var isDataLoading: Bool = false
    private var intPage = 1 {
        didSet {
            getPolitician()
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
    var isSearch: Bool {
        get { return searchString.count > 0}
    }
    var searchString = "" {
        didSet {
            if searchString.count > 2 {
                screenType == .fromPublicFigures ? getPolitician() : userSearch()
            } else {
                updateViewComplition?()
            }
        }
    }
    
    func getPolitician(complition: (ResponseCallBack)? = nil) {
        if self.isDataLoading{
            return
        }
        let para: JSON = [ "type": type.id, ]
        var queryPara = ["page": "\(intPage)"]
        if searchString.count > 2 {
            queryPara["keyword"] = searchString
        }
        
        self.isDataLoading = true
        Webservice.Home.listing.requestWith(parameter: para, queryPara: queryPara) { result in
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
                                    else if let politician = obj["request"] as? JSON {
                                        do {
                                            let politicianData = try JSONSerialization.data(withJSONObject: politician)
                                            let politicianModel = try JSONDecoder().decode(PostUser.self, from: politicianData)
                                            self.arrList.append(politicianModel)
                                        } catch{
                                            print("[TradPostListViewModel] getHomePost response posts try Catch : \(error)")
                                        }
                                    }
                                    else if let politician = obj["user"] as? JSON {
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
    
    func userSearchHistory( complition: @escaping (ResponseCallBack)) {
        let para: JSON = [:]
        Webservice.Home.userSearchHistory("\(screenType.id)").requestWith(parameter: para) { result in
            switch result {
                case .fail(let message,let code,_):
                    complition(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let data):
                    if data.code == 200 {
                        self.arrList = []
                        if let historyList = data.body?["data"] as? JSONArray {
                                for obj in historyList {
                                    if let user = obj["user"] as? JSON {
                                        do {
                                            let userData = try JSONSerialization.data(withJSONObject: user)
                                            let userModel = try JSONDecoder().decode(PostUser.self, from: userData)
                                            self.arrList.append(userModel)
                                        } catch{
                                            print("[TradPostListViewModel] getHomePost response posts try Catch : \(error)")
                                        }
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
    
    func clearHistory(user id: Int, complition: @escaping (ResponseCallBack)) {
        let para: JSON = [:]
        let queryPara = [
            "id":"\(id)",
            "type":"\(screenType.id)",
        ]
        Webservice.Home.clearHistory.requestWith(parameter: para, queryPara: queryPara) { result in
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
    
    func saveHistory(user id: Int, complition: @escaping (ResponseCallBack)) {
        let para: JSON = [:]
       
        Webservice.Home.saveHistory("\(id)").requestWith(parameter: para) { result in
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
    
    func userSearch(complition: (ResponseCallBack)? = nil) {
        guard isDataLoading == false else {return}
        
        let para: JSON = [:]
        let queryPara = ["keyword": searchString]
        Webservice.Home.userSearch.requestWith(parameter: para, queryPara: queryPara) { result in
            switch result {
                case .fail(let message,let code,_):
                    self.arrSearchList = []
                    if complition == nil {
                        self.updateViewComplition?()
                    }
                    self.isDataLoading = false
                    
                    complition?(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let data):
                    if data.code == 200 {
                        if let data = data.body?["data"] as? JSON {
                            if self.currentPage == 1 {
                                self.arrSearchList = []
                            }
                            let total = data["total"] as? Int ?? 0
                            let perPage = data["per_page"] as? Int ?? 0
                            self.totalPage = Int(CGFloat(total/perPage).rounded(.up))
                            if let userDataJson = data["data"] as? JSONArray {
                                for obj in userDataJson {
                                    do {
                                        let userData = try JSONSerialization.data(withJSONObject: obj)
                                        let userModel = try JSONDecoder().decode(PostUser.self, from: userData)
                                        self.arrSearchList.append(userModel)
                                    } catch{
                                        print("[TradPostListViewModel] getHomePost response posts try Catch : \(error)")
                                    }
                                }
                                
                            }
                        }
                        if complition == nil {
                            self.updateViewComplition?()
                        }
                        complition?(CompanComplition(message: data.message, code: data.code, status: true))
                    } else {
                        self.arrSearchList = []
                        if complition == nil {
                            self.updateViewComplition?()
                        }
                        self.isDataLoading = false
                        complition?(CompanComplition(message: data.message, code: data.code, status: false))
                    }
            }
        }
    }
    
    func acceptRequest(user id: Int,complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["request_id":id]

        Webservice.Settings.acceptRequest.requestWith(parameter: para) { result in
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
    
    func deleteRequest(user id: Int,complition: @escaping (ResponseCallBack)) {
        let para: JSON = [:]
        
        Webservice.Settings.deleteRequest("\(id)").requestWith(parameter: para) { result in
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
