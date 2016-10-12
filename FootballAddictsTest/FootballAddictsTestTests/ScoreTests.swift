//
//  ScoreTests.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 11/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import XCTest

@testable import FootballAddictsTest

class ScoreTests: XCTestCase {

    func testScoreInit() {
        let sut = Score(teamOneScore: 1, teamTwoScore: 3)
        
        XCTAssertEqual(sut.teamOneScore, 1)
        XCTAssertEqual(sut.teamTwoScore, 3)
    }
}
