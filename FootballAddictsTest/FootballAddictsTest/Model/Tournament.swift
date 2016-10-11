//
//  Tournament.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 11/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import Foundation

struct Tournament {
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
    
    mutating func updateMatchWithMatchNumber(matchNumber:Int, score:String) {
        if(matchNumber >= 0 && matchNumber < self.matchArray.count) {
            self.matchArray[matchNumber].updateScore(score)
        }
    }
    
    mutating func updateMatchWithStage(stage:Int, matchInStage:Int, score:String) {
        //This method updates a match inside a stage, for example: in a 16 team knock out tournament, there are 4 stages: round of 8,
        //quarter finals, semifinals and final. That would mean in stage 1 there are 8 matches, in the second 4 and so on.
        //If I want to update the first semifinal this method would have to be summoned like: 
        //tournament.updateMatchWith(stage:3, matchInStage:1,score:[score])
        
        if(stage == 1) {
            self.updateMatchWithMatchNumber(matchInStage - 1, score: score)
        }
        else if(stage > 1 && stage <= self.stages) {
            var indexOffset = 0
            
            for count in 1...(stage - 1) {
                indexOffset += Int(pow(2, Double(self.stages - count)))
            }
            
            print("Updated match: \(indexOffset + matchInStage)")
            
            self.updateMatchWithMatchNumber(indexOffset + matchInStage - 1, score: score)
        }
    }
}