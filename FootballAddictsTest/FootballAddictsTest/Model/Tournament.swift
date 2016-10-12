//
//  Tournament.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 11/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import Foundation

struct Tournament {
    
    enum MatchIndex:Int {
        case NotValid = -1
    }
    
    var matchArray:[Match]
    var stages:Int
    
    init?(matchArray:[Match]) {
        
        let log = log2(Double(matchArray.count))
        
        if floor(log) == log {
            self.stages = Int(log) + 1
            self.matchArray = matchArray
            
            while(self.matchArray.count < Int(pow(2, Double(self.stages))) - 1) {
                if let match = Match(teamOne: nil, teamTwo: nil, score: nil, state: .NotPlayed) {
                    self.matchArray.append(match)
                }
            }
        }
        else {
            return nil
        }
    }
    
    private mutating func updateMatchScoreWithMatchNumber(matchNumber:Int, score:Score) {
        if(matchNumber >= 0 && matchNumber < self.matchArray.count) {
            self.matchArray[matchNumber].updateScore(score)
        }
    }
    
    mutating func updateMatchWithStage(stage:Int, matchInStage:Int, score:Score?, winningTeam:MatchState.WinningTeam?) {
        //This method updates a match inside a stage, for example: in a 16 team knock out tournament, there are 4 stages: round of 8,
        //quarter finals, semifinals and final. That would mean in stage 1 there are 8 matches, in the second 4 and so on.
        //If I want to update the first semifinal this method would have to be summoned like: 
        //tournament.updateMatchWith(stage:3, matchInStage:1,score:[score])
        
        let matchIndex = self.getMatchArrayIndexWithStage(stage, matchInStage: matchInStage)
        
        if(matchIndex == MatchIndex.NotValid.rawValue) {
            return
        }
        
        if let score = score {
            self.updateMatchScoreWithMatchNumber(matchIndex, score: score)
        }
        
        if let winningTeam = winningTeam {
            let winningTeam = winningTeam == .TeamOne ? self.matchArray[matchIndex].teamOne : self.matchArray[matchIndex].teamTwo
            
            self.updateTeamOnNextStageMatchWithStage(stage, matchInStage: matchInStage, teamToAdd: winningTeam)
        }
    }
    
    private mutating func updateTeamOnNextStageMatchWithStage(stage:Int, matchInStage:Int, teamToAdd:Team) {
        if(stage == self.stages || stage < 1) {
            //we are at the final or have an invalid value, nothing to update
            return
        }
        
        let nextStage = stage + 1
        let nextMatchInStage = Int(ceil(Double(matchInStage)/2))
        
        let matchIndex = self.getMatchArrayIndexWithStage(nextStage, matchInStage: nextMatchInStage)
        
        if(matchIndex == MatchIndex.NotValid.rawValue) {
            return
        }
        
        var matchToBeEdited = self.matchArray[matchIndex]
        
        if(matchToBeEdited.teamOne.name == Team.noTeamName) {
            matchToBeEdited.teamOne = teamToAdd
        }
        else if(matchToBeEdited.teamTwo.name == Team.noTeamName) {
            matchToBeEdited.teamTwo = teamToAdd
        }
        
        self.matchArray[matchIndex] = matchToBeEdited
    }
    
    private func getMatchArrayIndexWithStage(stage:Int, matchInStage:Int) -> Int {
        var indexOffset = 0
        
        if(stage < 1 || stage > self.stages) {
            return MatchIndex.NotValid.rawValue
        }
        else if(stage > 1) {
            for count in 1...(stage - 1) {
                indexOffset += Int(pow(2, Double(self.stages - count)))
            }
        }
        
        return indexOffset + matchInStage - 1
    }
}