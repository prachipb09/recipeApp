//
//  FCTestCase.swift
//  Recipe App
//
//  Created by Prachi Bharadwaj on 15/10/24.
//


import XCTest

class RecipeTestCase: XCTestCase {

    @MainActor override func setUp() {
        super.setUp()
        NSTimeZone.default = TimeZone(identifier: "America/New_York")!
    }

    func GIVEN(_ given: String) {
        XCTContext.runActivity(named: "GIVEN: \(given)") { _ in }
    }

    func WHEN(_ when: String) {
        XCTContext.runActivity(named: "WHEN: \(when)") { _ in }
    }

    func THEN(_ then: String) {
        XCTContext.runActivity(named: "THEN: \(then)") { _ in }
    }
}
