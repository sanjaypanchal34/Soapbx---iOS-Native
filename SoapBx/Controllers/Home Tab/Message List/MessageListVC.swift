//
//  MessageListVC.swift
//  SoapBx
//
//  Created by Mac on 22/07/23.
//

import UIKit
import OTLContaner

class MessageListVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var searchView: OTLPTButton!
    @IBOutlet private weak var txtSearch: UITextField!
    @IBOutlet private weak var btnMessageRequest: OTLTextButton!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var lblNoData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        
        viewHeader.lblTitle.setHeader("Search")
        
        searchView.backgroundColor = .lightGrey
        searchView.layer.cornerRadius = searchView.frame.height/2
        searchView.imageView?.image = UIImage(named: "ic_search")?.withRenderingMode(.alwaysTemplate)
        searchView.imageView?.tintColor = .titleBlack
        txtSearch.font = AppFont.regular.font(size: 16)
        
        btnMessageRequest.setTheme("Message Requests", color: .primaryBlue, size: 10)
        
//        tblList.register(["SearchItemCell"], delegate: self, dataSource: self)
        lblNoData.noDataTitle("No Chats Found")
    }

    //
    @IBAction private func click_messageRequest() {
        
    }
}
extension MessageListVC: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
