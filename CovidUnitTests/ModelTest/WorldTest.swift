//
//  WorldTest.swift
//  CovidTests
//
//  Created by temptempest on 17.12.2022.
//

import XCTest
@testable import Covid

final class WorldTest: XCTestCase {
    var sut: World!
    override func setUp() async throws {
        try await super.setUp()
        let world = World(newConfirmed: 1, totalConfirmed: 1, newDeaths: 1, totalDeaths: 1, newRecovered: 1, totalRecovered: 1, date: "Foo")
        sut = world
    }
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    func test_InitDetailCountryWithParameters() {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.newConfirmed, 1)
        XCTAssertEqual(sut.totalConfirmed, 1)
        XCTAssertEqual(sut.newDeaths, 1)
        XCTAssertEqual(sut.date, "Foo")
    }
}
