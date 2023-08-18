//
//  PollListSubitemCell.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 15/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit

class PollListSubitemCell: AppTableViewCell {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.cornerRadius = lblTitle.frame.height/2
        viewMain.layer.borderColor = UIColor.black.cgColor
        viewMain.layer.borderWidth = 1
        
        lblTitle.setTheme("", font: .bold, size: 16, lines: 1)
        lblTitle.textAlignment = .center
        
        lblCount.setTheme("", size: 16, lines: 1)
    }

    func setTitle(_ object: Option, percent: JSON) {
        lblTitle.text = object.option
        viewMain.backgroundColor = object.selectStatus == 1 ? .primaryBlue : .white
        lblTitle.textColor = object.selectStatus == 1 ? .white : .black
        lblCount.textColor = object.selectStatus == 1 ? .white : .black
        
        lblCount.text = ""
        if let percent = percent["\(object.id ?? 0)"] as? DoubleCast {
            lblCount.text = "\(percent.stringValue ?? "")%"
        }
    }
    
}
