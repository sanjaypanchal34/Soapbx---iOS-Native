//
//  NotificationSettingItemCell.swift
//  SoapBx
//
//  Created by Mac on 19/07/23.
//

import UIKit
protocol NotificationSettingDelegate {
    func notificationSetting(_ cell : NotificationSettingItemCell, switch togale: Bool)
}
class NotificationSettingItemCell: AppTableViewCell {

    @IBOutlet private weak var lblTitle:UILabel!
    @IBOutlet private weak var switchTogale:UISwitch!
    
    private var delegate: NotificationSettingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.setTheme("")
        switchTogale.onTintColor = .primaryBlue
        switchTogale.tintColor = .titleGrey
    }

    func setData(_ object: NotificationSettingModel, indexPath: IndexPath, delegate: NotificationSettingDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        lblTitle.text = object.title
        switchTogale.isOn = object.isSelected
    }
        
    func updateData(_ object: NotificationSettingModel) {
        lblTitle.text = object.title
        switchTogale.isOn = object.isSelected
    }
    
    @IBAction private func valueChange() {
        delegate?.notificationSetting(self, switch: switchTogale.isOn)
    }
}
