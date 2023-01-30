//
//  UserDefaultsRepositoryTest.swift
//  CovidTests
//
//  Created by temptempest on 17.12.2022.
//

import XCTest
@testable import Covid

final class UserDefaultsRepositoryTest: XCTestCase {
    private var sut: IUserDefaultsRepository?
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = UserDefaultsRepository(container: UserDefaults.standard)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_InitUserDefaultsManager() {
        XCTAssertNotNil(sut)
    }
    
    func test_UserDefaultsRepositoryTest_GetIsOnboardingCompleteBefore() {
        let result = sut?.isOnboardingCompleteBefore
        XCTAssertNotNil(result)
    }
}
