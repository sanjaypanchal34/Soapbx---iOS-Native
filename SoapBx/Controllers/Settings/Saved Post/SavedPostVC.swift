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
    
    private let vmObject = SavedPostViewModel()
    private let vmLikeDislikeObj = LikeDislikeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getSavedPosts()
    }

    private func setupUI() {
        viewHeader.lblTitle.setHeader("Saved Post")
        viewBody.backgroundColor = .lightGrey
        tblList.register(["HomeItemCell"], delegate: self, dataSource: self)
        NotificationCenter.default.addObserver(self, selector: #selector(savePostUpdate), name: .savePostUpdate, object: nil)
    }
    
    //
    @objc private func savePostUpdate(){
        getSavedPosts()
        NotificationCenter.default.post(name: .homePostUpdate, object: nil)
    }
    
    // API calls
    private func getSavedPosts() {
        showLoader()
        vmObject.getSavedPosts { result in
            hideLoader()
            self.tblList.reloadData()
        }
    }
    
    private func savePost(row: Int) {
        showLoader()
        vmLikeDislikeObj.saved(post: vmObject.arrPosts[row]) { result, newObject in
            hideLoader()
            if result.status {
                self.vmObject.arrPosts.remove(at: row)
                if self.vmObject.arrPosts.count > 0 {
                    self.tblList.deleteRows(at: [IndexPath(row: row, section: 0)], with: .fade)
                } else {
                    self.tblList.reloadData()
                }
                NotificationCenter.default.post(name: .homePostUpdate, object: nil)
            }
            SoapBx.showToast(message: result.message)
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
                NotificationCenter.default.post(name: .homePostUpdate, object: nil)
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
                self.getSavedPosts()
                NotificationCenter.default.post(name: .homePostUpdate, object: nil)
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
extension SavedPostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmObject.arrPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeItemCell") as? HomeItemCell {
            cell.setData(vmObject.arrPosts[indexPath.row], indexPath: indexPath, delegate: self, screenType: .fromHome)
            return cell
        }
        return UITableViewCell()
    }
}
extension SavedPostVC: HomeItemCellDelegate{
    
    func homeItemCell(_ cell: HomeItemCell, didSelect object: PostModel?) {
        if let obj = object {
            let vc = CommentVC()
            vc.navigateData(obj, screenType: .fromHome, delegate: self)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func homeItemCell(_ cell: HomeItemCell, didSelectProfile object: PostModel?) {
        if object?.user?.id != authUser?.user?.id {
            if let user = object?.user {
                let vc = ProfileVC()
                vc.navigateForOtherUser(user)
                navigationController?.pushViewController(vc, animated: true)
            }
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
            vc.navigateData(obj, screenType: .fromSaved, delegate: self)
            navigationController?.pushViewController(vc, animated: true)
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
        switch didSelectDotMenu.title {
            case .openProfile:
                if let user = object?.user {
                    let vc = ProfileVC()
                    vc.navigateForOtherUser(user)
                    navigationController?.pushViewController(vc, animated: true)
                }
                break;
            case .hidePost(_):
                self.hidePost(post: object?.userID ?? 0)
                break;
            case .share:
                let text = "soapbx://home/\(object?.id ?? 0)"
                let textToShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                activityViewController.excludedActivityTypes = [ .airDrop, .postToFacebook, .message, .mail]
                navigationController?.present(activityViewController, animated: true, completion: nil)
                break;
            case .report:
                reportPost(post: object?.id ?? 0)
                break;
            case .edit:
                if let postObj = object {
                    let vc = CreatePostVC()
                    vc.navigateFromEdit(post: postObj, indexPath: cell.indexPath, delegate: self)
                    navigationController?.pushViewController(vc, animated: true)
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
}
extension SavedPostVC: CommentDelegate {
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
extension SavedPostVC: CreatePostDelegate {
    
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
