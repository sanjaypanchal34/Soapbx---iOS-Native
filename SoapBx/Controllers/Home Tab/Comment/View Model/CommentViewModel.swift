//
//  CommentViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

class CommentViewModel {
    
    var updateViewComplition:(()->Void)?
    var arrComments:[CommentModel] = []
    var objPost:PostModel?
    
    private var isDataLoading: Bool = false
    var currentPage = 1 {
        didSet {
            if self.isDataLoading == false {
                if oldValue < currentPage {
                    if isDataLoading {
                        currentPage = oldValue
                    } else {
                        getPost()
                    }
                }
            }
        }
    }
    var totalPage = 0
    
    func getPost(complition: (ResponseCallBack)? = nil) {
        if self.isDataLoading{
            return
        }
        guard let id = objPost?.id else { return }
        
        let para: JSON = [:]
        let queryPara: OTLStringJson = ["page":"\(currentPage)"]
       
        self.isDataLoading = true
        Webservice.Home.getPost("\(id)").requestWith(parameter: para, queryPara: queryPara) { result in
            switch result {
                case .fail(let message,let code,_):
                    self.arrComments = []
                    if complition == nil {
                        self.updateViewComplition?()
                    }
                    self.isDataLoading = false
                    complition?(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let data):
                    if data.code == 200 {
                        if let data = data.body?["data"] as? JSON {
                            if let post = data["post"] as? JSON {
                                do {
                                    let data = try JSONSerialization.data(withJSONObject: post)
                                    let model = try JSONDecoder().decode(PostModel.self, from: data)
                                    self.objPost = model
                                } catch{
                                    print("[TradPostListViewModel] getHomePost response posts try Catch : \(error)")
                                }
                            }
                            if self.currentPage == 1 {
                                self.arrComments = []
                            }
                            if let posts = data["comments"] as? JSON {
                                self.totalPage =  posts["total"] as? Int ?? 0
                                if let postData = posts["data"] as? JSONArray {
                                    for obj in postData {
                                        do {
                                            let data = try JSONSerialization.data(withJSONObject: obj)
                                            let model = try JSONDecoder().decode(CommentModel.self, from: data)
                                            self.arrComments.append(model)
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
                        self.arrComments = []
                        if complition == nil {
                            self.updateViewComplition?()
                        }
                        self.isDataLoading = false
                        complition?(CompanComplition(message: data.message, code: data.code, status: false))
                    }
            }
        }
    }
    
    func postComment(comment: String, complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["post_id": objPost?.id ?? 0, "comment": comment]
        
        Webservice.Home.commentOnPost.requestWith(parameter: para) { result in
            switch result {
                case .fail(let message,let code,_):
                    complition(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let data):
                    if data.code == 200 {
                        if var comment = data.body?["data"] as? JSON {
                            do {
                                comment["user"] = authUser?.user?.getJson()
                                if let postId = comment["post_id"] as? String {
                                    comment["post_id"] = Int(postId) ?? 0
                                }
                                self.objPost?.commentsCount = (self.objPost?.commentsCount ?? 0) + 1
                                let commentData = try JSONSerialization.data(withJSONObject: comment)
                                let model = try JSONDecoder().decode(CommentModel.self, from: commentData)
                                self.arrComments.insert(model, at: 0)
                            } catch {
                                print("[TradPostListViewModel] postComment try Catch : \(error)")
                            }
                        }
                        complition(CompanComplition(message: data.message, code: data.code, status: true))
                    } else {
                        complition(CompanComplition(message: data.message, code: data.code, status: false))
                    }
            }
        }
    }
    
    func report(commentId: Int, reason: String, complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["post_id": objPost?.id ?? 0,
                          "comment_id": commentId,
                          "type": 2,
                          "reason": reason]
        
        Webservice.Home.reportPostComment.requestWith(parameter: para) { result in
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
