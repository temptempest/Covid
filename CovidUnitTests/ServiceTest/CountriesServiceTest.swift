//
//  CountriesServiceTest.swift
//  CovidTests
//
//  Created by temptempest on 17.12.2022.
//

import XCTest
@testable import Covid

final class CountriesServiceTest: XCTestCase {
    private var sut: ICountriesService?
    
    override func setUp() async throws {
        try await super.setUp()
        sut = CountriesServiceMock()
    }
    
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }
    
    func test_GetCountries() async throws {
        let service = try XCTUnwrap(sut)
        service.getCountries { result in
            switch result {
            case .success(let countriesResponse):
                XCTAssertNotNil(countriesResponse)
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
        }
    }
}
