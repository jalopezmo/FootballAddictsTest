//
//  Score.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 11/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import Foundation

struct Score {
    var teamOneScore:Int
    var teamTwoScore:Int
}

extension Score: Equatable {}

func ==(lhs: Score, rhs: Score) -> Bool {
    return lhs.teamOneScore == rhs.teamOneScore && lhs.teamTwoScore == rhs.teamTwoScore
}