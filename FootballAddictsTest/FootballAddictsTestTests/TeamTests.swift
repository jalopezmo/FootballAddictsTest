//
//  TeamTests.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 11/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import XCTest

@testable import FootballAddictsTest

class TeamTests: XCTestCase {
    
    func testTeamSetsNameWithInit() {
        let name = "TestName"
        let sut = Team(name: name)
        XCTAssertEqual(name, sut.name)
    }
    
    func testCompareTwoTeams() {
        let name1 = "NameA"
        let name2 = "NameB"
        
        let team1 = Team(name: name1)
        let team2 = Team(name: name1)
        let team3 = Team(name: name2)
        
        XCTAssertEqual(team1, team2)
        XCTAssertNotEqual(team1, team3)
    }
}
