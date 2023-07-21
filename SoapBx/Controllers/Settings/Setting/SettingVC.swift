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
        SettingModel(title: "Invite Friends"),
        SettingModel(title: "Manage Your Trends"),
        SettingModel(title: "Saved Post"),
        SettingModel(title: "Suggest a Feature"),
        SettingModel(title: "Notification"),
        SettingModel(title: "Feedback"),
        SettingModel(title: "Change Password"),
        SettingModel(title: "Payment Details"),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        viewHeader.lblTitle.setHeader("Settings")
        
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
        case "Invite Friends":
            let vc = InviteFriendsVC()
            navigationController?.pushViewController(vc, animated: true)
            break
        case "Manage Your Trends":
            let vc = YouInterestedVC()
            vc.screenType = .fromSetting
            navigationController?.pushViewController(vc, animated: true)
            break
        case "Saved Post":
            let vc = SavedPostVC()
            navigationController?.pushViewController(vc, animated: true)
            break
        case "Suggest a Feature":
            let vc = SuggestFeatureVC()
            navigationController?.pushViewController(vc, animated: true)
            break
        case "Notification":
            let vc = NotificationSettingVC()
            navigationController?.pushViewController(vc, animated: true)
            break
        case "Feedback":
            let vc = SuggestFeatureVC()
            vc.screenType = .feedback
            navigationController?.pushViewController(vc, animated: true)
            break
        case "Change Password":
            let vc = ChangePasswordVC()
            navigationController?.pushViewController(vc, animated: true)
            break
        case "Payment Details":
            break
        default:
            break
        }
    }
    
}
