//
//  ViewPoliticianScorecard.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 15/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit
import OTLContaner

class ViewPoliticianScorecard: UIView {
    
    @IBOutlet private weak var lblViewTitle: UILabel!
    
    @IBOutlet private weak var viewTotalVotes: UIView!
    @IBOutlet private weak var lblTotalVotes: UILabel!
    @IBOutlet private weak var lblTotalVotesValue: UILabel!
    
    @IBOutlet private weak var viewMissedVotes: UIView!
    @IBOutlet private weak var lblMissedVotes: UILabel!
    @IBOutlet private weak var lblMissedVotesValue: UILabel!
    
    @IBOutlet private weak var viewTotalPresent: UIView!
    @IBOutlet private weak var lblTotalPresent: UILabel!
    @IBOutlet private weak var lblTotalPresentValue: UILabel!
    
   
    @IBOutlet private weak var lblMissedVotesPercentage: UILabel!
    @IBOutlet private weak var lblMissedVotesPercentageValue: UILabel!
    @IBOutlet private weak var progMissedVotesPercentage: OTLProgressView!
    
    @IBOutlet private weak var lblVotesWithPartyPercentage: UILabel!
    @IBOutlet private weak var lblVotesWithPartyPercentageValue: UILabel!
    @IBOutlet private weak var progVotesWithPartyPercentage: OTLProgressView!
    
    @IBOutlet private weak var lblVotesAgainstPartyPercentage: UILabel!
    @IBOutlet private weak var lblVotesAgainstPartyPercentageVlaue: UILabel!
    @IBOutlet private weak var progVotesAgainstPartyPercentage: OTLProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 10
        
        lblViewTitle.setTheme(LocalStrings.POLI_SCORE_TITLE.rawValue.addLocalizableString(), font: .bold,size: 20)
        
        lblTotalVotes.setTheme(LocalStrings.POLI_SCORE_VOTE.rawValue.addLocalizableString(),font: .bold, size: 14)
        lblTotalVotesValue.setTheme("0", color: .primaryBlue, font: .bold, size: 14)
        
        lblMissedVotes.setTheme(LocalStrings.POLI_SCORE_MISS_VOTE.rawValue.addLocalizableString(),font: .bold, size: 14)
        lblMissedVotesValue.setTheme("0", color: .primaryBlue, font: .bold, size: 14)
        
        lblTotalPresent.setTheme(LocalStrings.POLI_SCORE_PRESENT.rawValue.addLocalizableString(),font: .bold, size: 14)
        lblTotalPresentValue.setTheme("0", color: .primaryBlue, font: .bold, size: 14)
        
        for view in [viewTotalVotes, viewMissedVotes, viewTotalPresent] {
            view?.backgroundColor = .white
            view?.setIn4SideShadow()
        }
        
        lblMissedVotesPercentage.setTheme(LocalStrings.POLI_SCORE_MISS_VOTE_PERCENTAGE.rawValue.addLocalizableString(),font: .bold, size: 14)
        lblMissedVotesPercentageValue.setTheme("(0.0%)", color: .primaryBlue, font: .bold, size: 14)
        progMissedVotesPercentage.progress = 0
        progMissedVotesPercentage.trackTintColor = .lightGrey
        progMissedVotesPercentage.progressTintColor = .primaryBlue
        
        lblVotesWithPartyPercentage.setTheme(LocalStrings.POLI_SCORE_PARTY_PERCENTAGE.rawValue.addLocalizableString(),font: .bold, size: 14)
        lblVotesWithPartyPercentageValue.setTheme("(0.0%)", color: .primaryBlue, font: .bold, size: 14)
        progVotesWithPartyPercentage.progress = 0
        progVotesWithPartyPercentage.trackTintColor = .lightGrey
        progVotesWithPartyPercentage.progressTintColor = .green
        
        lblVotesAgainstPartyPercentage.setTheme(LocalStrings.POLI_SCORE_AGAINST_PARTY_PERCENTAGE.rawValue.addLocalizableString(),font: .bold, size: 14)
        lblVotesAgainstPartyPercentageVlaue.setTheme("(0.0%)", color: .primaryBlue, font: .bold, size: 14)
        progVotesAgainstPartyPercentage.progress = 0
        progVotesAgainstPartyPercentage.trackTintColor = .lightGrey
        progVotesAgainstPartyPercentage.progressTintColor = .titleRed
    }
    
    func setData(_ user: PostUser){
        lblTotalVotesValue.text =  getValueOrDefult(user.totalVotes, defaultValue: "--")
        lblMissedVotesValue.text = getValueOrDefult(user.missedVotes, defaultValue: "--")
        lblTotalPresentValue.text = getValueOrDefult(user.totalPresent, defaultValue: "--")
        
        lblMissedVotesPercentageValue.text = "(\(getValueOrDefult(user.missedVotesPct, defaultValue: "0.0"))%)"
        progMissedVotesPercentage.progress = Float(Double(user.missedVotesPct ?? "0.0") ?? 0) / 100
        lblVotesWithPartyPercentageValue.text = "(\(getValueOrDefult(user.votesWithPartyPct, defaultValue: "0.0"))%)"
        progVotesWithPartyPercentage.progress = Float(Double(user.votesWithPartyPct ?? "0.0") ?? 0) / 100
        lblVotesAgainstPartyPercentageVlaue.text = "(\(getValueOrDefult(user.votesAgainstPartyPct, defaultValue: "0.0"))%)"
        progVotesAgainstPartyPercentage.progress = Float(Double(user.votesAgainstPartyPct ?? "0.0") ?? 0) / 100
    }
}
