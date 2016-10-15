//
//  ViewController.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 11/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import UIKit

class TournamentViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mainScrollView:UIScrollView!
    
    var tournament:Tournament?
    var matchViewFrameArray = [CGRect]()
    
    private enum ExpandedBounds:CGFloat {
        case width = 350
        case height = 300
    }
    
    //This constant is used to separate the lines from any other sublayers, so that we avoid
    //deleting wrong UI content
    private static let LinesZPosition:CGFloat = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Since this class is expected to work out of the box, the tournament can be
        //initialized with a match array for the first stage (the idea is to update the
        //matches manually when you click them), or simply with a first stage match count
        //where you could click the cell and input the team names.
        
        //This would be the way of initializing a tournament just with the first stage count
        tournament = Tournament(firstStageMatchCount: 8)
        
        //And the way below is the one for it to be initialized with matches for the first
        //stage: (just create a match array and pass it as a parameter to the initializer)
        
//        let match1 = Match(teamOne: Team(name:"Borussia"), teamTwo: Team(name:"Bayern"), score: nil, state: .NotPlayed)
//        let match2 = Match(teamOne: Team(name:"Real Madrid"), teamTwo: Team(name:"Barcelona"), score: nil, state: .NotPlayed)
//        let match3 = Match(teamOne: Team(name:"PSG"), teamTwo: Team(name:"Marseille"), score: nil, state: .NotPlayed)
//        let match4 = Match(teamOne: Team(name:"Manchester City"), teamTwo: Team(name:"Napoli"), score: nil, state: .NotPlayed)
//        let match5 = Match(teamOne: Team(name:"Manchester United"), teamTwo: Team(name:"Arsenal"), score: nil, state: .NotPlayed)
//        let match6 = Match(teamOne: Team(name:"Liverpool"), teamTwo: Team(name:"Leichester"), score: nil, state: .NotPlayed)
//        let match7 = Match(teamOne: Team(name:"Atlético de Madrid"), teamTwo: Team(name:"Athletic Bilbao"), score: nil, state: .NotPlayed)
//        let match8 = Match(teamOne: Team(name:"Inter de Milan"), teamTwo: Team(name:"Porto"), score: nil, state: .NotPlayed)
//        
//        tournament = Tournament(matchArray: [match1!, match2!, match3!, match4!, match5!, match6!, match7!, match8!])
        
        guard let tournament = tournament else {
            return
        }
        
        defineScrollViewContentSizeWithTournament(tournament)
        initViewWithTournament(tournament)
        
        updateScrollViewContent(getVisibleIndexes())
    }

    private func defineScrollViewContentSizeWithTournament(tournament:Tournament) {
        //This method calculates the inner content size for the mainScrollView
        let totalWidth = CGFloat(tournament.stages * (MatchView.Constants.Measures.Width.rawValue + 2*MatchView.Constants.Measures.HorizontalDistance.rawValue))
        
        let totalHeight = CGFloat(tournament.getMatchCountForStage(1)*(MatchView.Constants.Measures.Height.rawValue + MatchView.Constants.Measures.VerticalDistance.rawValue) + MatchView.Constants.Measures.Height.rawValue)
        
        mainScrollView.contentSize = CGSizeMake(totalWidth, totalHeight)
    }
    
    private func initViewWithTournament(tournament:Tournament) {
        //This method creates the array so we can know exactly where each view will be placed
        //I do it this way, because it spends less memory than storing the views
        
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
        //The vertical offset depends directly on which stage we are in, the matchView must be placed between
        //the previous matchViews, except for the first stage.
        
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
        //This method updates the UI once scrolling stops
        updateScrollViewContent(getVisibleIndexes())
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //This method updates the UI once scrolling stops
        if !decelerate {
            updateScrollViewContent(getVisibleIndexes())
        }
    }
    
    func getVisibleIndexes() -> [Int] {
        //This method gets the current visible index array so we can know which
        //views to paint, improving memory usage
        return matchViewFrameArray.filter{
            return getCurrentExtendedBounds().contains($0)
        }.map{
            let index = (matchViewFrameArray.indexOf($0))!
            return matchViewFrameArray.startIndex.distanceTo(index)
        }
    }
    
    func updateScrollViewContent(visibleIndexes:[Int]) {
        //Here's where the magic happens. We get an extended frame, defined at the enum on top
        //of this file. We find which views are inside that extended frame and paint the new ones,
        //letting alone the ones that are already there
        
        guard let tournament = tournament else {
            return
        }
        
        let extendedBounds = getCurrentExtendedBounds()
        
        mainScrollView.layer.sublayers?.filter{return $0.zPosition == TournamentViewController.LinesZPosition}.forEach{
            $0.removeFromSuperlayer()
        }
        
        mainScrollView.subviews.filter{!extendedBounds.contains($0.frame)}.forEach{$0.removeFromSuperview()}
        
        let alreadyVisible:[Int] = mainScrollView.subviews.map{
            if let matchView = $0 as? MatchView {
                matchView.configureViewWithMatch(tournament.matchArray[matchView.matchAbsoluteIndex!], stage: matchView.matchStage!, inStageIndex: matchView.matchInStageIndex!, absoluteIndex: matchView.matchAbsoluteIndex!)
                return matchView.matchAbsoluteIndex!
            }
            
            return -1
        }
        
        for i in visibleIndexes {
            
            if alreadyVisible.contains(i) {
                continue
            }
            
            let stageAndIndexInStage = tournament.getMatchStageAndStageIndexWithArrayIndex(i)
            
            let stage = stageAndIndexInStage.0
            let indexInStage = stageAndIndexInStage.1
            
            let matchView = MatchView.init(frame: matchViewFrameArray[i])
            matchView.delegate = self
            matchView.alpha = 0
            matchView.configureViewWithMatch(tournament.matchArray[i], stage: stage, inStageIndex: indexInStage, absoluteIndex: i)
            mainScrollView.addSubview(matchView)
            
            UIView.animateWithDuration(0.3, animations: {
                matchView.alpha = 1
            })
        }
        
        mainScrollView.subviews.forEach{
            if let matchView = $0 as? MatchView {
                drawLineForMatchView(matchView)
            }
        }
    }
    
    func getCurrentExtendedBounds() -> CGRect {
        //This method gets the extended frame based on the current visible frame
        let bounds = mainScrollView.bounds
        
        let newX = bounds.origin.x - ExpandedBounds.width.rawValue/2
        let newY = bounds.origin.y - ExpandedBounds.height.rawValue/2
        let newW = bounds.width + ExpandedBounds.width.rawValue
        let newH = bounds.height + ExpandedBounds.height.rawValue
        
        return CGRectMake(newX,newY,newW,newH)
    }
    
    func drawLineForMatchView(matchView:MatchView) {
        //This method draws the line that connect stages from the second up with the
        //matches where the teams participating in the current match where decided.
        guard let tournament = tournament else {
            return
        }
        
        if(matchView.matchStage > 1) {
            let previousMatchOneIndex = tournament.getMatchArrayIndexWithStage(matchView.matchStage!-1, matchInStage: matchView.matchInStageIndex!*2 - 1)
            let previousMatchTwoIndex = tournament.getMatchArrayIndexWithStage(matchView.matchStage!-1, matchInStage: matchView.matchInStageIndex!*2)
            
            var points = [CGPoint]()
            let previousMatchOneFrame = matchViewFrameArray[previousMatchOneIndex]
            let previousMatchTwoFrame = matchViewFrameArray[previousMatchTwoIndex]
            let currentFrame = matchView.frame
            
            let distanceBetweenStages = currentFrame.origin.x - (previousMatchOneFrame.origin.x + previousMatchOneFrame.width)
            
            points.append(CGPoint(x: previousMatchOneFrame.origin.x + previousMatchOneFrame.width, y: previousMatchOneFrame.origin.y + previousMatchOneFrame.height/2))
            points.append(CGPoint(x: previousMatchTwoFrame.origin.x + previousMatchTwoFrame.width, y: previousMatchTwoFrame.origin.y + previousMatchTwoFrame.height/2))
            points.append(CGPoint(x: currentFrame.origin.x - distanceBetweenStages/2, y: currentFrame.origin.y + currentFrame.height/2))
            points.append(CGPoint(x: currentFrame.origin.x, y: currentFrame.origin.y + currentFrame.height/2))
            points.append(CGPoint(x: previousMatchOneFrame.origin.x + previousMatchOneFrame.width + distanceBetweenStages/2, y: previousMatchOneFrame.origin.y + previousMatchOneFrame.height/2))
            points.append(CGPoint(x: previousMatchTwoFrame.origin.x + previousMatchTwoFrame.width + distanceBetweenStages/2, y: previousMatchTwoFrame.origin.y + previousMatchTwoFrame.height/2))
            
            
            let previousMatchesLine = UIBezierPath()
            previousMatchesLine.moveToPoint(points[0])
            previousMatchesLine.addLineToPoint(points[4])
            previousMatchesLine.addLineToPoint(points[5])
            previousMatchesLine.addLineToPoint(points[1])
            previousMatchesLine.moveToPoint(points[2])
            previousMatchesLine.addLineToPoint(points[3])
            
            let layer = CAShapeLayer()
            layer.lineWidth = 2
            layer.strokeColor = UIColor.grayColor().CGColor
            layer.fillColor = UIColor.clearColor().CGColor
            layer.path = previousMatchesLine.CGPath
            layer.zPosition = TournamentViewController.LinesZPosition
            self.mainScrollView.layer.addSublayer(layer)
        }
    }
    
    func alertToUpdateScoreForMatch(stage:Int, indexInStage:Int, selectedMatch:Match) {
        
        let alertController = UIAlertController(title: "Update the scores", message: "Please input the team scores", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
            if let teamOneField = alertController.textFields?[0].text, let teamTwoField = alertController.textFields?[1].text {
                
                guard let teamOneScore = Int(teamOneField), let teamTwoScore = Int(teamTwoField) else {
                    return
                }
                
                let winningTeam : MatchState.WinningTeam = (teamOneScore > teamTwoScore) ? .TeamOne : .TeamTwo
                
                self.tournament?.updateMatchWithStage(stage, matchInStage: indexInStage, score: Score(teamOneScore: teamOneScore, teamTwoScore: teamTwoScore), winningTeam: winningTeam)
                
                self.updateScrollViewContent(self.getVisibleIndexes())
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = selectedMatch.teamOne.name + " score"
            textField.keyboardType = .NumberPad
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = selectedMatch.teamTwo.name + " score"
            textField.keyboardType = .NumberPad
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func alertToUpdateTeamsForMatch(absoluteIndex:Int) {
        
        let alertController = UIAlertController(title: "Update the team names", message: "Please input the team names", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
            if let teamOneName = alertController.textFields?[0].text, let teamTwoName = alertController.textFields?[1].text {
                
                if !teamOneName.isEmpty && !teamTwoName.isEmpty {
                    self.tournament?.matchArray[absoluteIndex].teamOne = Team(name: teamOneName)
                    self.tournament?.matchArray[absoluteIndex].teamTwo = Team(name: teamTwoName)
                    
                    self.updateScrollViewContent(self.getVisibleIndexes())
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "First team name"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Second team name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
//MARK: MatchView Delegate
extension TournamentViewController:MatchViewDelegate {
    func matchClicked(stage: Int, indexInStage: Int, absoluteIndex: Int) {
        
        guard let tournament = tournament else {
            return
        }
        
        let selectedMatch = tournament.matchArray[absoluteIndex]
        
        if stage == 1 {
            if tournament.matchArray[absoluteIndex].state == .NotPlayed {
                if selectedMatch.teamOne.name == Team.noTeamName || selectedMatch.teamTwo.name == Team.noTeamName {
                    alertToUpdateTeamsForMatch(absoluteIndex)
                }
                else {
                    alertToUpdateScoreForMatch(stage, indexInStage: indexInStage, selectedMatch: selectedMatch)
                }
            }
        }
        else {
            if tournament.matchArray[absoluteIndex].state == .NotPlayed {
                if tournament.matchArray[absoluteIndex].teamOne.name == Team.noTeamName || tournament.matchArray[absoluteIndex].teamTwo.name == Team.noTeamName {
                    
                    let alertController = UIAlertController(title: "Oops!", message: "This match cannot be updated until the two teams playing have been defined.", preferredStyle: .Alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .Cancel) { (_) in }
                    alertController.addAction(okAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else {
                    alertToUpdateScoreForMatch(stage, indexInStage: indexInStage, selectedMatch: selectedMatch)
                }
            }
        }
        
        if tournament.matchArray[absoluteIndex].state == .Played {
            let alertController = UIAlertController(title: "Oops!", message: "This match has already been played.", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .Cancel) { (_) in }
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

