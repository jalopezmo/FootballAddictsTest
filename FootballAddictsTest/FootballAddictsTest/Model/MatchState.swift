//
//  MatchState.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 11/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import Foundation

enum MatchState {
    enum PlayedState:Int {
        case NotPlayed, Played
    }
    
    enum WinningTeam:Int {
        case TeamOne, TeamTwo
    }
}