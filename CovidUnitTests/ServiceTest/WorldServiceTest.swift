//
//  WorldServiceTest.swift
//  CovidTests
//
//  Created by temptempest on 17.12.2022.
//

import XCTest
@testable import Covid

final class WoldServiceTest: XCTestCase {
    private var sut: IWorldService!
    override func setUp() async throws {
        try await super.setUp()
        sut = WorldServiceMock()
    }
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }
    func test_GetWorld() async {
        sut.getWorld { result in
            switch result {
            case .success(let worldResponse):
                XCTAssertNotNil(worldResponse)
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
        }
    }
}
