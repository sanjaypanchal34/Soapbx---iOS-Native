//
//  ChangeLanguageVC.swift
//  SoapBx
//
//  Created by AppSaint Technology on 24/08/23.
//

import UIKit
import OTLContaner

class ChangeLanguageVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var tblList: UITableView!
    
        // private
    private var arrLanguage = [
        ChangeLangModel(title: LocalStrings.LANG_ENG.rawValue.addLocalizableString(), value: "en"),
        ChangeLangModel(title: LocalStrings.LANG_SPANISH.rawValue.addLocalizableString(), value: "es"),
        ChangeLangModel(title: LocalStrings.LANG_FRENCH.rawValue.addLocalizableString(), value: "fr"),
        ChangeLangModel(title: LocalStrings.LANG_GERMAN.rawValue.addLocalizableString(), value: "de"),
        ChangeLangModel(title: LocalStrings.LANG_PORTUGULE.rawValue.addLocalizableString(), value: "pt-PT"),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        viewHeader.lblTitle.setHeader(LocalStrings.LANG_TITLE.rawValue.addLocalizableString())
        
        tblList.register(["LanguageItemCell"], delegate: self, dataSource: self)
    }
    
}
extension ChangeLanguageVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageItemCell") as? LanguageItemCell {
            cell.setData(arrLanguage[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cancel = OTLAlertModel(title: LocalStrings.C_CANCEL.rawValue.addLocalizableString(), id: 0)
        let okay = OTLAlertModel(title: LocalStrings.C_OK.rawValue.addLocalizableString(), id: 1, style: .destructive)
        showAlert(message: LocalStrings.A_CHANGE_LANG.rawValue.addLocalizableString(),  buttons: [cancel,okay]) { alert in
            if alert.id == 1 {
                SoapBx.showToast(message: LocalStrings.LANG_ALERT.rawValue.addLocalizableString())
                UserDefaults.standard.set(self.arrLanguage[indexPath.row].value, forKey: OTLAppKey.Language)
                  UserDefaults.standard.synchronize()
                mackRootView(HomeVC())
            }
        }
    }
    
}
