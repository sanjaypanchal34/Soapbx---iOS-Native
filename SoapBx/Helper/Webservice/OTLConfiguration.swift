//
//  OTLConfiguration.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 26/02/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

public struct CompanComplition{
      var message = ""
      var code = 0
      var status = false
      
      init(message: String, code: Int, status: Bool) {
            self.message = message
            self.code = code
            self.status = status
      }
}
typealias ResponseCallBack = (CompanComplition)->Void

public enum OTLApplicationStatus {
    case development, live, local
}

public struct OTLApplicationStatusType {
    var development: String
    var live: String
    var local: String
}

public class OTLWebserviceConfiguration {
    
    static let instance: OTLWebserviceConfiguration = OTLWebserviceConfiguration()
    
    public var privateBaseURL:OTLApplicationStatusType
    public var baseURL: String {
        switch appState {
        case .development: return privateBaseURL.development
        case .live: return privateBaseURL.live
        case .local: return privateBaseURL.local
        }
    }
    public var header: OTLStringJson
    public var appState:OTLApplicationStatus
    /// defult value of response of  message key is "message"
    public var messageKey: String = "message"
    /// defult value of response of body key is "data"
    public var bodyKey: String = "data"
    
     public init() {
        privateBaseURL = OTLApplicationStatusType(development: "http://164.90.178.223:9179/api/",
                                                  live: "https://soapbx.net/api/",
                                                  local: "http://164.90.178.223:9179/api/")
        self.header = [:]
         #if DEBUG
            appState = .live
         #else
            appState = .live
         #endif
    }
    

}
