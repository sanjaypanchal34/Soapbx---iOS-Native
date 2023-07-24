//
//  SavedPostVC.swift
//  SoapBx
//
//  Created by Mac on 19/07/23.
//

import UIKit
import OTLContaner

class SavedPostVC: UIViewController{
    

    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var tblList: UITableView!
    
    private var dotMenuIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader("Saved Post")
        viewBody.backgroundColor = .lightGrey
        tblList.register(["HomeItemCell"], delegate: self, dataSource: self)
    }
}
extension SavedPostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeItemCell") as? HomeItemCell {
            cell.indexPath = indexPath
            cell.setData(delegate: self)
            return cell
        }
        return UITableViewCell()
    }
}
extension SavedPostVC: HomeItemCellDelegate{
    
    func homeItemCell(_ cell: HomeItemCell, didSelectProfile: Void) {
        let vc = ProfileVC()
        vc.screenType = .fromOtherUserProfile
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func homeItemCell(_ cell: HomeItemCell, didSelectComment: Void) {
        let vc = CommentVC()
//        vc.screenType = .fromOtherUserProfile
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func homeItemCell(_ cell: HomeItemCell, willOpenDotMenu: Bool) {
        if let indexPath = dotMenuIndexPath{
            if let cell = tblList.cellForRow(at: indexPath) as? HomeItemCell{
                cell.hideThreeDotMenu()
            }
        }
        self.dotMenuIndexPath = cell.indexPath
    }
    
    func homeItemCell(_ cell: HomeItemCell, didSelectDotMenu: ThreeDotItemModel) {
        switch didSelectDotMenu.title {
        case .openProfile:
            break;
        case .hidePost(_):
            break;
        case .share:
            break;
        case .report:
            break;
        case .edit:
            let vc = CreatePostVC()
            vc.screenType = .editPost
            navigationController?.pushViewController(vc, animated: true)
            break;
        case .delete:
            break;
        default: break;
        }
    }
}
