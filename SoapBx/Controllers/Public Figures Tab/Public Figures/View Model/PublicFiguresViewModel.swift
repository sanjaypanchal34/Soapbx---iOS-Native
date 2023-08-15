//
//  PublicFiguresViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 15/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation


class PublicFiguresViewModel {
    
    var updateViewComplition:(()->Void)?
    var arrList:[PostUser] = []
    private var isDataLoading: Bool = false
    var currentPage = 1 {
        didSet {
            if self.isDataLoading == false {
                if oldValue < currentPage{
                    if isDataLoading {
                        currentPage = oldValue
                    } else {
                        showLoader()
                        politicianList()
                    }
                }
            }
        }
    }
    var isSearch: Bool {
        get { return searchString.count > 0}
    }
    var searchString = "" {
        didSet {
            if searchString.count > 2 {
                politicianList(search: searchString)
            } else {
                updateViewComplition?()
            }
        }
    }
    
    var totalPage: Int = 0
    
    func politicianList(search: String = "", complition: (ResponseCallBack)? = nil) {
        if self.isDataLoading{
            return
        }
        let para: JSON = [:]
        let queryPara: OTLStringJson = ["page":"\(currentPage)", "keyword": search]
        
        self.isDataLoading = true
        Webservice.Profile.politicianList.requestWith(parameter: para, queryPara: queryPara) { result in
            switch result {
                case .fail(let message,let code,_):
                    self.arrList = []
                    if complition == nil {
                        self.updateViewComplition?()
                    }
                    self.isDataLoading = false
                    complition?(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let response):
                    if response.code == 200 {
                        if let data = response.body?["data"] as? JSON {
                            let total = data["total"] as? Int ?? 0
                            let perPage = data["per_page"] as? Int ?? 0
                            self.totalPage = Int(CGFloat(total/perPage).rounded(.up))
                            
                            if self.currentPage == 1 {
                                self.arrList = []
                            }
                            if let postData = data["data"] as? JSONArray {
                                for obj in postData {
                                    do {
                                        let data = try JSONSerialization.data(withJSONObject: obj)
                                        let model = try JSONDecoder().decode(PostUser.self, from: data)
                                        self.arrList.append(model)
                                    } catch{
                                        print("[TradPostListViewModel] getHomePost response posts try Catch : \(error)")
                                    }
                                }
                                
                            }
                            if complition == nil {
                                self.updateViewComplition?()
                            }
                            self.isDataLoading = false
                            complition?(CompanComplition(message: response.message, code: response.code, status: true))
                        }
                        else {
                            self.arrList = []
                            if complition == nil {
                                self.updateViewComplition?()
                            }
                            self.isDataLoading = false
                            complition?(CompanComplition(message: response.message, code: response.code, status: false))
                        }
                    } else {
                        self.arrList = []
                        if complition == nil {
                            self.updateViewComplition?()
                        }
                        self.isDataLoading = false
                        complition?(CompanComplition(message: response.message, code: response.code, status: false))
                    }
            }
        }
    }
    
}
