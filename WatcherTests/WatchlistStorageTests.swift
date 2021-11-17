//
//  WatchlistStorageTests2.swift
//  WatcherTests
//
//  Created by Евгений Березенцев on 15.11.2021.
//

import XCTest
@testable import Watcher

class WatchlistStorageTests: XCTestCase {

    var sut: WatchlistStorage!
    var testMovie: Movie!

    override func setUp() {
        super.setUp()
        sut = WatchlistStorage()
        testMovie = Movie(id: 909, title: "TestMovie", year: "2021", rate: 9.0, posterImage: "", overview: "", popularity: 400)
    }

    override func tearDown() {
        sut = nil
        testMovie = nil
        super.tearDown()
    }

    func testExample() {
        sut.append(testMovie)
        
        let watchlist = sut.watchList
        
        XCTAssert(watchlist.contains(testMovie), "Not contains testMovie")
    }

    func testPerformanceExample() {
        
        measure {
            
        }
    }

}
