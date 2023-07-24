//
//  ChatVC.swift
//  SoapBx
//
//  Created by Mac on 23/07/23.
//

import UIKit
import OTLContaner

class ChatVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    @IBOutlet private weak var btnDotMenu: OTLImageButton!
    
    @IBOutlet private weak var viewBody: UIView!
    
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var lblNoData: UILabel!
    
    @IBOutlet private weak var viewMessage: UIView!
    @IBOutlet private weak var txtMessage: UITextField!
    @IBOutlet private weak var btnAddMedia: OTLImageButton!
    @IBOutlet private weak var btnSendMessage: OTLImageButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader("Robert Watson")
        btnDotMenu.image = UIImage(named: "ic_dots")
        btnDotMenu.height = 30
        
        tblList.register(["SearchItemCell"], delegate: self, dataSource: self)
        lblNoData.noDataTitle("Connecting")
        
        viewMessage.backgroundColor = .lightGrey
        viewMessage.layer.cornerRadius = 10
        viewMessage.layer.borderWidth = 1
        viewMessage.layer.borderColor = UIColor.titleGrey.cgColor
        
        btnAddMedia.image = UIImage(named: "ic_paymentAdd")
        btnAddMedia.height = 25
        btnAddMedia.backgroundColor = .clear
        txtMessage.font = AppFont.regular.font(size: 16)
        txtMessage.backgroundColor = .clear
        btnSendMessage.image = UIImage(named: "ic_chatSend")
        btnSendMessage.height = 25
        btnSendMessage.backgroundColor = .clear
    }

    //
    @IBAction private func click_btnDotMenu() {
        view.showThreeDotMenu(array: [
            ThreeDotItemModel(title: .clearChat, icon: "ic_clearChat"),
            ThreeDotItemModel(title: .starredMessage, icon: "ic_starChat"),
            ThreeDotItemModel(title: .block, icon: "ic_shield"),
        ])
        { obj in
            
        }
    }
    @IBAction private func click_btnAddMedia() {
        let camera = OTLAlertModel(title: "Camera", id: 0)
        let gellary = OTLAlertModel(title: "Gellary", id: 1)
        let cancel = OTLAlertModel(title: "Cancel", id: 2)
        
        showAlert(message: "Media Type", buttons: [camera, gellary, cancel])
    }
    @IBAction private func click_btnSendMessage() {
        
    }
    
}
extension ChatVC: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

