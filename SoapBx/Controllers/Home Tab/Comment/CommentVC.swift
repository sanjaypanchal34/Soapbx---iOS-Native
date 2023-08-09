//
//  CommentVC.swift
//  SoapBx
//
//  Created by Mac on 13/07/23.
//

import UIKit
import OTLContaner

protocol CommentDelegate {
    func comment(didUpdate object: PostModel?)
}

enum CommentScreenType {
    case fromHome, fromSaved
}

class CommentVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    
    @IBOutlet private weak var btnProfileActio: UIControl!
    @IBOutlet private weak var imgProfile: UIImageView!
    
    @IBOutlet private weak var lblProfileName: UILabel!
    @IBOutlet private weak var lblPostLocation: UILabel!
    @IBOutlet private weak var lblPostTime: UILabel!
    
    @IBOutlet private weak var lblPostTitle: UILabel!
    @IBOutlet private weak var txtPostDescription: UITextView!
    @IBOutlet private weak var collectionPostImage: UICollectionView!
    @IBOutlet private weak var collectionSoapbx: UICollectionView!
    @IBOutlet private weak var collectionPolitician: UICollectionView!
    
    @IBOutlet private weak var viewActionButtons: UIView!
    @IBOutlet private weak var btnLike: OTLPTButton!
    @IBOutlet private weak var btnDislike: OTLPTButton!
    @IBOutlet private weak var btnComment: OTLPTButton!
    @IBOutlet private weak var pageCounter: UIPageControl!
    
    @IBOutlet private weak var tblCommentsList: UITableView!
    @IBOutlet private weak var constCommentsListHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var viewCommentText: UIView!
    @IBOutlet private weak var txtComment: UITextField!
    @IBOutlet private weak var btnSendComment: OTLImageButton!
    
    private var delegate:CommentDelegate?
    private var screenType = CommentScreenType.fromHome
    private let vmObject = CommentViewModel()
    private let vmLikeDislikeObj = LikeDislikeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        if self.vmObject.objPost == nil{
            self.navigationController?.popViewController(animated: true)
        }
        setData()
        updateView()
        getPost()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tblCommentsList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        tblCommentsList.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let object = object as? UITableView,
               object == tblCommentsList {
                if let newvalue = change?[.newKey], let newsize  = newvalue as? CGSize{
                    if constCommentsListHeight != nil {
                        constCommentsListHeight?.constant = newsize.height
                    }
                }
            }
        }
    }
    
    private func setupUI(){
        viewHeader.lblTitle.setHeader("")
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        lblProfileName.setTheme("", size: 18)
        lblPostLocation.setTheme("",size: 12)
        lblPostTime.setTheme("", size: 12)
        
        lblPostTitle.setTheme("", color: .primaryBlue, font: .semibold)
        txtPostDescription.text = ""
        txtPostDescription.font = AppFont.regular.font(size: 14)
        txtPostDescription.sizeToFit()
        txtPostDescription.isScrollEnabled = false
        txtPostDescription.isEditable = false
        txtPostDescription.isSelectable = true
        txtPostDescription.dataDetectorTypes = .all
        txtPostDescription.linkTextAttributes = [.foregroundColor:UIColor.primaryBlue]
        txtPostDescription.delegate = self
        
        collectionPostImage.register(["PostImageItemCell"], delegate: self, dataSource: self)
        collectionSoapbx.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        collectionPolitician.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        
        viewActionButtons.layer.cornerRadius = viewActionButtons.frame.height/2
        viewActionButtons.layer.borderWidth = 0.5
        viewActionButtons.layer.borderColor = UIColor.titleGrey.cgColor
        btnLike.title?.setTheme("0", size: 14)
        btnLike.imageView?.image = UIImage(named: "ic_like_grey")?.withRenderingMode(.alwaysTemplate)
        
        btnDislike.title?.setTheme("0", size: 14)
        btnDislike.imageView?.image = UIImage(named: "ic_dislike_grey")?.withRenderingMode(.alwaysTemplate)
        
        btnComment.title?.setTheme("0", size: 14)
        btnComment.imageView?.image = UIImage(named: "ic_comments_grey")
            
        pageCounter.pageIndicatorTintColor = .titleGrey
        pageCounter.currentPageIndicatorTintColor = .primaryBlue
        pageCounter.currentPage = 0
        pageCounter.numberOfPages = 3
        
        tblCommentsList.register(["CommentItemCell"], delegate: self, dataSource: self)
        tblCommentsList.isScrollEnabled = false
        
        txtComment.placeholder = "Enter Your Comment Here"
        viewCommentText.layer.cornerRadius = 10
        viewCommentText.layer.borderWidth = 1
        viewCommentText.layer.borderColor = UIColor.lightGrey.cgColor
        btnSendComment.image = UIImage(named: "ic_commentSend")
    }

    func navigateData(_ object: PostModel, screenType: CommentScreenType , delegate:CommentDelegate){
        self.vmObject.objPost = object
        self.screenType = screenType
        self.delegate = delegate
    }
    func setData() {
        let object = self.vmObject.objPost
        viewHeader.lblTitle.text = object?.user?.name
        
        imgProfile.setImage(object?.user?.profilePhotoURL)
        lblProfileName.text = object?.user?.name
        lblPostLocation.text = object?.user?.location
        lblPostTime.text = OTLDateConvert.instance.convert(date: object?.createdAt ?? "", set: .yyyyMMdd_T_HHmmssZ, getFormat: .mmmDDyyyyAthhmma)
                
        lblPostTitle.text = object?.title
        txtPostDescription.text = object?.description
        
        if (object?.images?.count ?? 0) > 0 {
            collectionPostImage.isHidden = false
            self.collectionPostImage.reloadData()
        } else {
            collectionPostImage.isHidden = true
        }
        
        if (object?.trendTags?.count ?? 0) > 0 {
            collectionSoapbx.isHidden = false
            self.collectionSoapbx.reloadData()
        } else {
            collectionSoapbx.isHidden = true
        }
        
        if (object?.politicianTags?.count ?? 0) > 0 {
            collectionPolitician.isHidden = false
            self.collectionPolitician.reloadData()
        } else {
            collectionPolitician.isHidden = true
        }
        
        btnLike.title?.text = "\(object?.likeCount ?? 0)"
        btnLike.imageView?.tintColor = object?.likeStatus == 1 ? .primaryBlue : .titleGrey
        btnDislike.title?.text = "\(object?.dislikeCount ?? 0)"
        btnDislike.imageView?.tintColor = object?.dislikeStatus == 1 ? .primaryBlue : .titleGrey
        btnComment.title?.text = "\(object?.commentsCount ?? 0)"
    }
    
    //Actions
    @IBAction private func click_btnProfileActio() {
        
    }
    
    @IBAction private func click_btnLike() {
        likeDislikeonPost(isLike: true)
    }
    @IBAction private func click_btnDislike() {
        likeDislikeonPost(isLike: false)
    }
    
    @IBAction private func click_btnSendComment() {
        let validate = txtComment.text?.validateCommentOnPost()
        
        if validate?.status == false {
            showToast(message: validate?.message ?? "")
        } else {
            self.view.endEditing(true)
            self.postComment()
        }
    }
    
    //API calls
   public func paginationManage() {
        if vmObject.currentPage < vmObject.totalPage {
            vmObject.currentPage = vmObject.currentPage + 1
        }
    }
    
        // API Calls
    private func updateView() {
        vmObject.updateViewComplition = {
            self.tblCommentsList.reloadData()
        }
    }
    
    private func getPost() {
        showLoader()
        vmObject.getPost { result in
            hideLoader()
            self.tblCommentsList.reloadData()
            self.collectionPostImage.reloadData()
            self.collectionSoapbx.reloadData()
            self.collectionPolitician.reloadData()
            self.setData()
        }
    }
    
    private func postComment() {
        showLoader()
        vmObject.postComment(comment: txtComment.text ?? "") { result in
            hideLoader()
            self.txtComment.text = ""
            if result.status{
                self.btnComment.title?.text = "\(self.vmObject.objPost?.commentsCount ?? 0)"
                self.tblCommentsList.reloadData()
                self.delegate?.comment(didUpdate: self.vmObject.objPost)
            }
        }
    }
    
    private func reportComment(commentId: Int, reason: String) {
        showLoader()
        vmObject.report(commentId: commentId, reason: reason) { result in
            hideLoader()
            showToast(message: result.message)
        }
    }
    
    private func likeDislikeonPost(isLike: Bool) {
        vmLikeDislikeObj.likeDislike(post: vmObject.objPost!, isLike: isLike) { result, newObject in
            if result.status {
                if let updatedObj = newObject {
                    self.vmObject.objPost = updatedObj
                    self.setData()
                    self.delegate?.comment(didUpdate: updatedObj)
                }
            } else {
                SoapBx.showToast(message: result.message)
            }
        }
    }
}
extension CommentVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionPostImage {
            let x = scrollView.contentOffset.x + 20 + (10*3)
            let w = scrollView.bounds.size.width
            pageCounter.currentPage = Int(x/w)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
extension CommentVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmObject.arrComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentItemCell") as? CommentItemCell {
            cell.setData(vmObject.arrComments[indexPath.row], indexPath: indexPath, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
}
extension CommentVC: CommentItemDelegate{
    func commentItem(_ cell: CommentItemCell, didSelectReport object: CommentModel) {
        self.view.showReportView(comment: object.id ?? 0) { id, report in
            self.reportComment(commentId: id, reason: report)
        }
    }
}


extension CommentVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionPostImage {
            return self.vmObject.objPost?.images?.count ?? 0
        } else if collectionView == collectionPolitician {
            return self.vmObject.objPost?.politicianTags?.count ?? 0
        } else {
            return self.vmObject.objPost?.trendTags?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionPostImage,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageItemCell", for: indexPath) as? PostImageItemCell {
            if let obj = self.vmObject.objPost?.images?[indexPath.row] {
                cell.setData(obj, indexPath: indexPath)
                return cell
            }
        }
        else if collectionView == collectionSoapbx,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell {
            if let obj = self.vmObject.objPost?.trendTags?[indexPath.row] {
                cell.setDataSoapbx(obj)
                return cell
            }
            
        }
        else if collectionView == collectionPolitician,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell {
            if let obj = self.vmObject.objPost?.politicianTags?[indexPath.row] {
                cell.setDataPolitician(obj)
                return cell
            }
            
            
        }
        return UICollectionViewCell()
    }
    
}
extension CommentVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionPostImage {
            return CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.width - 10)
        }
        else if collectionView == collectionSoapbx,
                 (self.vmObject.objPost?.trendTags?.count ?? 0) > 0{
            let text = self.vmObject.objPost?.trendTags?[indexPath.row].trend?.name ?? ""
            let width = text.size(OfFont: AppFont.regular.font(size: 16)).width + 20
            if width < 55 {
                return CGSize(width: 55, height: 35)
            }
            else {
                return CGSize(width: width, height: 35)
            }
        }else if collectionView == collectionPolitician,
                 (self.vmObject.objPost?.politicianTags?.count ?? 0) > 0{
            let text = self.vmObject.objPost?.politicianTags?[indexPath.row].politician?.name ?? ""
            let width = text.size(OfFont: AppFont.regular.font(size: 16)).width + 20
            if width < 55 {
                return CGSize(width: 55, height: 35)
            }
            else {
                return CGSize(width: width, height: 35)
            }
        }
        return CGSize()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
extension CommentVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        printLog("[HomeItemCell] shouldInteractWith")
        return false
    }
}
