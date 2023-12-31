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
    func pollsListItem( _ cell: AppTableViewCell, updateHeight: Void)
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
    private var isPercentageShow : Bool  {
        get {
            if let poll = pollsObj, (poll.pollPercent?.count ?? 0) > 0{
                let isOption = poll.pollPercent?.compactMap({ (key: String, value: DoubleCast) in
                    if (Double(value.stringValue ?? "0") ?? 0) > 0 {
                        return true
                    }
                    return nil
                })
                if (isOption?.count ?? 0) > 0 {
                    return true
                }
                else {
                    return false
                }
            } else {
                return false
            }
        }
    }
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
                            self.layoutIfNeeded()
                            delegate?.pollsListItem(self, updateHeight: Void())
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
        let layout1 = OTLTagFlowLayout()
        layout1.spacing = 0
        layout1.padding = 0
        layout1.minimumLineSpacing = 0
        layout1.scrollDirection = .vertical
        layout1.minimumInteritemSpacing = 0
        layout1.estimatedItemSize = CGSize(width: 140, height: 30)
        collecTreds.collectionViewLayout = layout1
        
        lblQuestion.setTheme("", font: .medium, size: 18)
        
        tblOptionsList.register(["PollListSubitemCell"], delegate: self, dataSource: self)
        
        lblVote.setTheme("0 Vote", color: .gray, size: 14, lines: 1)
        dotView.layer.cornerRadius = dotView.frame.height/2
        dotView.backgroundColor = .black
        lblTimeLeft.setTheme("", color: .gray, size: 14, lines: 1)
    }

    func removeObserverItem() {
        if collecTreds.observationInfo != nil {
            collecTreds.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    func setData(_ object: PollModel, date: Date, delegate:PollsListItemDelegate) {
        self.pollsObj = object
        self.delegate = delegate
        
        collecTreds.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        constTBLOptionsListHeight.constant = CGFloat((10 + 45) * (object.options?.count ?? 0))
        collecTreds.reloadData()
        tblOptionsList.reloadData()
        
        
        imgProfile.setImage(object.user?.profilePhotoURL)
        lblProfileName.text = object.user?.name
        lblDateTime.text = OTLDateConvert.instance.convert(date: object.createdAt ?? "", set: .yyyyMMdd_T_HHmmssDotssZ, getFormat: .mmmDDyyyyAthhmma)
        
        lblQuestion.text = object.question ?? ""
        
        lblVote.text = "\(object.votesCount ?? 0) Vote"
        if let endDate = object.endDate {
            let dateObj = OTLDateConvert.instance.convert(string: endDate, toDate: .yyyyMMdd_HHmm)
            lblTimeLeft.text = OTLDateConvert.instance.getDateDiff(startDate: dateObj, end: date, subString: "Left")
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
            let width = text.size(OfFont: AppFont.regular.font(size: 10)).width + 15
            if width < 55 {
                return CGSize(width: 55, height: 30)
            }
            else {
                return CGSize(width: width, height: 30)
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
                if isPercentageShow {
                    cell.setTitle(obj, percent: pollsObj?.pollPercent ?? [:], isShowPercent: isPercentageShow)
                } else {
                    cell.setTitle(obj, percent: pollsObj?.pollPercent ?? [:])
                }
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
