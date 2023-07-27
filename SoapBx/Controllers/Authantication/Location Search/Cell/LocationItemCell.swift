//
//  LocationItemCell.swift
//  SoapBx
//
//  Created by Mac on 25/07/23.
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
