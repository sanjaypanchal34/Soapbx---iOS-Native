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
        ChangeLangModel(title: "English", value: "en"),
        ChangeLangModel(title: "Spanish", value: "es"),
        ChangeLangModel(title: "French", value: "fr"),
        ChangeLangModel(title: "German", value: "de"),
        ChangeLangModel(title: "Portuguese", value: "pt-PT"),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        viewHeader.lblTitle.setHeader("Language")
        
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
        let cancel = OTLAlertModel(title: "Cancel", id: 0)
        let okay = OTLAlertModel(title: "Okay", id: 1, style: .destructive)
        showAlert(message: "Are you sure you want to change language?",  buttons: [cancel,okay]) { alert in
            if alert.id == 1 {
                SoapBx.showToast(message: "Language change successfully!!!")
                UserDefaults.standard.set(self.arrLanguage[indexPath.row].value, forKey: OTLAppKey.Language)
                  UserDefaults.standard.synchronize()
                mackRootView(HomeVC())
            }
        }
    }
    
}
