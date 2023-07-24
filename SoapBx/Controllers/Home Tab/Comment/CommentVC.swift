//
//  CommentVC.swift
//  SoapBx
//
//  Created by Mac on 13/07/23.
//

import UIKit
import OTLContaner

class CommentVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    
    @IBOutlet private weak var btnProfileActio: UIControl!
    @IBOutlet private weak var imgProfile: UIImageView!
    
    @IBOutlet private weak var lblProfileName: UILabel!
    @IBOutlet private weak var lblPostLocation: UILabel!
    @IBOutlet private weak var lblPostTime: UILabel!
    
    @IBOutlet private weak var lblPostTitle: UILabel!
    @IBOutlet private weak var lblPostDescription: UILabel!
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
    
    private var arrSoapbxTrends = ["Think Talk", "Circular Economy", "Global Affairs"]
    private var arrPolitician = ["Roger Wicker", "Narendra Modi", "Putin"]
    private var delegate:HomeItemCellDelegate?
    
    override func viewDidLoad() {
        self.setupUI()
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
        viewHeader.lblTitle.setHeader("Robert Watson")
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        lblProfileName.setTheme("Soapbx Admin", size: 18)
        lblPostLocation.setTheme("San Jose. CA. USA",size: 12)
        lblPostTime.setTheme("Apr 11 2023 @ 10:13 PM", size: 12)
        
        lblPostTitle.setTheme("Groundwater Gold Rush", color: .primaryBlue, font: .semibold)
        lblPostDescription.setTheme("Banks, pension funds and insurers have been turning California's scarce water into enormous profits, leaving people with less to drink. https://www.bloomberg.com/graphics/2023-wall-street -speeds-california-groundwater-depletion/?srnd=premium #xi4v7vzkg", size: 14, lines: 0)
        
        collectionPostImage.register(["PostImageItemCell"], delegate: self, dataSource: self)
        collectionSoapbx.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        collectionPolitician.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        
        
        
        viewActionButtons.layer.cornerRadius = viewActionButtons.frame.height/2
        viewActionButtons.layer.borderWidth = 0.5
        viewActionButtons.layer.borderColor = UIColor.titleGrey.cgColor
        btnLike.title?.setTheme("0", size: 14)
        btnLike.imageView?.image = UIImage(named: "ic_like_grey")
        
        btnDislike.title?.setTheme("0", size: 14)
        btnDislike.imageView?.image = UIImage(named: "ic_dislike_grey")
        
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

    func setData(delegate:HomeItemCellDelegate){
        self.delegate = delegate
        DispatchQueue.main.async {
            self.collectionPostImage.reloadData()
        }
    }
    
    //Actions
    @IBAction private func click_btnProfileActio() {
        
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
}
extension CommentVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentItemCell") as? CommentItemCell {
            cell.setData()
            return cell
        }
        return UITableViewCell()
    }
}
extension CommentVC: UITableViewDelegate {
    
}

extension CommentVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionPostImage {
            return 3
        } else if collectionView == collectionPolitician {
            return arrPolitician.count
        } else {
            return arrSoapbxTrends.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionPostImage,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageItemCell", for: indexPath) as? PostImageItemCell {
            cell.setData(indexPath.row)
            return cell
        }
        else if collectionView == collectionSoapbx,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell {
            cell.setDataSoapbx(arrSoapbxTrends[indexPath.row])
                return cell
            }
        else if collectionView == collectionPolitician,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell {
            cell.setDataPolitician(arrPolitician[indexPath.row])
                return cell
            }
        return UICollectionViewCell()
    }
    
}
extension CommentVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionPostImage {
            return CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.width - 20)
        } else {
            let text = collectionView == collectionSoapbx ? arrSoapbxTrends[indexPath.row] : arrPolitician[indexPath.row]
            let width = text.size(OfFont: AppFont.regular.font(size: 14)).width
            return CGSize(width: width + 20, height: collectionView.frame.height - 10)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}