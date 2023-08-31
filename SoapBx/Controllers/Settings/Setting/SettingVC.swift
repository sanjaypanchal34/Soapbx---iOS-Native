    //
    //  SettingVC.swift
    //  SoapBx
    //
    //  Created by Mac on 19/07/23.
    //

import UIKit
import OTLContaner

class SettingVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var tblList: UITableView!
    
        // private
    private var arrSettings = [
        SettingModel(title: LocalStrings.SETTING_I_INVITE.rawValue.addLocalizableString()),
        SettingModel(title: LocalStrings.SETTING_I_MANAGE.rawValue.addLocalizableString()),
        SettingModel(title: LocalStrings.SETTING_I_SAVED.rawValue.addLocalizableString()),
        SettingModel(title: LocalStrings.SETTING_I_SUGGEST.rawValue.addLocalizableString()),
        SettingModel(title: LocalStrings.SETTING_I_NOTIFICATION.rawValue.addLocalizableString()),
        SettingModel(title: LocalStrings.SETTING_I_FEEDBACK.rawValue.addLocalizableString()),
        SettingModel(title: LocalStrings.SETTING_I_CPASSWORD.rawValue.addLocalizableString()),
        SettingModel(title: LocalStrings.SETTING_I_PAYMENT.rawValue.addLocalizableString()),
        SettingModel(title: LocalStrings.SETTING_I_CLANGUAGE.rawValue.addLocalizableString()),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        viewHeader.lblTitle.setHeader(LocalStrings.SETTING_TITLE.rawValue.addLocalizableString())
        
        tblList.register(["SettingItemCell"], delegate: self, dataSource: self)
    }
    
}
extension SettingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingItemCell") as? SettingItemCell {
            cell.setData(arrSettings[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch arrSettings[indexPath.row].title {
            case LocalStrings.SETTING_I_INVITE.rawValue.addLocalizableString():
                let vc = InviteFriendsVC()
                navigationController?.pushViewController(vc, animated: true)
                break
            case LocalStrings.SETTING_I_MANAGE.rawValue.addLocalizableString():
                let vc = YouInterestedVC()
                vc.screenType = .fromSetting
                navigationController?.pushViewController(vc, animated: true)
                break
            case LocalStrings.SETTING_I_SAVED.rawValue.addLocalizableString():
                let vc = SavedPostVC()
                navigationController?.pushViewController(vc, animated: true)
                break
            case LocalStrings.SETTING_I_SUGGEST.rawValue.addLocalizableString():
                let vc = SuggestFeatureVC()
                navigationController?.pushViewController(vc, animated: true)
                break
            case LocalStrings.SETTING_I_NOTIFICATION.rawValue.addLocalizableString():
                let vc = NotificationSettingVC()
                navigationController?.pushViewController(vc, animated: true)
                break
            case LocalStrings.SETTING_I_FEEDBACK.rawValue.addLocalizableString():
                let vc = SuggestFeatureVC()
                vc.screenType = .feedback
                navigationController?.pushViewController(vc, animated: true)
                break
            case LocalStrings.SETTING_I_CPASSWORD.rawValue.addLocalizableString():
                let vc = ChangePasswordVC()
                navigationController?.pushViewController(vc, animated: true)
                break
            case LocalStrings.SETTING_I_PAYMENT.rawValue.addLocalizableString():
                let vc = PaymentDetailsVC()
                navigationController?.pushViewController(vc, animated: true)
                break
            case LocalStrings.SETTING_I_CLANGUAGE.rawValue.addLocalizableString():
                let vc = ChangeLanguageVC()
                navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
        }
    }
    
}
