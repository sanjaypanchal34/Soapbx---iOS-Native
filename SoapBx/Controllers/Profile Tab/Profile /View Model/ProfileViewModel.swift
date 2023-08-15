    //
    //  ProfileViewModel.swift
    //  Operators Techno Lab, Ahmedabad
    //
    //  Developed by Harsh Kadiya
    //  Created by OTL-HK on 04/08/2023.
    //  Copyright © 2023 OTL-HK. All rights reserved.
    //

import Foundation

class ProfileViewModel {
    
    var updateViewComplition:(()->Void)?
    var arrTernds:[TrendsModel] = [TrendsModel(name: "All Trends")]
    var selectedTerndsIndex = 0 {
        didSet {
            if oldValue != selectedTerndsIndex {
                arrPosts = []
                currentPage = 1
                totalPage = 0
                getProfile()
            }
        }
    }
    let arrTerndsColor: [String] = ["#FBBA10", "#E34343", "#0F9DD9", "#FBBA10" ]
    var arrPosts:[PostModel] = []
    private var isDataLoading: Bool = false
    var currentPage = 1 {
        didSet {
            if self.isDataLoading == false {
                if oldValue < currentPage {
                    if isDataLoading {
                        currentPage = oldValue
                    } else {
                        getProfile()
                    }
                }
            }
        }
    }
    var totalPage: Int = 0
    var userObj: PostUser?
    var notificationModel = UserNotificationModel()
    
    func getProfile(complition: (ResponseCallBack)? = nil) {
        if self.isDataLoading{
            return
        }
        let para: JSON = [:]
        var queryPara: OTLStringJson = ["page":"\(currentPage)"]
        if selectedTerndsIndex > 0, let trendId = arrTernds[selectedTerndsIndex].id {
            queryPara["trend"] = "\(trendId)"
        }
        self.isDataLoading = true
        Webservice.Profile.getProfile.requestWith(parameter: para, queryPara: queryPara) { result in
            switch result {
                case .fail(let message,let code,_):
                    self.arrPosts = []
                    if complition == nil {
                        self.updateViewComplition?()
                    }
                    self.isDataLoading = false
                    complition?(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let data):
                    if data.code == 200 {
                        if let data = data.body?["data"] as? JSON {
                            if let userDetail = data["detail"] as? JSON{
                                authUser = AuthorizedUser(userDetail)
                                do {
                                    let useProfileData = try JSONSerialization.data(withJSONObject: userDetail)
                                    self.userObj = try JSONDecoder().decode(PostUser.self, from: useProfileData)
                                }catch{
                                    print("[ProfileViewModel] getHomePost response trends try Catch : \(error)")
                                }
                                if let notification = userDetail["notification"] as? JSON{
                                    do {
                                        let notificationData = try JSONSerialization.data(withJSONObject: notification)
                                        self.notificationModel = try JSONDecoder().decode(UserNotificationModel.self, from: notificationData)
                                    } catch{
                                        print("[ProfileViewModel] getHomePost response trends try Catch : \(error)")
                                    }
                                }
                            }
                            
                            if let trends = data["trends"] as? JSONArray {
                                self.arrTernds = [TrendsModel(name: "All Trends")]
                                for obj in trends {
                                    do {
                                        let data = try JSONSerialization.data(withJSONObject: obj)
                                        let model = try JSONDecoder().decode(TrendsModel.self, from: data)
                                        self.arrTernds.append(model)
                                    } catch{
                                        print("[ProfileViewModel] getHomePost response trends try Catch : \(error)")
                                    }
                                }
                            }
                            if self.currentPage == 1 {
                                self.arrPosts = []
                            }
                            if let posts = data["posts"] as? JSON {
                                let total = posts["total"] as? Int ?? 0
                                let perPage = posts["per_page"] as? Int ?? 0
                                self.totalPage = Int(CGFloat(total/perPage).rounded(.up))
                                if let postData = posts["data"] as? JSONArray {
                                    for obj in postData {
                                        do {
                                            let data = try JSONSerialization.data(withJSONObject: obj)
                                            let model = try JSONDecoder().decode(PostModel.self, from: data)
                                            self.arrPosts.append(model)
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
                        self.arrPosts = []
                        if complition == nil {
                            self.updateViewComplition?()
                        }
                        self.isDataLoading = false
                        complition?(CompanComplition(message: data.message, code: data.code, status: false))
                    }
            }
        }
    }
    
    func getOtherProfile(complition: (ResponseCallBack)? = nil) {
        if self.isDataLoading{
            return
        }
        let para: JSON = [:]
        var queryPara: OTLStringJson = ["page":"\(currentPage)"]
        if selectedTerndsIndex > 0, let trendId = arrTernds[selectedTerndsIndex].id {
            queryPara["trend"] = "\(trendId)"
        }
        self.isDataLoading = true
        Webservice.Profile.getPoliticianOrUser("\(userObj?.id ?? 0)").requestWith(parameter: para, queryPara: queryPara) { result in
            switch result {
                case .fail(let message,let code,_):
                    self.arrPosts = []
                    if complition == nil {
                        self.updateViewComplition?()
                    }
                    self.isDataLoading = false
                    complition?(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let data):
                    if data.code == 200 {
                        if let data = data.body?["data"] as? JSON {
                            if let useProfile = data["details"] as? JSON{
                                do {
                                    let useProfileData = try JSONSerialization.data(withJSONObject: useProfile)
                                    self.userObj = try JSONDecoder().decode(PostUser.self, from: useProfileData)
                                }catch{
                                    print("[ProfileViewModel] getHomePost response trends try Catch : \(error)")
                                }
                            }
                            
                            if let trends = data["trends"] as? JSONArray {
                                self.arrTernds = [TrendsModel(name: "All Trends")]
                                for obj in trends {
                                    do {
                                        let data = try JSONSerialization.data(withJSONObject: obj)
                                        let model = try JSONDecoder().decode(TrendsModel.self, from: data)
                                        self.arrTernds.append(model)
                                    } catch{
                                        print("[ProfileViewModel] getHomePost response trends try Catch : \(error)")
                                    }
                                }
                            }
                            if self.currentPage == 1 {
                                self.arrPosts = []
                            }
                            if let posts = data["posts"] as? JSON {
                                let total = posts["total"] as? Int ?? 0
                                let perPage = posts["per_page"] as? Int ?? 0
                                self.totalPage = Int(CGFloat(total/perPage).rounded(.up))
                                if let postData = posts["data"] as? JSONArray {
                                    for obj in postData {
                                        do {
                                            let data = try JSONSerialization.data(withJSONObject: obj)
                                            let model = try JSONDecoder().decode(PostModel.self, from: data)
                                            self.arrPosts.append(model)
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
                        self.arrPosts = []
                        if complition == nil {
                            self.updateViewComplition?()
                        }
                        self.isDataLoading = false
                        complition?(CompanComplition(message: data.message, code: data.code, status: false))
                    }
            }
        }
    }
    
    func updateNotification(_ notification: NotificationSettingModel, complition: @escaping (ResponseCallBack)) {
        let para: JSON = [
            "notification_status": notification.isSelected ? 1 : 0,
            "type":notification.id]
        Webservice.Profile.notificationStatus.requestWith(parameter: para) { result in
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
    
    func follow(user id: Int, user role: Int, complition: @escaping (ResponseCallBack)) {
        if role == 3 {
            let para: JSON = ["politician_id": id]
            Webservice.Profile.followPolitician.requestWith(parameter: para) { result in
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
        else {
            let para: JSON = ["request_id": id]
            Webservice.Profile.sendFollowRequest.requestWith(parameter: para) { result in
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
    
    func unfollow(user id: Int, isRemove: Bool = false, complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["user_id": id, "type": isRemove ? 2 : 1]
        Webservice.Profile.unfollowRemoveUser.requestWith(parameter: para) { result in
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
