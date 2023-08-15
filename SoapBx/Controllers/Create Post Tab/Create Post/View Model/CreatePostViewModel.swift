//
//  CreatePostViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 24/07/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation
import UIKit

class CreatePostViewModel {
    
    var arrImages: [PostImage] = []
    let maxImage = 5
    let addPolitician = "Add Politician +"
    let addTrends = "Add Trends +"
    var arrTrends: [TrendsModel] = []
    var arrPolitions: [PostUser] = []
    var postObj: PostModel?
    
    init() {
        arrTrends = [TrendsModel(name: addTrends)]
        arrPolitions = [PostUser.object(name: addPolitician)!]
    }
    
    
    func addPost(title: String , description: String , progress: @escaping ((CGFloat)->()), complition: @escaping (ResponseCallBack)) {
        var para: JSON = [
            "title": title,
            "description":description,
        ]
        let imagesMetaData: [OTLMultipartFormData] = arrImages.enumerated().compactMap { element in
            if let image = element.element.localImage,
               let data = image.jpegData(compressionQuality: 0.8) {
                return OTLMultipartFormData(name: "image[\(element.offset)]" , filename: "image[\(element.offset)]", data: data)
            }
            return nil
        }
        for trend in arrTrends.enumerated() {
            if trend.element.name != addTrends {
                para["trend[\(trend.offset)]"] = trend.element.id ?? 0
            }
        }
        
        for polition in arrPolitions.enumerated() {
            if polition.element.name != addPolitician {
                para["politician[\(polition.offset)]"] = polition.element.id ?? 0
            }
        }
        
        
        Webservice.Post.addPost.requestWith(multipart: imagesMetaData, parameter: para) { progressValue in
            progress(progressValue)
        } completion: { result in
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
    
    func deleteImage(image id: Int,complition: @escaping (ResponseCallBack)) {
        let para: JSON = [:]
        
        Webservice.Post.deleteImage("\(id)").requestWith(parameter: para) { result in
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
    
    func updatePost(title: String , description: String , progress: @escaping ((CGFloat)->()), complition: @escaping (ResponseCallBack)) {
        var para: JSON = [
            "post_id": postObj?.id ?? 0,
            "title": title,
            "description":description,
        ]
        let imagesMetaData: [OTLMultipartFormData] = arrImages.enumerated().compactMap { element in
            if let image = element.element.localImage,
                let data = image.jpegData(compressionQuality: 0.8) {
                return OTLMultipartFormData(name: "image[\(element.offset)]" , filename: "image[\(element.offset)]", data: data)
            }
            return nil
        }
        for trend in arrTrends.enumerated() {
            if trend.element.name != addTrends {
                para["trend[\(trend.offset)]"] = trend.element.id ?? 0
            }
        }
        
        for polition in arrPolitions.enumerated() {
            if polition.element.name != addPolitician {
                para["politician[\(polition.offset)]"] = polition.element.id ?? 0
            }
        }
        
        
        Webservice.Post.editPost.requestWith(multipart: imagesMetaData, parameter: para) { progressValue in
            progress(progressValue)
        } completion: { result in
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
