//
//  CovidEndpointTest.swift
//  CovidTests
//
//  Created by temptempest on 17.12.2022.
//

import XCTest
@testable import Covid

final class CovidEndpointTest: XCTestCase {
    private var sut1: CovidEndpoint?
    private var sut2: CovidEndpoint?
    private var sut3: CovidEndpoint?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut1 = .countries
        sut2 = .countryDailyInfo(countrySlug: "Foo", day: "Bar", dayBefore: "Baz")
        sut3 = .summary
    }
    
    override func tearDownWithError() throws {
        sut1 = nil
        sut2 = nil
        sut3 = nil
        try super.tearDownWithError()
    }
    
    func test_ValidBaseURL() {
        let urlItems = "https://api.covid19api.com/"
        XCTAssertEqual(sut1?.baseURL.absoluteString, urlItems)
        XCTAssertEqual(sut2?.baseURL.absoluteString, urlItems)
        XCTAssertEqual(sut3?.baseURL.absoluteString, urlItems)
    }
    
    func test_ValidPath() {
        let path1 = "countries"
        let path2 = "country/Foo"
        let path3 = "summary"
        XCTAssertEqual(sut1?.path, path1)
        XCTAssertEqual(sut2?.path, path2)
        XCTAssertEqual(sut3?.path, path3)
    }
    
    func test_ValidMethod() {
        let method = "GET"
        XCTAssertEqual(sut1?.method.rawValue, method)
        XCTAssertEqual(sut2?.method.rawValue, method)
        XCTAssertEqual(sut3?.method.rawValue, method)
    }
}
