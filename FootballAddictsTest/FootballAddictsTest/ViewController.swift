//
//  ViewController.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 11/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainScrollView:UIScrollView!
    
    var tournament:Tournament?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tournament = Tournament(firstStageMatchCount: 8)
        
        guard let tournament = tournament else {
            return
        }
        
        defineScrollViewContentSizeWithTournament(tournament)
        initViewWithTournament(tournament)
        
//        let test = MatchView.init(frame: CGRectMake(20, 20, 170, 50))
        
//        test.backgroundColor = UIColor.blueColor()
        
//        test.configureViewWithMatch(Match(teamOne: nil, teamTwo: nil, score: nil, state: .NotPlayed)!, stage: 1, inStageIndex: 1)
//        
//        mainScrollView.addSubview(test)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func defineScrollViewContentSizeWithTournament(tournament:Tournament) {
        let totalWidth = CGFloat(tournament.stages * (MatchView.Constants.Measures.Width.rawValue + 2*MatchView.Constants.Measures.HorizontalDistance.rawValue))
        
        let totalHeight = CGFloat(tournament.getMatchCountForStage(1)*(MatchView.Constants.Measures.Height.rawValue + MatchView.Constants.Measures.VerticalDistance.rawValue) + MatchView.Constants.Measures.Height.rawValue)
        
        print("Dimensions: \(totalWidth),\(totalHeight)")
        
        mainScrollView.contentSize = CGSizeMake(totalWidth, totalHeight)
    }
    
    private func initViewWithTournament(tournament:Tournament) {
        for i in 0..<tournament.matchArray.count {
            let stageAndIndexInStage = tournament.getMatchStageAndStageIndexWithArrayIndex(i)
            
            let stage = stageAndIndexInStage.0
            let indexInStage = stageAndIndexInStage.1
            
            let verticalOffset = (indexInStage-1)*(MatchView.Constants.Measures.Height.rawValue + MatchView.Constants.Measures.VerticalDistance.rawValue) + MatchView.Constants.Measures.VerticalDistance.rawValue
            
            //temp
            let horizontalOffset = (stage-1)*(MatchView.Constants.Measures.Width.rawValue + 2*MatchView.Constants.Measures.HorizontalDistance.rawValue) + MatchView.Constants.Measures.HorizontalDistance.rawValue
            
            let matchView = MatchView.init(frame: CGRectMake(CGFloat(horizontalOffset), CGFloat(verticalOffset), CGFloat(MatchView.Constants.Measures.Width.rawValue), CGFloat(MatchView.Constants.Measures.Height.rawValue)))
            
            matchView.configureViewWithMatch(tournament.matchArray[i], stage: stage, inStageIndex: indexInStage)
            
            mainScrollView.addSubview(matchView)
        }
    }
}

