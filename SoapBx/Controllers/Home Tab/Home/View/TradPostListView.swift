//
//  TradPostListView.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit

enum TradPostListViewType {
    case fromHome, fromProfile
}

class TradPostListView: UIView {

    @IBOutlet private weak var collectionTrends: UICollectionView!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var constListHeight: NSLayoutConstraint?
    
    private var dotMenuIndexPath: IndexPath?
    private let vmObject = TradPostListViewModel()
    private let vmLikeDislikeObj = LikeDislikeViewModel()
    
    var viewType:TradPostListViewType = .fromHome
    
    func addHeightListener() {
        tblList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblList.isScrollEnabled = false
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
        updateView()
            OTLWebserviceConfiguration.instance.appState = .live
        getPost()
    }
    
    public func paginationManage() {
        if vmObject.currentPage < vmObject.totalPage {
            vmObject.currentPage = vmObject.currentPage + 1
        }
    }
    
    // API Calls
    private func updateView() {
        vmObject.updateViewComplition = {
            hideLoader()
            self.tblList.reloadData()
            self.collectionTrends.reloadData()
        }
    }
    
    func getPost() {
        if viewType == .fromHome {
            self.getHomePost()
        }
    }
    
    private func getHomePost() {
        showLoader()
        vmObject.getPost { result in
            hideLoader()
            self.tblList.reloadData()
            self.collectionTrends.reloadData()
        }
    }
    
    private func savePost(row: Int) {
        showLoader()
        vmLikeDislikeObj.saved(post: vmObject.arrPosts[row]) { result, newObject in
            hideLoader()
            if result.status {
                if let updatedObj = newObject {
                    self.vmObject.arrPosts[row] = updatedObj
                }
                if let cell = self.tblList.cellForRow(at: IndexPath(row: row, section: 0)) as? HomeItemCell{
                    cell.updateData(self.vmObject.arrPosts[row])
                }
            } else {
                SoapBx.showToast(message: result.message)
            }
        }
    }
    
    private func likeDislikeonPost(isLike: Bool, row: Int) {
        showLoader()
        vmLikeDislikeObj.likeDislike(post: vmObject.arrPosts[row], isLike: isLike) { result, newObject in
            hideLoader()
            if result.status {
                if let updatedObj = newObject {
                    self.vmObject.arrPosts[row] = updatedObj
                }
                if let cell = self.tblList.cellForRow(at: IndexPath(row: row, section: 0)) as? HomeItemCell{
                    cell.updateData(self.vmObject.arrPosts[row])
                }
            } else {
                SoapBx.showToast(message: result.message)
            }
        }
    }
    
    
    private func hidePost(post id:Int) {
        showLoader()
        vmLikeDislikeObj.blockPost(post: id) { result in
            hideLoader()
            SoapBx.showToast(message: result.message)
            if result.status {
                self.vmObject.currentPage = 1
                self.getPost()
            }
        }
    }
    
    private func reportPost(post id:Int) {
        showLoader()
        vmLikeDislikeObj.report(post: id) { result in
            hideLoader()
            SoapBx.showToast(message: result.message)
        }
    }
    
    private func deletePost(post id:Int, row: Int) {
        showLoader()
        vmLikeDislikeObj.delete(post: id) { result in
            hideLoader()
            SoapBx.showToast(message: result.message)
            self.vmObject.arrPosts.remove(at: row)
            if self.vmObject.arrPosts.count > 0{
                self.tblList.deleteRows(at: [IndexPath(row: row, section: 0)], with: .fade)
            }
        }
    }
    
}

extension TradPostListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmObject.arrPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeItemCell") as? HomeItemCell {
            cell.setData(vmObject.arrPosts[indexPath.row], indexPath: indexPath, delegate: self, isDotOptionsVisible: (dotMenuIndexPath?.row ?? -1) == indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        printLog("[TradPostListView] willDisplay --->")
        if viewType == .fromHome {
            if (indexPath.row + 1) >= (vmObject.arrPosts.count - 3){
                self.paginationManage()
            }
        }
    }
}
extension TradPostListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vmObject.arrTernds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendsItemCell", for: indexPath) as? TrendsItemCell {
            cell.setData(vmObject.arrTernds[indexPath.row],
                         color: vmObject.arrTerndsColor[indexPath.row%3],
                         isSelected: vmObject.selectedTerndsIndex == indexPath.row)
            return cell
        }
        return UICollectionViewCell()
    }
        
    
}
extension TradPostListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vmObject.selectedTerndsIndex = indexPath.row
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
        let width = TrendsItemCell.width + (vmObject.arrTernds[indexPath.row].name ?? " ").size(OfFont: AppFont.medium.font(size: 18)).width
        return CGSize(width: width, height: collectionView.frame.height - 20)
    }
    
}
extension TradPostListView: HomeItemCellDelegate{
    
    func homeItemCell(_ cell: HomeItemCell, didSelect object: PostModel?) {
        if let obj = object {
            let vc = CommentVC()
            vc.navigateData(obj, screenType: .fromHome, delegate: self)
            rootViewController.pushViewController(vc, animated: true)
        }
    }
    
    func homeItemCell(_ cell: HomeItemCell, didSelectProfile object: PostModel?) {
        let vc = ProfileVC()
        vc.screenType = .fromOtherUserProfile
        vc.userObj = object?.user
        rootViewController.pushViewController(vc, animated: true)
    }
    
    func homeItemCell(_ cell: HomeItemCell, didSelectSave object: PostModel?) {
        self.savePost(row: cell.indexPath.row)
    }
    
    func homeItemCell(_ cell: HomeItemCell, didSelectLike object: PostModel?){
        likeDislikeonPost(isLike: true, row: cell.indexPath.row)
    }
    
    func homeItemCell(_ cell: HomeItemCell, didSelectDislike object: PostModel?) {
        likeDislikeonPost(isLike: false, row: cell.indexPath.row)
    }
    
    func homeItemCell(_ cell: HomeItemCell, didSelectComment object: PostModel?) {
        if let obj = object {
            let vc = CommentVC()
            vc.navigateData(obj, screenType: .fromHome, delegate: self)
            rootViewController.pushViewController(vc, animated: true)
        }
    }
    
    func homeItemCell(_ cell: HomeItemCell, willOpenDotMenu object: PostModel?) {
        if let indexPath = dotMenuIndexPath{
            if let cell = tblList.cellForRow(at: indexPath) as? HomeItemCell{
                cell.hideThreeDotMenu()
            }
        }
        self.dotMenuIndexPath = cell.indexPath
    }
    
    func homeItemCell(_ cell: HomeItemCell, didSelectDotMenu: ThreeDotItemModel,  object: PostModel?) {
        dotMenuIndexPath = nil
        switch didSelectDotMenu.title {
        case .openProfile:
                let vc = ProfileVC()
                vc.screenType = .fromOtherUserProfile
                vc.userObj = object?.user
                rootViewController.pushViewController(vc, animated: true)
            break;
        case .hidePost(_):
            self.hidePost(post: object?.userID ?? 0)
            break;
        case .share:
                showLoader()
                let text = "soapbx://home/\(object?.id ?? 0)"
                let textToShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self // so that iPads won't crash
                activityViewController.excludedActivityTypes = [ .airDrop, .postToFacebook, .message, .mail]
                rootViewController.present(activityViewController, animated: true, completion: {
                    hideLoader()
                })
            break;
        case .report:
            reportPost(post: object?.id ?? 0)
            break;
        case .edit:
            let vc = CreatePostVC()
            vc.screenType = .editPost
            rootViewController.pushViewController(vc, animated: true)
            break;
        case .delete:
                showAlert(message: "Are you sure you want to delete this post?", buttons: ["Cancel", "Delete"]) { alert in
                    if alert.title == "Delete" {
                        self.deletePost(post: object?.id ?? 0, row: cell.indexPath.row)
                    }
                }
            break;
        default: break;
        }
    }
}
extension TradPostListView: CommentDelegate {
    func comment(didUpdate object: PostModel?) {
        let index = vmObject.arrPosts.firstIndex(where: { post in
            return (post.id ?? 0) == (object?.id ?? 0)
        })
        
        if let row = index, let newObj = object {
            vmObject.arrPosts[row] = newObj
            
            if let cell = tblList.cellForRow(at: IndexPath(row: row, section: 0))  as? HomeItemCell{
                cell.updateData(newObj)
            }
        }
    }
    
    
}
