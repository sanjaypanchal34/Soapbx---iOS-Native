//
//  PollsListItemCell.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 15/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit
import OTLContaner

protocol PollsListItemDelegate {
    func pollsListItem( _ cell: AppTableViewCell, vote poll: PollModel, option: Option)
}

class PollsListItemCell: AppTableViewCell {

    @IBOutlet private weak var imgProfile: UIImageView!
    @IBOutlet private weak var lblProfileName: UILabel!
    @IBOutlet private weak var lblDateTime: UILabel!
    
    @IBOutlet private weak var collecTreds: UICollectionView!
    @IBOutlet private weak var constCollecTredsHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var lblQuestion: UILabel!
    @IBOutlet private weak var tblOptionsList: UITableView!
    @IBOutlet private weak var constTBLOptionsListHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var lblVote: UILabel!
    @IBOutlet private weak var dotView: UIView!
    @IBOutlet private weak var lblTimeLeft: UILabel!
    
    private var pollsObj: PollModel?
    private var delegate:PollsListItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
   
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let object = object as? UICollectionView{
                if object == collecTreds {
                    if let newvalue = change?[.newKey], let newsize  = newvalue as? CGSize{
                        if constCollecTredsHeight != nil {
                            constCollecTredsHeight?.constant = newsize.height
                        }
                    }
                }
            }
        }
    }
    
    
    private func setupUI() {
        viewMain.backgroundColor = .white
        viewMain.layer.cornerRadius = 10
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.contentMode = .scaleAspectFill
        lblProfileName.setTheme("",font: .bold, lines: 1)
        lblDateTime.setTheme("", color: .gray, size: 14, lines: 1)
        
        collecTreds.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        let layout = OTLTagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 120, height: 40)
        collecTreds.collectionViewLayout = layout
        
        lblQuestion.setTheme("", font: .medium, size: 18)
        
        tblOptionsList.register(["PollListSubitemCell"], delegate: self, dataSource: self)
        
        lblVote.setTheme("0 Vote", color: .gray, size: 14, lines: 1)
        dotView.layer.cornerRadius = dotView.frame.height/2
        dotView.backgroundColor = .black
        lblTimeLeft.setTheme("", color: .gray, size: 14, lines: 1)
    }

    func removeObserverItem() {
        collecTreds.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func setData(_ object: PollModel, delegate:PollsListItemDelegate) {
        self.pollsObj = object
        self.delegate = delegate
        
        collecTreds.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        constTBLOptionsListHeight.constant = CGFloat((10 + 45) * (object.options?.count ?? 0))
        collecTreds.reloadData()
        tblOptionsList.reloadData()
        
        
        imgProfile.setImage(object.user?.profilePhotoURL)
        lblProfileName.text = object.user?.name
        lblDateTime.text = OTLDateConvert.instance.convert(date: object.createdAt ?? "", set: .yyyyMMdd_T_HHmmssZ, getFormat: .mmmDDyyyyAthhmma)
        
        lblQuestion.text = object.question ?? ""
        
        lblVote.text = "\(object.votesCount ?? 0) Vote"
        if let endDate = object.endDate {
            let dateObj = OTLDateConvert.instance.convert(string: endDate, toDate: .yyyyMMdd_HHmm)
            lblTimeLeft.text = OTLDateConvert.instance.getDateDiff(startDate: dateObj, end: Date(), subString: "Left")
        }
        
    }
    
    func updateValue(_ object: PollModel) {
        self.pollsObj = object
        tblOptionsList.reloadData()
    }
}
extension PollsListItemCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = pollsObj?.tag?[indexPath.row].trend?.name ?? ""
            let width = text.size(OfFont: AppFont.regular.font(size: 14)).width + 20
            if width < 55 {
                return CGSize(width: 55, height: 35)
            }
            else {
                return CGSize(width: width, height: 35)
            }
    }
}
extension PollsListItemCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pollsObj?.tag?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell{
            if let trad = pollsObj?.tag?[indexPath.row].trend {
                cell.setCreatePostPoll(trad)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
extension PollsListItemCell : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pollsObj?.options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PollListSubitemCell") as? PollListSubitemCell {
            if let obj = pollsObj?.options?[indexPath.row] {
                cell.setTitle(obj, percent: pollsObj?.pollPercent ?? [:])
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let poll = pollsObj, let option = poll.options?[indexPath.row] {
            delegate?.pollsListItem(self, vote: poll, option: option)
        }
    }
}
