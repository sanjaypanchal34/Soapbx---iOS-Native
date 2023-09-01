//
//  FollowFollowingViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 15/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

class FollowFollowingViewModel {
    
    var currentTabIndex = FollowFolloingType.followers {
        didSet {
            page = 1
        }
    }
    var updateViewComplition:(()->Void)?
    var arrList:[PostUser] = []
    private var isDataLoading: Bool = false
    private var page: Int = 1 {
        didSet {
            showLoader()
            if currentTabIndex == .followers {
                getFollowersOfUser()
            }
            else if currentTabIndex == .following {
                getFollowingOfUser()
            }
            else if currentTabIndex == .politicians {
                getPoliticiansOfUser()
            }
        }
    }
    var currentPage: Int {
        set {
            if self.isDataLoading == false {
                if newValue > currentPage {
                    page = newValue
                }
            }
        }
        get { page }
    }
    var totalPage: Int = 0
    var userObj: PostUser?
    
    func getFollowingOfUser(complition: (ResponseCallBack)? = nil) {
        if self.isDataLoading{
            return
        }
        let para: JSON = [:]
        var queryPara: OTLStringJson = ["page":"\(page)"]
        
        self.isDataLoading = true
        Webservice.Post.getFollowingOfUser("\(userObj?.id ?? 0)").requestWith(parameter: para, queryPara: queryPara) { result in
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
                        if self.page == 1 {
                            self.arrList = []
                        }
                        if let data = data.body?["data"] as? JSON {
                            let total = data["total"] as? Int ?? 0
                            let perPage = data["per_page"] as? Int ?? 0
                            self.totalPage = Int(CGFloat(total/perPage).rounded(.up))
                            if let postData = data["data"] as? JSONArray {
                                for obj in postData {
                                    if let politician = obj["user"] as? JSON {
                                        do {
                                            let politicianData = try JSONSerialization.data(withJSONObject: politician)
                                            let model = try JSONDecoder().decode(PostUser.self, from: politicianData)
                                            self.arrList.append(model)
                                        } catch{
                                            print("[ProfileViewModel] getHomePost response posts try Catch : \(error)")
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
    
    func getFollowersOfUser(complition: (ResponseCallBack)? = nil) {
        if self.isDataLoading{
            return
        }
        let para: JSON = [:]
        var queryPara: OTLStringJson = ["page":"\(page)"]
        
        self.isDataLoading = true
        Webservice.Post.getFollowersOfUser("\(userObj?.id ?? 0)").requestWith(parameter: para, queryPara: queryPara) { result in
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
                        if self.page == 1 {
                            self.arrList = []
                        }
                        if let data = data.body?["data"] as? JSON {
                            let total = data["total"] as? Int ?? 0
                            let perPage = data["per_page"] as? Int ?? 0
                            self.totalPage = Int(CGFloat(total/perPage).rounded(.up))
                            if let postData = data["data"] as? JSONArray {
                                for obj in postData {
                                    if let politician = obj["follower"] as? JSON {
                                        do {
                                            let politicianData = try JSONSerialization.data(withJSONObject: politician)
                                            let model = try JSONDecoder().decode(PostUser.self, from: politicianData)
                                            self.arrList.append(model)
                                        } catch{
                                            print("[ProfileViewModel] getHomePost response posts try Catch : \(error)")
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
    
    func getPoliticiansOfUser(complition: (ResponseCallBack)? = nil) {
        if self.isDataLoading{
            return
        }
        let para: JSON = [:]
        var queryPara: OTLStringJson = ["page":"\(page)"]
        
        self.isDataLoading = true
        Webservice.Post.getPoliticiansOfUser("\(userObj?.id ?? 0)").requestWith(parameter: para, queryPara: queryPara) { result in
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
                        if self.page == 1 {
                            self.arrList = []
                        }
                        if let data = data.body?["data"] as? JSON {
                            let total = data["total"] as? Int ?? 0
                            let perPage = data["per_page"] as? Int ?? 0
                            self.totalPage = Int(CGFloat(total/perPage).rounded(.up))
                            if let postData = data["data"] as? JSONArray {
                                for obj in postData {
                                    if let politician = obj["politician"] as? JSON {
                                        do {
                                            let politicianData = try JSONSerialization.data(withJSONObject: politician)
                                            let model = try JSONDecoder().decode(PostUser.self, from: politicianData)
                                            self.arrList.append(model)
                                        } catch{
                                            print("[ProfileViewModel] getHomePost response posts try Catch : \(error)")
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
}
