//
//  HTTPClientTest.swift
//  CovidTests
//
//  Created by temptempest on 17.12.2022.
//

import XCTest
@testable import Covid

final class HTTPClientTest: XCTestCase {
    private var sut: IHTTPClient?
   
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = HTTPClient()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_InitNetworkBaseServiceWithZeroTasks() {
        XCTAssertNotNil(sut)
    }
    
    func test_NetworkBaseServiceRequest_GetResponse() {
        let dataExpectation = expectation(description: "Data expectation")
        var outputData: Data?
        sut?.request(target: .countries, completion: { result in
            switch result {
            case .success(let data):
                outputData = data
                dataExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(outputData)
        }
    }
}
