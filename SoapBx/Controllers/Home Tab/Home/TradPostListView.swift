//
//  TradPostListView.swift
//  SoapBx
//
//  Created by Mac on 11/07/23.
//

import UIKit

enum TradPostListViewType {
    case fromHome, fromProfile
}

class TradPostListView: UIView {

    @IBOutlet private weak var collectionTrends: UICollectionView!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var constListHeight: NSLayoutConstraint?
    
    private var arrTernds: [DummyTrends] = [
        DummyTrends(title: "All Trends", colorHax: "#FBBA10"),
        DummyTrends(title: "Think Talk", colorHax: "#E34343"),
        DummyTrends(title: "Crrcular Economy", colorHax: "#0F9DD9"),
        DummyTrends(title: "Global Affairs", colorHax: "#FBBA10"),
    ]
    private var selectedIndex = 0
    private var dotMenuIndexPath: IndexPath?
    
    var viewType:TradPostListViewType = .fromHome
    
    func addHeightListener() {
        tblList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    func removeHeightListener() {
        tblList.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let object = object as? UITableView,
               object == tblList {
                if let newvalue = change?[.newKey], let newsize  = newvalue as? CGSize{
                    if constListHeight != nil {
                        constListHeight?.constant = newsize.height
                    }
                }
            }
        }
    }
    
    func regiter( viewType:TradPostListViewType = .fromHome) {
        self.viewType = viewType
        backgroundColor = UIColor.lightGrey
        tblList.register(["HomeItemCell"], delegate: self, dataSource: self)
        collectionTrends.register(["TrendsItemCell"], delegate: self, dataSource: self)
    }
}

extension TradPostListView: UITableViewDataSource, UITableViewDelegate {
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
extension TradPostListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTernds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendsItemCell", for: indexPath) as? TrendsItemCell {
            cell.setData(arrTernds[indexPath.row], isSelected: selectedIndex == indexPath.row)
            return cell
        }
        return UICollectionViewCell()
    }
        
    
}
extension TradPostListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionView.reloadData()
    }
}
extension TradPostListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = TrendsItemCell.width + arrTernds[indexPath.row].title.size(OfFont: AppFont.medium.font(size: 18)).width
        return CGSize(width: width, height: collectionView.frame.height - 20)
    }
    
}
extension TradPostListView: HomeItemCellDelegate{
    
    func homeItemCell(_ cell: HomeItemCell, didSelectProfile: Void) {
        let vc = ProfileVC()
        vc.screenType = .fromOtherUserProfile
        rootViewController.pushViewController(vc, animated: true)
    }
    
    func homeItemCell(_ cell: HomeItemCell, didSelectComment: Void) {
        let vc = CommentVC()
//        vc.screenType = .fromOtherUserProfile
        rootViewController.pushViewController(vc, animated: true)
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
            rootViewController.pushViewController(vc, animated: true)
            break;
        case .delete:
            break;
        }
    }
}
