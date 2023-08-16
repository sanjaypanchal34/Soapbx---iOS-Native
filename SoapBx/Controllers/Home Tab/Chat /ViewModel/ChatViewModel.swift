//
//  ChatViewModel.swift
//  SoapBx
//
//  Created by AppSaint Technology on 16/08/23.
//

import Foundation

class ChatViewModel {
    var relationId: Int = 0
    var updateViewComplition:(()->Void)?
    var arrList:[ChatModel] = []
    var totalPage: Int = 0
    
    private var isDataLoading: Bool = false
    var currentPage = 1 {
        didSet {
            if self.isDataLoading == false {
                if oldValue < currentPage{
                    if isDataLoading {
                        currentPage = oldValue
                    } else {
                        showLoader()
                        getMessage(relationId: 1)
                    }
                }
            }
        }
    }
    
    func sendMessage(relationId relationId: String, sender sId: String, receiver rId: String, message msg: String, complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["chat_relation_id":relationId, "sender_id" : sId, "receiver_id" : rId, "message" : msg, "type" : "0"]
        Webservice.Chat.sendMessage.requestWith(parameter: para) { result in
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
    
    func getMessage(relationId relationId: Int, complition: (ResponseCallBack)? = nil) {
        self.relationId = relationId
        if self.isDataLoading{
            return
        }
        
        let para: JSON = [:]
        let queryPara: OTLStringJson = ["page":"\(currentPage)"]
        self.isDataLoading = true
        Webservice.Chat.userChat(String(format: "%d", relationId)).requestWith(parameter: para, queryPara: queryPara) { result in
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
                        if let d = data.body?["data"] as? JSON {
                            if let mData = d["message"] as? JSON {
                                let total = mData["total"] as? Int ?? 0
                                let perPage = mData["per_page"] as? Int ?? 0
                                self.totalPage = Int(CGFloat(total/perPage).rounded(.up))
                                
                                if self.currentPage == 1 {
                                    self.arrList = []
                                }
                                
                                if let messageData = mData["data"] as? JSONArray {
                                    print(messageData.count)
                                    for obj in messageData {
                                        if let mData = obj as? JSON {
                                            let id: Int = (mData["id"] as? Int)!
                                            let chat_relation_id: Int = (mData["chat_relation_id"] as? Int)!
                                            let sender_id: Int = (mData["sender_id"] as? Int)!
                                            let receiver_id: Int = (mData["receiver_id"] as? Int)!
                                            let message: String = (mData["message"] as? String)!
                                            var sName: String = ""
                                            var sImage: String = ""
                                            var rName: String = ""
                                            var rImage: String = ""
                                            if let s = mData["sender"] as? JSON {
                                                sName = (mData["full_name"] as? String)!
                                                sImage = (mData["profile_photo"] as? String)!
                                            }
                                            if let s = mData["receiver"] as? JSON {
                                                rName = (mData["full_name"] as? String)!
                                                rImage = (mData["profile_photo"] as? String)!
                                            }
                                            
                                            let model: ChatModel = .init(id: id, chat_relation_id: chat_relation_id, sender_id: sender_id, receiver_id: receiver_id, message: message, sName: sName, sImage: sImage, rName: rName, rImage: rImage)
                                            self.arrList.append(model)
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
                            if complition == nil {
                                self.updateViewComplition?()
                            }
                            self.isDataLoading = false
                            complition?(CompanComplition(message: data.message, code: data.code, status: false))
                        }
                      
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
