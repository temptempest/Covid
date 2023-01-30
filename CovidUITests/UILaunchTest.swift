//
//  UILaunchTest.swift
//  CovidUITests
//
//  Created by temptempest on 18.12.2022.
//

import XCTest

class UILaunchTests: XCTestCase {
    func test_LaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
