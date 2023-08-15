//
//  Configration.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 26/02/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation
import OTLContaner
import UIKit


enum AppFont {
    case regular, medium, semibold, bold
    
    func font(size: CGFloat) -> UIFont {
        switch self {
        case .regular: return UIFont(name: "SFProDisplay-Regular.ttf", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
        case .medium: return UIFont(name: "SFProDisplay-Medium.ttf", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        case .semibold: return UIFont(name: "SFProDisplay-Semibold.ttf", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
        case .bold: return UIFont(name: "SFProDisplay-Bold.ttf", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }
}

extension UIColor{
    static let primaryBlue = UIColor.hex(toUIColor: "#0561FF") // Blue
    static let lightBlue = UIColor.hex(toUIColor: "#CDFFFF") // Blue light
    static let syneBlue = UIColor.hex(toUIColor: "#0F9DD9") // Blue light
    
    
    static let titleBlack = UIColor.hex(toUIColor: "#000000") // black
    static let titleGrey = UIColor.hex(toUIColor: "#D1D1D1") // grey
    static let disable = UIColor.hex(toUIColor: "#BABABA") // grey
    static let lightGrey = UIColor.hex(toUIColor: "#E0E0E0") // grey
    static let green = UIColor.hex(toUIColor: "#28a745") // grey
    
    static let titleRed = UIColor.hex(toUIColor: "#F1120B") // Red

    static let buttonWhite = UIColor.hex(toUIColor: "#ffffff") // white
    
    static let appYellow = UIColor.hex(toUIColor: "#FFD800")  // Yellow
    
//powderBlue: '#EBF3FF',
//msgBg: '#ECF0F6',
//lightPink: '#FFD6D5',
//yellow: '#FFD800',
//white: '#FFFFFF',
//primary: '#0561FF',
//inActiveIndicator: '#AFCCFF',
//lightText: '#D2D2D2',
//redText: '#F1120B',
//grey: '#888',
//editText: '#F2F2F2',
//darkText: '#232323',
//msgColor: '#242424',
//red: '#F1120B',
//txtBlack: 'rgba(0, 0, 0, 1)',
//disable: '#BABABA',
//shadow: '#ddd',
//trend1: '#FBBA10',
//trend2: '#E34343',
//trend3: '#0F9DD9',
//lightBlue: '#CDFFFF',
//green: '#28a745',
//bgColor: '#EAEAEA',
}
