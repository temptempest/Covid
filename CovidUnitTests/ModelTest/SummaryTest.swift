//
//  SummaryTest.swift
//  CovidTests
//
//  Created by temptempest on 17.12.2022.
//

import XCTest
@testable import Covid

final class SummaryTest: XCTestCase {
    var sut: Summary!
    override func setUp() async throws {
        try await super.setUp()
        let global: Global = .init(newConfirmed: 1, totalConfirmed: 1, newDeaths: 1, totalDeaths: 1, newRecovered: 1, totalRecovered: 1, date: "Baz")
        sut = Summary(message: "Foo", global: global, countries: [], date: "Bar")
    }
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    func test_InitDetailCountryWithParameters() {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.message, "Foo")
        XCTAssertEqual(sut.date, "Bar")
        XCTAssertEqual(sut.global.date, "Baz")
    }
}
