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
    case fromHome, fromProfile, fromOtherUserProfile
}

protocol TradPostListDelegate{
    func tradPostList(didSelectTernd: TrendsModel)
}

class TradPostListView: UIView {
    
    @IBOutlet private weak var collectionTrends: UICollectionView!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var constListHeight: NSLayoutConstraint?
    
    private var dotMenuIndexPath: IndexPath?
    private let vmObject = TradPostListViewModel()
    private let vmLikeDislikeObj = LikeDislikeViewModel()
    private var refreshControl: UIRefreshControl?
    
    private var viewType:TradPostListViewType = .fromHome
    private var delegate:TradPostListDelegate?
    
    func addHeightListener() {
        tblList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblList.isScrollEnabled = false
    }
    func removeHeightListener() {
        tblList.removeObserver(self, forKeyPath: "contentSize")
        removeCellObserver()
    }
    
    func removeCellObserver(){
        for cell in tblList.visibleCells {
            if let cell = cell as? HomeItemCell {
                cell.removeCellObserver()
            }
        }
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
    
    func regiter( viewType:TradPostListViewType = .fromHome, delegate:TradPostListDelegate?) {
        self.viewType = viewType
        self.delegate = delegate
        self.vmObject.viewType = viewType
        backgroundColor = UIColor.lightGrey
        tblList.register(["HomeItemCell"], delegate: self, dataSource: self)
        collectionTrends.register(["TrendsItemCell"], delegate: self, dataSource: self)
        updateView()
        if viewType == .fromHome {
            getPost()
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(pullupRefresh), for: .valueChanged)
            tblList.refreshControl = refreshControl
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateList), name: .homePostUpdate, object: nil)
    }
    
    public func paginationManage() {
        if vmObject.currentPage < vmObject.totalPage {
            vmObject.currentPage = vmObject.currentPage + 1
        }
    }
    
    func updatePostObject(posts: [PostModel]) {
        vmObject.arrPosts = posts
        tblList.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.tblList.reloadData()
        })
    }
    
    func updateTerndsObject(ternds: [TrendsModel]) {
        vmObject.arrTernds = ternds
        collectionTrends.reloadData()
        
    }
    
    @objc private func updateList() {
        vmObject.currentPage = 1
        getPost()
    }
    
    @objc private func pullupRefresh() {
        dotMenuIndexPath = nil
        vmObject.currentPage = 1
        getPost()
        refreshControl?.endRefreshing()
    }
    
        // API Calls
    private func updateView() {
        vmObject.updateViewComplition = {
            hideLoader()
            self.tblList.reloadData()
            self.collectionTrends.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.tblList.reloadData()
            })
        }
    }
    
    private func getPost() {
        if viewType == .fromHome {
            self.getHomePost()
        }
    }
    
    private func getHomePost() {
        showLoader()
        vmObject.getPost { result in
            self.tblList.reloadData()
            self.collectionTrends.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                hideLoader()
                self.tblList.reloadData()
            })
        }
    }
    
    private func savePost(row: Int) {
        showLoader()
        vmLikeDislikeObj.saved(post: vmObject.arrPosts[row]) {[self] result, newObject in
            hideLoader()
            SoapBx.showToast(message: result.message)
            if result.status {
                if let updatedObj = newObject {
                    self.vmObject.arrPosts[row] = updatedObj
                }
                if let cell = self.tblList.cellForRow(at: IndexPath(row: row, section: 0)) as? HomeItemCell{
                    cell.updateData(self.vmObject.arrPosts[row])
                }
                NotificationCenter.default.post(name: .savePostUpdate, object: nil)
            } 
        }
    }
    
    private func likeDislikeonPost(isLike: Bool, row: Int) {
//        showLoader()
        vmLikeDislikeObj.likeDislike(post: vmObject.arrPosts[row], isLike: isLike) {[self] result, newObject in
//            hideLoader()
            SoapBx.showToast(message: result.message)
            if result.status {
                if let updatedObj = newObject {
                    self.vmObject.arrPosts[row] = updatedObj
                }
                if let cell = self.tblList.cellForRow(at: IndexPath(row: row, section: 0)) as? HomeItemCell{
                    cell.updateData(self.vmObject.arrPosts[row])
                }
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
        vmLikeDislikeObj.delete(post: id) {[self] result in
            hideLoader()
            SoapBx.showToast(message: result.message)
            self.vmObject.arrPosts.remove(at: row)
            if vmObject.arrPosts.count > 0{
                tblList.deleteRows(at: [IndexPath(row: row, section: 0)], with: .fade)
            }
            else {
                tblList.reloadData()
            }
        }
    }
    
}

extension TradPostListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmObject.arrPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeItemCell") as? HomeItemCell, vmObject.arrPosts.count > 0 {
            cell.setData(vmObject.arrPosts[indexPath.row],
                         indexPath: indexPath,
                         delegate: self,
                         isDotOptionsVisible: (dotMenuIndexPath?.row ?? -1) == indexPath.row,
                         screenType: viewType)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewType == .fromHome {
            if (indexPath.row + 1) >= (vmObject.arrPosts.count - 3){
                self.paginationManage()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? HomeItemCell {
            cell.removeCellObserver()
        }
    }
}
extension TradPostListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vmObject.arrTernds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendsItemCell", for: indexPath) as? TrendsItemCell, vmObject.arrTernds.count > 0 {
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
        delegate?.tradPostList(didSelectTernd: vmObject.arrTernds[indexPath.row])
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
        return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = TrendsItemCell.width + (vmObject.arrTernds[indexPath.row].name ?? " ").size(OfFont: AppFont.medium.font(size: 16)).width
        return CGSize(width: width, height: collectionView.frame.height - 15)
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
        if let user = object?.user, viewType != .fromOtherUserProfile {
            let vc = ProfileVC()
            vc.navigateForOtherUser(user)
            rootViewController.pushViewController(vc, animated: true)
        }
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
                if let user = object?.user , viewType != .fromOtherUserProfile{
                    let vc = ProfileVC()
                    vc.navigateForOtherUser(user)
                    rootViewController.pushViewController(vc, animated: true)
                }
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
                if let postObj = object {
                    let vc = CreatePostVC()
                    vc.navigateFromEdit(post: postObj, indexPath: cell.indexPath, delegate: self)
                    rootViewController.pushViewController(vc, animated: true)
                }
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
    
    func homeItemCell(_ cell: HomeItemCell, didUpdateTable: Void) {
//        self.tblList.beginUpdates()
//        self.tblList.setNeedsDisplay()
//        self.tblList.endUpdates()
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
extension TradPostListView: CreatePostDelegate {
    
    func createPost(deletePostImages at: IndexPath, with postId: Int, imageId: Int) {
        let index = vmObject.arrPosts[at.row].images?.firstIndex(where: { image in
            return image.id == imageId
        })
        
        if let row = index {
            vmObject.arrPosts[at.row].images?.remove(at: row)
        }
        
        if let cell = tblList.cellForRow(at: at)  as? HomeItemCell{
            cell.updateData(vmObject.arrPosts[at.row])
        }
    }
}
