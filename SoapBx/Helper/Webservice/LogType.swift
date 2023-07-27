//
//  LogType.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by 200OK-IOS1 on 26/02/2019.
//  Copyright © 2021 200OK-IOS1. All rights reserved.
//

import Foundation

enum LogType {
    case all, api_all, api_request, api_response, api_failure, api_uplodingPrograss
}

let isLogDisplay = true
let apiLogDisplayType = LogType.api_all
func printLog(_ string:Any = "", separator: String = "" , log type: LogType = .all) {
    #if DEBUG
    func getDateToString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = .current
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: Date())
    }
    let bundleIdentifier = String(describing: Bundle.main.bundleIdentifier)
    if isLogDisplay {
        if separator.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            switch type {
            case .all:
                print("\(getDateToString()) [\(bundleIdentifier)] : \(String(describing: string))")
            case .api_all, .api_request, .api_failure, .api_uplodingPrograss:
                if apiLogDisplayType == type || apiLogDisplayType == .api_all {
                    print("\(getDateToString()) [\(bundleIdentifier)] : \(String(describing: string))")
                }
            case .api_response:
                print("\(getDateToString()) [\(bundleIdentifier)] : \(String(describing: string))")
            }
        } else {
            print("\(getDateToString()) [\(bundleIdentifier)] : \(String(describing: string))")
        }
    }
    #endif
}


