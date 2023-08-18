//
//  SubscribeVC.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit
import OTLContaner

enum SubscribeScreenType {
    case fromRegister, fromSetting
    
    var title: String {
        switch self {
        case .fromRegister: return "Subscribe on Soapbx"
        case .fromSetting: return "Upgrade Subscription plan"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .fromRegister: return "Next"
        case .fromSetting: return "Upgrade"
        }
    }
}

class SubscribeVC: UIViewController {

    @IBOutlet private weak var viewHeader: OTLHeader!
    @IBOutlet private weak var btnSupport: OTLPTButton!
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var constTblListHeight: NSLayoutConstraint!
    @IBOutlet private weak var btnNext: OTLTextButton!
    
    // private declaration
    private let vmObject = SubscriptionViewModel()
    
    // internal declaration
    var screenType = SubscribeScreenType.fromRegister
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getSubscriptionPlans()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        tblList.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let object = object as? UITableView{
                if object == tblList {
                    if let newvalue = change?[.newKey], let newsize  = newvalue as? CGSize{
                        if constTblListHeight != nil {
                            constTblListHeight?.constant = newsize.height
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        lblTitle.setTheme(screenType.title,
                          font: .bold,
                          size: 40)
        tblList.register(["SubscriptionNotesItemCell","SubscriptionNotesHeaderCell", "SubscriptionItemCell"], delegate: self, dataSource: self)
        viewHeader.btnBack.isHidden = screenType == .fromRegister
        
        btnSupport.backgroundColor = .primaryBlue
        btnSupport.title?.setTheme("Support Soapbx", color: .white)
        btnSupport.imageView?.image = UIImage(named: "ic_crown")
        btnSupport.layer.cornerRadius = 10
        btnSupport.isHidden = screenType == .fromRegister ? true : false
        
        btnNext.appButton(screenType.buttonTitle)
        
        tblList.reloadData()
    }
    
    @IBAction private func click_btnNext() {
        let object = vmObject.arrSubsciption.compactMap{ obj in
            return obj.isSelected ? true : nil
        }
        
        if object.count > 0 {
            updateSubscriptionPlans()
        } else {
            showToast(message: "Please select subscription plan")
        }
        
    }
    
    @IBAction private func click_btnSupport() {
        let url = URL(string: "https://soapbx.net/donate")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // API calls
    private func getSubscriptionPlans() {
        showLoader()
        vmObject.getSubscriptionPlans { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                self.tblList.reloadData()
            }
        }
    }
    
    private func updateSubscriptionPlans() {
        vmObject.updateSubscriptionPlans() { result in
            showToast(message: result.message)
            if result.status {
                if self.screenType == .fromRegister {
                    let vc = EnableLocationVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
extension SubscribeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if vmObject.arrSubsciption.count > 0 {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vmObject.arrSubsciption.count > 0 {
            if section == 0 {
                return vmObject.arrSubscribeNote.count
            }
            return vmObject.arrSubsciption.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionNotesItemCell") as? SubscriptionNotesItemCell {
            cell.setData(vmObject.arrSubscribeNote[indexPath.row],
                         isFreemiumSelected: vmObject.isFreemiumSelected,
                         isLastIndex: (vmObject.arrSubscribeNote.count - 1) == indexPath.row )
            return cell
        } else if indexPath.section == 1,
                  let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionItemCell") as? SubscriptionItemCell {
            cell.setData(vmObject.arrSubsciption[indexPath.row])
            return cell
                }
        return UITableViewCell()
    }
}
extension SubscribeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let header = tableView.dequeueReusableCell(withIdentifier: "SubscriptionNotesHeaderCell") as? SubscriptionNotesHeaderCell {
                header.setData(SubscribeNotesModel(title: "", freemium: "Freemium", premium: "Premium"), isFreemiumSelected: vmObject.isFreemiumSelected)
                return header
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                vmObject.isFreemiumSelected = true
            }
            else {
                vmObject.isFreemiumSelected = false
            }
            for index in 0..<vmObject.arrSubsciption.count {
                vmObject.arrSubsciption[index].isSelected = false
            }
            vmObject.arrSubsciption[indexPath.row].isSelected = true
            tableView.reloadData()
        }
    }
}
