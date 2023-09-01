//
//
// MessageViewModel.swift
// SoapBx
//
// Created by Arvind Kanjariya on 01/09/23
//
        

import Foundation

class MessageViewModel {
    var updateViewComplition:(()->Void)?
    var arrList:[MessageModel] = []
    var totalPage: Int = 0
    var uniqueId: Int = 0
    var relationId: Int = 0
    
    private var isDataLoading: Bool = false
    var currentPage = 1 {
        didSet {
            if self.isDataLoading == false {
                if oldValue < currentPage{
                    if isDataLoading {
                        currentPage = oldValue
                    } else {
                        showLoader()
                        getUserChatList()
                    }
                }
            }
        }
    }
    
    func getUserChatList(complition: (ResponseCallBack)? = nil) {
        if self.isDataLoading{
            return
        }
        
        let para: JSON = [:]
        let queryPara: OTLStringJson = ["page":"\(currentPage)"]
        self.isDataLoading = true
        Webservice.Chat.chatList.requestWith(parameter: para, queryPara: queryPara) { result in
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
                            
                                let total = d["total"] as? Int ?? 0
                                let perPage = d["per_page"] as? Int ?? 0
                                self.totalPage = Int(CGFloat(total/perPage).rounded(.up))
                                
                                if self.currentPage == 1 {
                                    self.arrList = []
                                }
                                
                                if let messageData = d["data"] as? JSONArray {
                                    print(messageData.count)
                                    for obj in messageData {
                                        if let mData = obj as? JSON {
                                            var uniqueId: Int = 0
                                            var chat_relation_id: Int = 0
                                            var sender_id: Int = (mData["user_id"] as? Int)!
                                            var receiver_id: Int = (mData["send_id"] as? Int)!
                                            var message: String = ""
                                            var sName: String = (mData["user_name"] as? String)!
                                            var rName: String = (mData["send_name"] as? String)!
                                            var rImage: String = ""
                                            var created_at: String = ""
                                            
                                            if let mObj = mData["message"] as? JSON {
                                                chat_relation_id = (mObj["chat_relation_id"] as? Int)!
                                                message = (mObj["message"] as? String)!
                                                created_at = (mObj["created_at"] as? String)!
                                            }
                                            
                                            if let r = mData["sender"] as? JSON {
                                                rImage = (r["profile_photo_url"] as? String)!
                                            }
                                            let model: MessageModel = .init(uniqueId: uniqueId, chat_relation_id: chat_relation_id, sender_id: sender_id, receiver_id: receiver_id, message: message, sName: sName, rName: rName, rImage: rImage, created_at: created_at)
                                            self.arrList.append(model)
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
    
    func message(user id: Int, complition: @escaping (ResponseCallBack)) {
        let para: JSON = ["user_id": id, "status_user" : "1"]
        Webservice.Chat.startChat.requestWith(parameter: para) { result in
            switch result {
                case .fail(let message,let code,_):
                    complition(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let data):
                    if data.code == 200 {
                        if let data = data.body?["data"] as? JSON {
                            if let uID = data["unique"] as? Int {
                                self.uniqueId = uID
                            }
                            
                            if let rID = data["id"] as? Int {
                                self.relationId = rID
                            }
                        }
                        complition(CompanComplition(message: data.message, code: data.code, status: true))
                    } else {
                        complition(CompanComplition(message: data.message, code: data.code, status: false))
                    }
            }
        }
    }
}
