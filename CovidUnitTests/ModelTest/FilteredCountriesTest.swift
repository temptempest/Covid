//
//  FilteredCountriesTest.swift
//  CovidTests
//
//  Created by temptempest on 17.12.2022.
//

import XCTest
@testable import Covid

final class FilteredCountriesTest: XCTestCase {
    var sut: FilteredCountries!
    override func setUp() async throws {
        try await super.setUp()
        let countries = [Country(country: "Foo", slug: "Bar", iso2: "Baz")]
        sut = FilteredCountries(countries: countries, searchText: "Foo")
    }
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    func test_InitFilteredCountriesWithParameters_GetCountries() {
        XCTAssertNotNil(sut)
        let countries = sut.countries
        XCTAssertNotNil(countries)
        let country = countries[0]
        XCTAssertEqual(country.country, "Foo")
        XCTAssertEqual(country.slug, "Bar")
        XCTAssertEqual(country.iso2, "Baz")
    }
}
