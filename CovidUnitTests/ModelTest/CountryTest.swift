//
//  CountryTest.swift
//  CovidTests
//
//  Created by temptempest on 17.12.2022.
//

import XCTest
@testable import Covid

final class CountryTest: XCTestCase {
    var sut: Country!
    
    override func setUp() async throws {
        try await super.setUp()
        sut = Country(country: "Foo", slug: "Bar", iso2: "Baz")
    }
    
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }
    
    func test_InitCountryWithParameters() {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.country, "Foo")
        XCTAssertEqual(sut.slug, "Bar")
        XCTAssertEqual(sut.iso2, "Baz")
    }
    
    func test_InitTaskWithFlag() {
        sut.flag = Data()
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.country, "Foo")
        XCTAssertEqual(sut.slug, "Bar")
        XCTAssertEqual(sut.iso2, "Baz")
        XCTAssertNotNil(sut.flag)
    }
}
