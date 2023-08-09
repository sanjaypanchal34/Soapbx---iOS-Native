//
//  TradPostListViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

class TradPostListViewModel {
    
    var viewType:TradPostListViewType = .fromHome
    var updateViewComplition:(()->Void)?
    var arrTernds:[TrendsModel] = [TrendsModel(name: "All Trends")]
    var selectedTerndsIndex = 0 {
        didSet {
            if oldValue != selectedTerndsIndex, viewType == .fromHome {
                arrPosts = []
                currentPage = 1
                totalPage = 0
                showLoader()
                getPost()
            }
        }
    }
    let arrTerndsColor: [String] = ["#FBBA10", "#E34343", "#0F9DD9", "#FBBA10" ]
    var arrPosts:[PostModel] = []
    private var isDataLoading: Bool = false
    var currentPage = 1 {
        didSet {
            if oldValue < currentPage, viewType == .fromHome {
                if isDataLoading {
                    currentPage = oldValue
                } else {
                    showLoader()
                    getPost()
                }
            }
        }
    }
    var totalPage: Int = 0
    
    func getPost(complition: (ResponseCallBack)? = nil) {
        guard viewType == .fromHome else{ return }
        if self.isDataLoading{
            return
        }
        let para: JSON = [:]
        var queryPara: OTLStringJson = ["page":"\(currentPage)"]
        if selectedTerndsIndex > 0, let trendId = arrTernds[selectedTerndsIndex].id {
            queryPara["trend"] = "\(trendId)"
        }
        self.isDataLoading = true
        Webservice.Home.getHomePost.requestWith(parameter: para, queryPara: queryPara) { result in
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
                            if let trends = data["trends"] as? JSONArray {
                                self.arrTernds = [TrendsModel(name: "All Trends")]
                                for obj in trends {
                                    do {
                                        let data = try JSONSerialization.data(withJSONObject: obj)
                                        let model = try JSONDecoder().decode(TrendsModel.self, from: data)
                                        self.arrTernds.append(model)
                                    } catch{
                                        print("[TradPostListViewModel] getHomePost response trends try Catch : \(error)")
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
