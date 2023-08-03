//
//  SavedPostViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

class SavedPostViewModel {
    
    var updateViewComplition:(()->Void)?
    private var isDataLoading: Bool = false
    var arrPosts:[PostModel] = []
    var currentPage = 1 {
        didSet {
            if oldValue < currentPage {
                if isDataLoading {
                    currentPage = oldValue
                } else {
                    getSavedPosts()
                }
            }
        }
    }
    var totalPage = 0
    
    
    func getSavedPosts(complition: (ResponseCallBack)? = nil) {
        if self.isDataLoading{
            return
        }
        let para: JSON = [:]
        self.isDataLoading = true
        Webservice.Settings.getSavedPosts.requestWith(parameter: para) { result in
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
                            
                            if self.currentPage == 1 {
                                self.arrPosts = []
                            }
                            self.totalPage =  data["total"] as? Int ?? 0
                            if let postData = data["data"] as? JSONArray {
                                for obj in postData {
                                    if let post = obj["post"] as? JSON {
                                        do {
                                            let postData = try JSONSerialization.data(withJSONObject: post)
                                            let postModel = try JSONDecoder().decode(PostModel.self, from: postData)
                                            self.arrPosts.append(postModel)
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
}
