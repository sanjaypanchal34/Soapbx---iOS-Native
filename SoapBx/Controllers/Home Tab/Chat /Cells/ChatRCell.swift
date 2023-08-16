//
//  ChatRCell.swift
//  ultimaplayerhq
//
//  Created by AppSaint Technology on 14/03/22.
//  Copyright © 2022 Arvind Kanjariya. All rights reserved.
//

import UIKit

class ChatRCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var lblUName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblUName.roundedViewCorner(radius: 20)
    }
    
}
