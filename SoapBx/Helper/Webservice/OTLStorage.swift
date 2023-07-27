//
//  OTLStorage.swift
//  OTLContaner
//
//  Created by Mac on 24/07/23.
//

import Foundation

class OTLStorage {
    
    var isUserFirstTime: Bool {
        get {
            if let count = UserDefaults.standard.object(forKey: "OTL_AppOpenCount") as? Int {
                if count > 0 {
                    return true
                }
                return false
            } else {
                UserDefaults.standard.set(0, forKey: "OTL_AppOpenCount")
                UserDefaults.standard.synchronize()
                return false
            }
        }
    }
    
    var AppOpenCount: Int {
        get {
            if let count = UserDefaults.standard.object(forKey: "OTL_AppOpenCount") as? Int {
                return count
            } else {
                UserDefaults.standard.set(0, forKey: "OTL_AppOpenCount")
                UserDefaults.standard.synchronize()
                return 0
            }
        }
    }
}
