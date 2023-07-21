//
//  ThreeDotItemModel.swift
//  SoapBx
//
//  Created by Mac on 16/07/23.
//

import Foundation


struct ThreeDotItemModel {
    var title: ThreeDotItem
    var icon: String
}

enum ThreeDotItem {
    case openProfile, hidePost(String), share, report, edit, delete
    
    var title: String {
        switch self {
        case .openProfile:  return "Open User Profile"
        case .hidePost(let profileName):  return "Hide Post by \(profileName)"
        case .share:    return "Share"
        case .report:   return "Report"
        case .edit: return "Edit Post"
        case .delete:   return "Delete Post"
        }
    }
}
