//
//  ViewController.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 11/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mainScrollView:UIScrollView!
    
    var tournament:Tournament?
    var matchViewFrameArray = [CGRect]()
    
    private enum ExpandedBounds:CGFloat {
        case width = 350
        case height = 300
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tournament = Tournament(firstStageMatchCount: 16)
        
        guard let tournament = tournament else {
            return
        }
        
        defineScrollViewContentSizeWithTournament(tournament)
        initViewWithTournament(tournament)
        
        updateScrollViewContent(getVisibleIndexes())
    }

    private func defineScrollViewContentSizeWithTournament(tournament:Tournament) {
        let totalWidth = CGFloat(tournament.stages * (MatchView.Constants.Measures.Width.rawValue + 2*MatchView.Constants.Measures.HorizontalDistance.rawValue))
        
        let totalHeight = CGFloat(tournament.getMatchCountForStage(1)*(MatchView.Constants.Measures.Height.rawValue + MatchView.Constants.Measures.VerticalDistance.rawValue) + MatchView.Constants.Measures.Height.rawValue)
        
        mainScrollView.contentSize = CGSizeMake(totalWidth, totalHeight)
    }
    
    private func initViewWithTournament(tournament:Tournament) {
        for i in 0..<tournament.matchArray.count {
            let stageAndIndexInStage = tournament.getMatchStageAndStageIndexWithArrayIndex(i)
            
            let stage = stageAndIndexInStage.0
            let indexInStage = stageAndIndexInStage.1
            
            var verticalOffset:CGFloat
            
            verticalOffset = getVerticalOffsetForMatchWithStage(stage,indexInStage: indexInStage, tournament: tournament)
            
            let horizontalOffset = (stage-1)*(MatchView.Constants.Measures.Width.rawValue + 2*MatchView.Constants.Measures.HorizontalDistance.rawValue) + MatchView.Constants.Measures.HorizontalDistance.rawValue
            
            matchViewFrameArray.append(CGRectMake(CGFloat(horizontalOffset), verticalOffset, CGFloat(MatchView.Constants.Measures.Width.rawValue), CGFloat(MatchView.Constants.Measures.Height.rawValue)))
        }
    }
    
    private func getVerticalOffsetForMatchWithStage(stage:Int, indexInStage:Int, tournament:Tournament) -> CGFloat {
        if(stage > 1) {
            let previousMatchOneIndex = tournament.getMatchArrayIndexWithStage(stage-1, matchInStage: indexInStage*2 - 1)
            let previousMatchTwoIndex = tournament.getMatchArrayIndexWithStage(stage-1, matchInStage: indexInStage*2)
            
            let y0 = matchViewFrameArray[previousMatchOneIndex].origin.y
            let y1 = matchViewFrameArray[previousMatchTwoIndex].origin.y
            
            return y0 + ((y1 - y0 + CGFloat(MatchView.Constants.Measures.Height.rawValue))/2) - CGFloat(MatchView.Constants.Measures.Height.rawValue)/2
        }
        else {
            return (CGFloat(indexInStage-1))*CGFloat(MatchView.Constants.Measures.Height.rawValue + MatchView.Constants.Measures.VerticalDistance.rawValue) + CGFloat(MatchView.Constants.Measures.VerticalDistance.rawValue)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        updateScrollViewContent(getVisibleIndexes())
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateScrollViewContent(getVisibleIndexes())
        }
    }
    
    func getVisibleIndexes() -> [Int] {
        
        return matchViewFrameArray.filter{
            return getCurrentExtendedBounds().contains($0)
        }.map{
            let index = (matchViewFrameArray.indexOf($0))!
            return matchViewFrameArray.startIndex.distanceTo(index)
        }
    }
    
    func updateScrollViewContent(visibleIndexes:[Int]) {
        let extendedBounds = getCurrentExtendedBounds()
        
        mainScrollView.subviews.filter{!extendedBounds.contains($0.frame)}.forEach{$0.removeFromSuperview()}
        
        let alreadyVisible:[Int] = mainScrollView.subviews.map{
            if let matchView = $0 as? MatchView {
                return matchView.matchAbsoluteIndex!
            }
            
            return -1
        }
        
        guard let tournament = tournament else {
            return
        }
        
        for i in visibleIndexes {
            
            if alreadyVisible.contains(i) {
                continue
            }
            
            let stageAndIndexInStage = tournament.getMatchStageAndStageIndexWithArrayIndex(i)
            
            let stage = stageAndIndexInStage.0
            let indexInStage = stageAndIndexInStage.1
            
            let matchView = MatchView.init(frame: matchViewFrameArray[i])
            matchView.alpha = 0
            matchView.configureViewWithMatch(tournament.matchArray[i], stage: stage, inStageIndex: indexInStage, absoluteIndex: i)
            mainScrollView.addSubview(matchView)
            
            UIView.animateWithDuration(0.3, animations: {
                matchView.alpha = 1
            })
        }
    }
    
    func getCurrentExtendedBounds() -> CGRect {
        let bounds = mainScrollView.bounds
        
        let newX = bounds.origin.x - ExpandedBounds.width.rawValue/2
        let newY = bounds.origin.y - ExpandedBounds.height.rawValue/2
        let newW = bounds.width + ExpandedBounds.width.rawValue
        let newH = bounds.height + ExpandedBounds.height.rawValue
        
        return CGRectMake(newX,newY,newW,newH)
    }
}

