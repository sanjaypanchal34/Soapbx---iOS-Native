//
//  SettingItemCell.swift
//  SoapBx
//
//  Created by Arvind Kanjariya on 19/07/23.
//

import UIKit

class LanguageItemCell: AppTableViewCell {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var imgLeftArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTitle.setTheme("")
        imgLeftArrow.image = UIImage(named: "ic_radioSelected")
    }
    
    func setData(_ object: ChangeLangModel) {
        let lang = UserDefaults.standard.string(forKey: OTLAppKey.Language) ?? "en"
        if lang == object.value {
            imgLeftArrow.isHidden = false
        } else {
            imgLeftArrow.isHidden = true
        }
        lblTitle.text = object.title
    }
    
}
