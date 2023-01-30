//
//  SearchedCountryTest.swift
//  CovidTests
//
//  Created by temptempest on 17.12.2022.
//

import XCTest
@testable import Covid

final class SearchedCountryTest: XCTestCase {
    var sut: SearchedCountry!
    override func setUp() async throws {
        try await super.setUp()
       let countries = [Country(country: "Foo", slug: "Bar", iso2: "Baz")]
        sut = SearchedCountry(isActive: true, countries: countries, index: 0)
    }
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    func test_InitSearchedCountryWithParameters_GetCountry() {
        XCTAssertNotNil(sut)
        let country = sut.country
        XCTAssertEqual(country.country, "Foo")
        XCTAssertEqual(country.slug, "Bar")
        XCTAssertEqual(country.iso2, "Baz")
    }
}
