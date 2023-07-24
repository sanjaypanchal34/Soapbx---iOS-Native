//
//  PollsListVC.swift
//  SoapBx
//
//  Created by Mac on 22/07/23.
//

import UIKit
import OTLContaner

class PollsListVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    @IBOutlet private weak var btnPostPolls: OTLImageButton!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var lblNoDataFound: UILabel!
    @IBOutlet private weak var tblList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader("Poll")
        btnPostPolls.image = UIImage(named: "ic_paymentAdd")
        
        lblNoDataFound.noDataTitle("No Polls Found")
        
        tblList.register(["PublicFiguresItemCell"], delegate: self, dataSource: self)
    }
    
    
    @IBAction private func click_postPoll(_ sender: OTLTextButton) {
        let vc = PostPollsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension PollsListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PublicFiguresItemCell") as? PublicFiguresItemCell {
            cell.indexPath = indexPath
            cell.setDataBlock()
            return cell
        }
        return UITableViewCell()
    }
}



