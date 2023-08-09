//
//  SearchViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 04/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation


class SearchViewModel {
    
    var updateViewComplition:(()->Void)?
    var arrList:[PostUser] = []
    var arrSelectedId:[Int] = []
    private var isDataLoading: Bool = false
    var currentPage = 1 {
        didSet {
            if oldValue < currentPage {
                if isDataLoading {
                    currentPage = oldValue
                } else {
                    getPolitician()
                }
            }
        }
    }
    var totalPage: Int = 0
    var searchString = "" {
        didSet {
            
        }
    }
    
    func getPolitician(complition: (ResponseCallBack)? = nil) {
        if self.isDataLoading{
            return
        }
        let para: JSON = [ "type": 4, ]
        var queryPara = ["page": "\(currentPage)"]
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
                            if self.currentPage == 1 {
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
