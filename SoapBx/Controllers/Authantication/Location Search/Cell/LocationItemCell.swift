//
//  LocationItemCell.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit

class LocationItemCell: AppTableViewCell {

    @IBOutlet private weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.setTheme("",size: 14)
    }

    func setData(_ object: GMapResult) {
        lblTitle.text = object.formattedAddress
    }
    
}
