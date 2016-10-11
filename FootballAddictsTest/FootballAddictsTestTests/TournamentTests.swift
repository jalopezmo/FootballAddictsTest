//
//  TournamentTests.swift
//  FootballAddictsTest
//
//  Created by Jaime Andres Lopez Mora on 11/10/16.
//  Copyright © 2016 JaimeLopez. All rights reserved.
//

import XCTest

@testable import FootballAddictsTest

class TournamentTests: XCTestCase {

    func testTournamentInit() {
        let teamOne = Team(name: "Borussia")
        let teamTwo = Team(name: "Bayern")
        
        let match1 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match2 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match3 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match4 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match5 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match6 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match7 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match8 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        
        let sut = Tournament(matchArray: [match1!,match2!,match3!,match4!,match5!,match6!,match7!,match8!])
        
        XCTAssertNotNil(sut)
    }
    
    func testTournamentIsNilWhenMatchNumberIsNotPowerOfTwo() {
        let teamOne = Team(name: "Borussia")
        let teamTwo = Team(name: "Bayern")
        
        let match1 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match2 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match3 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match4 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match5 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match6 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match7 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match8 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match9 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match10 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        
        let sut = Tournament(matchArray: [match1!,match2!,match3!,match4!,match5!,match6!,match7!,match8!,match9!,match10!])
        
        XCTAssertNil(sut)
    }
    
    func testTournamentMatchCountAfterInit() {
        let teamOne = Team(name: "Borussia")
        let teamTwo = Team(name: "Bayern")
        let expectedMatchCount = 15
        
        let match1 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match2 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match3 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match4 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match5 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match6 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match7 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match8 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        
        let sut = Tournament(matchArray: [match1!,match2!,match3!,match4!,match5!,match6!,match7!,match8!])
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut?.matchArray.count, expectedMatchCount)
    }
    
    func testTournamentUpdatesCorrectMatchWithStageIndexAndMatchNumber() {
        let teamOne = Team(name: "Borussia")
        let teamTwo = Team(name: "Bayern")
        
        let match1 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match2 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match3 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match4 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match5 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match6 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match7 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        let match8 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        
        var sut = Tournament(matchArray: [match1!,match2!,match3!,match4!,match5!,match6!,match7!,match8!])
        
        XCTAssertNotNil(sut)
        
        let expectedScore = "2:0"
        
        sut?.updateMatchWithStage(1, matchInStage: 1, score: expectedScore)
        
        XCTAssertEqual(expectedScore, sut?.matchArray[0].score)
        
        let secondExpectedScore = "3:1"
        sut?.updateMatchWithStage(2, matchInStage: 1, score: secondExpectedScore)
        XCTAssertEqual(secondExpectedScore, sut?.matchArray[8].score)
        
        let thirdExpectedScore = "3:2"
        sut?.updateMatchWithStage(4, matchInStage: 1, score: thirdExpectedScore)
        XCTAssertEqual(thirdExpectedScore, sut?.matchArray[14].score)
    }
}
