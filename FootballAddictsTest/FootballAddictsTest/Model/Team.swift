//
//  Team.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 11/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import Foundation

struct Team {
    static let noTeamName = "To Be Defined"
    
    var name:String
}

extension Team: Equatable {}

func ==(lhs: Team, rhs: Team) -> Bool {
    return lhs.name == rhs.name
}