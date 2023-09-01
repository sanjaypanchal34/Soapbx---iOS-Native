//
//
// MessageListCell.swift
// SoapBx
//
// Created by Arvind Kanjariya on 01/09/23
//
        

import UIKit

class MessageListCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var lblUName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwMessage.roundedViewCorner(radius: 5)
        vwMessage.layer.borderColor = UIColor.lightGray.cgColor
        vwMessage.layer.borderWidth = 0.5
        imgUser.roundedViewCorner(radius: 25)
        imgUser.clipsToBounds = true
    }
}
