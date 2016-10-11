//
//  MatchTests.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 11/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import XCTest

@testable import FootballAddictsTest

class MatchTests: XCTestCase {

    func testMatchInit() {
        let teamOne = Team(name: "Borussia")
        let teamTwo = Team(name: "Bayern")
        let sut = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        
        XCTAssertNotNil(sut)
    }
    
    func testMatchNilWhenTeamsEqual() {
        let team = Team(name: "Borussia")
        let sut = Match(teamOne: team, teamTwo: team, score: nil, state: .NotPlayed)
        
        XCTAssertNil(sut)
    }
    
    func testMatchNilWhenPlayedButNoScore() {
        let teamOne = Team(name: "Borussia")
        let teamTwo = Team(name: "Bayern")
        let sut = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .Played)
        
        XCTAssertNil(sut)
    }
    
    func testMatchScoreWhenPlayed() {
        let teamOne = Team(name: "Borussia")
        let teamTwo = Team(name: "Bayern")
        let score = "2:0"
        let sut = Match(teamOne: teamOne, teamTwo: teamTwo, score: score, state: .Played)
        
        XCTAssertEqual(sut?.score, score)
    }
    
    func testUpdateMatchResult() {
        let teamOne = Team(name: "Borussia")
        let teamTwo = Team(name: "Bayern")
        var sut = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        
        XCTAssertNil(sut?.score)
        
        let score = "2:0"
        
        sut?.updateScore(score)
        
        XCTAssertEqual(sut?.score, score)
    }
    
    func testNilTeamsInit() {
        let noTeamName = Team(name:Team.noTeamName)
        let sut = Match(teamOne: nil, teamTwo: nil, score: nil, state: .NotPlayed)
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut?.teamOne, noTeamName)
        XCTAssertEqual(sut?.teamTwo, noTeamName)
    }
}
