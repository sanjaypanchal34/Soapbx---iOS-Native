//
//  PollsViewModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 04/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation
import OTLContaner

class PollsViewModel {
    
    let intMinOptions = 2
    let intMaxOptions = 15
    var complitionOnAddOptions:(()->())?
    var arrOptions:[String] = ["","",""] {
        didSet {
            complitionOnAddOptions?()
        }
    }
    
    var selectedTred:[TrendsModel] = [] {
        didSet {
            complitionOnAddOptions?()
        }
    }
    
    func isTredSelected(id: Int)->Bool {
        let array = selectedTred.compactMap { tred in
            if tred.id == id {
                return tred
            }
            return nil
        }
        if array.count > 0 {
            return true
        }
        return false
    }
    var currentPage = 1
    
    
    func postPoll(question: String, start date: Date, end: Date,complition: @escaping (ResponseCallBack)) {
        var para: JSON = [
            "question":question,
            "start_date": OTLDateConvert.instance.convert(date: date, toString: .yyyyMMdd_HHmm),
                "end_date": OTLDateConvert.instance.convert(date: end, toString: .yyyyMMdd_HHmm)
        ]
        let filteredOptions: [String] = arrOptions.compactMap { str in
            if str.isEmptyString {
                return nil
            }
            return str
        }
        for index in 0..<filteredOptions.count {
            para["option[\(index)]"] = filteredOptions[index]
        }
        
        for index in 0..<selectedTred.count {
            para["trends[\(index)]"] = selectedTred[index].id ?? 0
        }
        
        Webservice.Settings.addPoll.requestWith(parameter: para) { result in
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
    
    func getPolls(complition: @escaping (ResponseCallBack)) {
        let para: JSON = [:]
        let queryPara = ["page":"\(currentPage)"]
        
        Webservice.Settings.getPolls.requestWith(parameter: para, queryPara: queryPara) { result in
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
}
