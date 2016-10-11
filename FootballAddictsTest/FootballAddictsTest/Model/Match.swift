//
//  Match.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 11/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import Foundation

struct Match {
    var teamOne : Team
    var teamTwo : Team
    var score : String?
    var state : MatchState
    
    init?(teamOne:Team?, teamTwo:Team?, score:String?, state:MatchState) {
        
        if(teamOne == teamTwo && teamOne != nil && teamTwo != nil) {
            return nil
        }
        
        if(state == .Played) {
            if score == nil {
                return nil
            }
        }
        
        if let teamOne = teamOne, teamTwo = teamTwo {
            self.teamOne = teamOne
            self.teamTwo = teamTwo
        }
        else {
            self.teamOne = Team(name: Team.noTeamName)
            self.teamTwo = Team(name: Team.noTeamName)
        }
        
        self.state = state
        
        if let score = score {
            self.score = score
        }
    }
    
    mutating func updateScore(newScore:String) {
        self.state = .Played
        self.score = newScore
    }
}