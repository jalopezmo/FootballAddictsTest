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
    
    func testTournamentMatchAndStageCountAfterInit() {
        let teamOne = Team(name: "Borussia")
        let teamTwo = Team(name: "Bayern")
        let expectedMatchCount = 63
        let expectedStageCount = 6
        
        let match1 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        
        let sut = Tournament(matchArray: [match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!])
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut?.matchArray.count, expectedMatchCount)
        XCTAssertEqual(sut?.stages, expectedStageCount)
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
        
        let expectedScore = Score(teamOneScore: 2, teamTwoScore: 0)
        
        sut?.updateMatchWithStage(1, matchInStage: 1, score: expectedScore, winningTeam: .TeamOne)
        
        XCTAssertEqual(expectedScore, sut?.matchArray[0].score)
        
        let secondExpectedScore = Score(teamOneScore: 3, teamTwoScore: 1)
        sut?.updateMatchWithStage(2, matchInStage: 1, score: secondExpectedScore, winningTeam: .TeamOne)
        XCTAssertEqual(secondExpectedScore, sut?.matchArray[8].score)
        
        let thirdExpectedScore = Score(teamOneScore: 3, teamTwoScore: 2)
        sut?.updateMatchWithStage(4, matchInStage: 1, score: thirdExpectedScore, winningTeam: .TeamOne)
        XCTAssertEqual(thirdExpectedScore, sut?.matchArray[14].score)
    }
    
    func testTournamentUpdatesNextStageMatch() {
        let teamOne = Team(name: "Borussia")
        let teamTwo = Team(name: "Bayern")
        
        let match1 = Match(teamOne: teamOne, teamTwo: teamTwo, score: nil, state: .NotPlayed)
        
        var sut = Tournament(matchArray: [match1!, match1!, match1!, match1!, match1!, match1!, match1!, match1!])
        
        let score = Score(teamOneScore: 0, teamTwoScore: 2)
        sut?.updateMatchWithStage(1, matchInStage: 1, score: score, winningTeam: .TeamTwo)
        
        let score2 = Score(teamOneScore: 2, teamTwoScore: 0)
        sut?.updateMatchWithStage(1, matchInStage: 2, score: score2, winningTeam: .TeamOne)
        
        XCTAssertEqual(sut?.matchArray[1].teamOne, sut?.matchArray[8].teamTwo)
        
        sut?.updateMatchWithStage(2, matchInStage: 1, score: score, winningTeam: .TeamTwo)
        XCTAssertEqual(sut?.matchArray[8].teamTwo, sut?.matchArray[12].teamOne)
    }
    
    func testEmptyTournamentCreatedHasCorrectMatchCount() {
        let expectedCount = 31
        
        let sut = Tournament(firstStageMatchCount: 16)
        
        XCTAssertEqual(sut?.matchArray.count, expectedCount)
    }
    
    func testStageAndInStageIndexAreCorrect() {
        let firstExpectedPair = (1,1)
        let secondExpectedPair = (2,3)
        let thirdExpectedPair = (4,1)
        
        let sut1 = Tournament(firstStageMatchCount: 8)
        
        XCTAssertEqual(sut1?.getMatchStageAndStageIndexWithArrayIndex(0).0, firstExpectedPair.0)
        XCTAssertEqual(sut1?.getMatchStageAndStageIndexWithArrayIndex(0).1, firstExpectedPair.1)
        
        XCTAssertEqual(sut1?.getMatchStageAndStageIndexWithArrayIndex(10).0, secondExpectedPair.0)
        XCTAssertEqual(sut1?.getMatchStageAndStageIndexWithArrayIndex(10).1, secondExpectedPair.1)
        
        XCTAssertEqual(sut1?.getMatchStageAndStageIndexWithArrayIndex(14).0, thirdExpectedPair.0)
        XCTAssertEqual(sut1?.getMatchStageAndStageIndexWithArrayIndex(14).1, thirdExpectedPair.1)
        
        let sut2 = Tournament(firstStageMatchCount: 16)
        
        let fourthExpectedPair = (1,1)
        let fifthExpectedPair = (2,6)
        let sixthExpectedPair = (5,1)
        
        XCTAssertEqual(sut2?.getMatchStageAndStageIndexWithArrayIndex(0).0, fourthExpectedPair.0)
        XCTAssertEqual(sut2?.getMatchStageAndStageIndexWithArrayIndex(0).1, fourthExpectedPair.1)
        
        XCTAssertEqual(sut2?.getMatchStageAndStageIndexWithArrayIndex(21).0, fifthExpectedPair.0)
        XCTAssertEqual(sut2?.getMatchStageAndStageIndexWithArrayIndex(21).1, fifthExpectedPair.1)
        
        XCTAssertEqual(sut2?.getMatchStageAndStageIndexWithArrayIndex(30).0, sixthExpectedPair.0)
        XCTAssertEqual(sut2?.getMatchStageAndStageIndexWithArrayIndex(30).1, sixthExpectedPair.1)
    }
}
