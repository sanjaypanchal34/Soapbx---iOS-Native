//
//
// PaymentCell.swift
// SoapBx
//
// Created by Arvind Kanjariya on 01/09/23
//
        

import UIKit

class PaymentCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSTitle: UILabel!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPurchase: UILabel!
    @IBOutlet weak var vwMain: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwMain.roundedViewCorner(radius: 10)
        vwMain.layer.borderColor = UIColor.lightGray.cgColor
        vwMain.layer.borderWidth = 0.5
    }
    
}
