//
//  StatisticViewTest.swift
//  CovidSnapshotTests
//
//  Created by temptempest on 20.12.2022.
//

import XCTest
import SnapshotTesting
@testable import Covid

final class StatisticViewTest: XCTestCase {
    var sut: StatisticView!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StatisticView()
        sut.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 80)
//        isRecording = true
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
}

// MARK: - Red StatisticView
extension StatisticViewTest {
    func test_Red_ConfigureState() {
        testMake(.red)
        assertSnapshot(matching: sut, as: .wait(for: 2, on: .image))
    }
    
    func test_Red_ConfigureState_DarkMode() {
        sut.overrideUserInterfaceStyle = .dark
        testMake(.red)
        assertSnapshot(matching: sut, as: .wait(for: 2, on: .image))
    }
    
    func test_Red_LoadingState() {
        sut.setNeedsDisplay()
        showSkeleton(.red)
        assertSnapshot(matching: sut, as: .image)
        sut.hideSkeleton()
    }
    
    func test_Red_LoadingState_DarkMode() {
        sut.overrideUserInterfaceStyle = .dark
        sut.setNeedsDisplay()
        showSkeleton(.red)
        assertSnapshot(matching: sut, as: .image)
        sut.hideSkeleton()
    }
}

// MARK: - Green StatisticView
extension StatisticViewTest {
    func test_Green_ConfigureState() {
        testMake(.green)
        assertSnapshot(matching: sut, as: .wait(for: 2, on: .image))
    }
    
    func test_Green_ConfigureState_DarkMode() {
        sut.overrideUserInterfaceStyle = .dark
        testMake(.green)
        assertSnapshot(matching: sut, as: .wait(for: 2, on: .image))
    }
    
    func test_Green_LoadingState() {
        sut.setNeedsDisplay()
        showSkeleton(.green)
        assertSnapshot(matching: sut, as: .image)
        sut.hideSkeleton()
    }
    
    func test_Green_LoadingState_DarkMode() {
        sut.overrideUserInterfaceStyle = .dark
        sut.setNeedsDisplay()
        showSkeleton(.green)
        assertSnapshot(matching: sut, as: .image)
        sut.hideSkeleton()
    }
}

// MARK: - Blue StatisticView
extension StatisticViewTest {
    func test_Blue_ConfigureState() {
        testMake(.blue)
        assertSnapshot(matching: sut, as: .wait(for: 2, on: .image))
    }
    
    func test_Blue_ConfigureState_DarkMode() {
        sut.overrideUserInterfaceStyle = .dark
        testMake(.blue)
        assertSnapshot(matching: sut, as: .wait(for: 2, on: .image))
    }
    
    func test_Blue_LoadingState() {
        sut.setNeedsDisplay()
        showSkeleton(.blue)
        assertSnapshot(matching: sut, as: .image)
        sut.hideSkeleton()
    }
    
    func test_Blue_LoadingState_DarkMode() {
        sut.overrideUserInterfaceStyle = .dark
        sut.setNeedsDisplay()
        showSkeleton(.blue)
        assertSnapshot(matching: sut, as: .image)
        sut.hideSkeleton()
    }
}

// MARK: - Helper
extension StatisticViewTest {
    private enum StatisticViewColor: CaseIterable {
        case red
        case green
        case blue
    }
    
    private func showSkeleton(_ color: StatisticViewColor) {
        sut.backgroundColor = UIColor.theme.blue
        sut.showSkeleton(backgroundColor: getColor(color),
                          highlightColor: getLighterColor(color))
    }
    
    private func testMake(_ color: StatisticViewColor) {
        let total = 100
        let new = 50
        sut.configure(
            top: .init(string: Constants.totalConfirmed, value: total, color: UIColor.theme.background),
            bottom: .init(string: Constants.newConfirmed, value: new,
                          color: UIColor.theme.background), backgroundColor: getColor(color))
    }
    
    private func getColor(_ color: StatisticViewColor) -> UIColor {
        let currentColor: UIColor
        switch color {
        case .red:
            currentColor = UIColor.theme.red
        case .green:
            currentColor = UIColor.theme.green
        case .blue:
            currentColor = UIColor.theme.blue
        }
        return currentColor
    }
    
    private func getLighterColor(_ color: StatisticViewColor) -> UIColor {
        let currentColor: UIColor
        switch color {
        case .red:
            currentColor = UIColor.theme.redLighter
        case .green:
            currentColor = UIColor.theme.greenLighter
        case .blue:
            currentColor = UIColor.theme.blueLighter
        }
        return currentColor
    }
}
