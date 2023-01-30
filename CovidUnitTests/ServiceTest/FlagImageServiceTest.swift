//
//  FlagImageServiceTest.swift
//  CovidTests
//
//  Created by temptempest on 17.12.2022.
//

import XCTest
@testable import Covid

final class FlagImageServiceTest: XCTestCase {
    private var sut: IFlagImageService!
    
    override func setUp() async throws {
        try await super.setUp()
        sut = FlagImageServiceMock()
    }
    
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }
    
    func test_GetSummary() async {
        sut.getFlagImageData(by: "Foo") { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
        }
    }
}
