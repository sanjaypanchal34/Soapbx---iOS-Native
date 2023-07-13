//
//  SubscribeNotesModel.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import Foundation

struct SubscribeNotesModel {
    let title: String
    let freemium: String
    let premium: String
    let canSymbol: Bool
    let isFreemiumSelected: Bool = true
    
    init(title: String, freemium: String, premium: String, canSymbol: Bool = true) {
        self.title = title
        self.freemium = freemium
        self.premium = premium
        self.canSymbol = canSymbol
    }
    
}

struct SubscribeModel {
    let title: String
    let subtitle: String
    var isSelected: Bool = true
    
    init(title: String, subtitle: String, isSelected: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
    }
}
