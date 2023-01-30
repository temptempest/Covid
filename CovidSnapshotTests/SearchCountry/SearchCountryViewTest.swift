//
//  SearchCountryViewTest.swift
//  CovidSnapshotTests
//
//  Created by temptempest on 20.12.2022.
//

import XCTest
import SnapshotTesting
@testable import Covid

final class SearchCountryViewTest: XCTestCase {
    var sut: UIViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let container = DependenciesMock().moduleContainer
        sut = container.getSearchCountryView()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_DefaultState() {
        assertSnapshot(matching: self.sut, as: .image)
    }
    
    func test_LoadedState() {
        sut.view.setNeedsDisplay()
        assertSnapshot(matching: sut.view, as: .wait(for: 4, on: .image))
    }
    
    func test_DarkMode() {
        sut.overrideUserInterfaceStyle = .dark
        assertSnapshot(matching: sut.view, as: .image)
    }
}
