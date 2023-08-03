//
//  LikeDislikeViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

class LikeDislikeViewModel {
    
    func likeDislike(post object: PostModel, isLike: Bool, complition: @escaping ((CompanComplition, PostModel?)-> Void)) {
        let para: JSON = ["post_id": object.id ?? 0, "type": isLike ? 1 : 2]
        
        Webservice.Home.likeDislikePost.requestWith(parameter: para) { result in
            switch result {
                case .fail(let message,let code,_):
                    complition(CompanComplition(message: message, code: code ?? 111, status: false), nil)
                case .success(let data):
                    if data.code == 200 {
                        var postObject = object
                        if isLike {
                            let likeStatus = postObject.likeStatus ?? 0
                            let likeCount = postObject.likeCount ?? 0
                            postObject.likeStatus = likeStatus == 1 ? 0 : 1
                            postObject.likeCount = likeStatus == 1 ? (likeCount - 1) : (likeCount + 1)
                            
                            if postObject.dislikeStatus == 1,
                               postObject.likeStatus == 1 {
                                postObject.dislikeStatus = 0
                                postObject.dislikeCount = (postObject.dislikeCount ?? 0) - 1
                            }
                        } else {
                            let dislikeStatus = postObject.dislikeStatus ?? 0
                            let dislikeCount = postObject.dislikeCount ?? 0
                            postObject.dislikeStatus = dislikeStatus == 1 ? 0 : 1
                            postObject.dislikeCount = dislikeStatus == 1 ? (dislikeCount - 1) : (dislikeCount + 1)
                            
                            if postObject.likeStatus == 1,
                               postObject.dislikeStatus == 1 {
                                postObject.likeStatus = 0
                                postObject.likeCount = (postObject.likeCount ?? 0) - 1
                            }
                        }
                        complition(CompanComplition(message: data.message, code: data.code, status: true), postObject)
                    } else {
                        complition(CompanComplition(message: data.message, code: data.code, status: false), nil)
                    }
            }
        }
    }
    
    func report(post id: Int, complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["post_id": id, "type": 1, "reported_by": authUser?.user?.id ?? 0]
        
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
 
    func delete(post id: Int, complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["post_id": id, "type": 1, "reported_by": authUser?.user?.id ?? 0]
        
        Webservice.Home.deletePost("\(id)").requestWith(parameter: para) { result in
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
    
    func saved(post object: PostModel, complition: @escaping ((CompanComplition, PostModel?)-> Void)) {
        let para: JSON = ["post_id": object.id ?? 0]
        
        Webservice.Home.saveUnsavePost.requestWith(parameter: para) { result in
            switch result {
                case .fail(let message,let code,_):
                    complition(CompanComplition(message: message, code: code ?? 111, status: false), nil)
                case .success(let data):
                    if data.code == 200 {
                        var newObject = object
                        let saveStatus = object.saveStatus ?? 0
                        let savedsCount = object.savedsCount ?? 0
                        newObject.saveStatus = saveStatus == 1 ? 0 : 1
                        newObject.savedsCount = saveStatus == 1 ? (savedsCount - 1) : (savedsCount + 1)
                        
                        complition(CompanComplition(message: data.message, code: data.code, status: true), newObject)
                    } else {
                        complition(CompanComplition(message: data.message, code: data.code, status: false), nil)
                    }
            }
        }
    }
    
    
    /// hide post is know as block post of users
    func blockPost(post id: Int, complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["type": 1,"blocked_id": id]
        
        Webservice.Home.blockReportUser.requestWith(parameter: para) { result in
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
