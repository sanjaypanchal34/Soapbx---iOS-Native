//
//
// NotificationViewModel.swift
// SoapBx
//
// Created by Arvind Kanjariya on 31/08/23
//
        

import Foundation

class NotificationViewModel {
    
    var arrList:[NotificationModel] = []
    var updateViewComplition:(()->Void)?
    
    func getNotifications(complition: (ResponseCallBack)? = nil) {
        
        let para: JSON = [:]
        Webservice.Profile.notificationList.requestWith(parameter: para) { result in
            switch result {
                case .fail(let message,let code,_):
                    self.arrList = []
                    if complition == nil {
                        self.updateViewComplition?()
                    }
                    complition?(CompanComplition(message: message, code: code ?? 111, status: false))
                case .success(let data):
                    if data.code == 200 {
                        if let d = data.body?["data"] as? JSONArray {
                                    print(d.count)
                                    for obj in d {
                                        if let mData = obj as? JSON {
                                            let id: Int = (mData["id"] as? Int)!
                                            let user_id: Int = (mData["user_id"] as? Int)!
                                            let sender_id: Int = (mData["sender_id"] as? Int)!
                                            let title: String = (mData["title"] as? String)!
                                            let description: String = (mData["description"] as? String)!
                                            let notification_type: String = (mData["notification_type"] as? String)!
                                            let read_status: String = (mData["read_status"] as? String)!
                                            let created_at: String = (mData["created_at"] as? String)!
                                            
                                            let model: NotificationModel = .init(id: id, user_id: user_id, sender_id: sender_id, title: title, description: description, notification_type: notification_type, read_status: read_status, created_at: created_at)
                                            self.arrList.append(model)
                                        }
                                    }
                                
                            
                            if complition == nil {
                                self.updateViewComplition?()
                            }
                            complition?(CompanComplition(message: data.message, code: data.code, status: true))
                        
                        } else {
                            if complition == nil {
                                self.updateViewComplition?()
                            }
                            complition?(CompanComplition(message: data.message, code: data.code, status: false))
                        }
                      
                    } else {
                        self.arrList = []
                        if complition == nil {
                            self.updateViewComplition?()
                        }
                        complition?(CompanComplition(message: data.message, code: data.code, status: false))
                    }
            }
        }
    }
    
}
