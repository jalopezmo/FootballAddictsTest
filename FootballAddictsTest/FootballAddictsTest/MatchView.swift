//
//  MatchView.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 12/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import UIKit

class MatchView: UIView {
    
    enum Constants {
        private enum Inner : String {
            case NoScore = "-"
        }
        
        enum Measures:Int {
            case Width = 170
            case Height = 50
            case HorizontalDistance = 20
            case VerticalDistance = 15
        }
    }
    
    @IBOutlet private var contentView:UIView!
    
    @IBOutlet weak var teamOneName:UILabel!
    @IBOutlet weak var teamTwoName:UILabel!
    
    @IBOutlet weak var teamOneScore:UILabel!
    @IBOutlet weak var teamTwoScore:UILabel!
    
    var matchStage:Int?
    var matchInStageIndex:Int?
    var matchAbsoluteIndex:Int?
    var delegate:MatchViewDelegate?
    
    @IBAction func matchTapped() {
        delegate?.matchClicked(matchStage!, indexInStage: matchInStageIndex!, absoluteIndex: matchAbsoluteIndex!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        NSBundle(forClass: MatchView.self).loadNibNamed("MatchView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.backgroundColor = UIColor.whiteColor()
        content.layer.cornerRadius = 4
        content.layer.borderWidth = 1.5
        content.layer.borderColor = UIColor.grayColor().CGColor
        content.frame = self.bounds
        content.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(content)
    }
    
    func configureViewWithMatch(match:Match, stage:Int, inStageIndex:Int, absoluteIndex:Int) {
        if match.teamOne.name == Team.noTeamName || match.teamTwo.name == Team.noTeamName || match.score == nil {
            teamOneScore.text = Constants.Inner.NoScore.rawValue
            teamTwoScore.text = Constants.Inner.NoScore.rawValue
        }
        
        teamOneName.text = match.teamOne.name
        teamTwoName.text = match.teamTwo.name
        
        if let score = match.score {
            teamOneScore.text = String(score.teamOneScore)
            teamTwoScore.text = String(score.teamTwoScore)
        }
        
        matchStage = stage
        matchInStageIndex = inStageIndex
        matchAbsoluteIndex = absoluteIndex
    }
}
protocol MatchViewDelegate {
    func matchClicked(stage:Int, indexInStage:Int, absoluteIndex:Int)
}
