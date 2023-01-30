//
//  DetailCountryTest.swift
//  CovidTests
//
//  Created by temptempest on 17.12.2022.
//

import XCTest
@testable import Covid

final class DetailCountryTest: XCTestCase {
    var sut: DetailCountry!
    
    override func setUp() async throws {
        try await super.setUp()
        sut = DetailCountry(id: "Foo", country: "Bar", countryCode: "Baz", lat: "10.0",
                            lon: "20.0", date: "BB", confirmed: 1, deaths: 1, recovered: 1, active: 1)
    }
    
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }
    
    func test_InitDetailCountryWithParameters() {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.id, "Foo")
        XCTAssertEqual(sut.country, "Bar")
        XCTAssertEqual(sut.countryCode, "Baz")
        XCTAssertEqual(sut.lat, "10.0")
        XCTAssertEqual(sut.lon, "20.0")
        XCTAssertEqual(sut.date, "BB")
        XCTAssertEqual(sut.confirmed, 1)
        XCTAssertEqual(sut.deaths, 1)
        XCTAssertEqual(sut.recovered, 1)
        XCTAssertEqual(sut.active, 1)
    }
}
