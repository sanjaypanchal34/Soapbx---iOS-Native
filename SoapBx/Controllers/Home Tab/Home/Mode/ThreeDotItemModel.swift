//
//  ThreeDotItemModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation


struct ThreeDotItemModel {
    var title: ThreeDotItem
    var icon: String
}

enum ThreeDotItem {
    case openProfile, hidePost(String), share, report, edit, delete, clearChat, starredMessage, block
    
    var title: String {
        switch self {
        case .openProfile:  return LocalStrings.DOT_OPEN.rawValue.addLocalizableString()
        case .hidePost(let profileName):  return String(format: "%@%@", LocalStrings.DOT_HIDE.rawValue.addLocalizableString(), profileName)
        case .share:    return LocalStrings.DOT_SHARE.rawValue.addLocalizableString()
        case .report:   return LocalStrings.DOT_REPORT.rawValue.addLocalizableString()
        case .edit: return LocalStrings.DOT_EDIT.rawValue.addLocalizableString()
        case .delete:   return LocalStrings.DOT_DELETE.rawValue.addLocalizableString()
        case .clearChat: return LocalStrings.DOT_CLEAR.rawValue.addLocalizableString()
        case .starredMessage: return LocalStrings.DOT_STAR.rawValue.addLocalizableString()
        case .block:  return LocalStrings.DOT_BLOCK.rawValue.addLocalizableString()
        }
    }
}
