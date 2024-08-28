//
//  SwiftLogTests.swift
//  SwiftLogTests
//
//  Created by Alexandre Oliveira on 28/08/2024.
//

import XCTest
@testable import SwiftLog

class SwiftLogTests: XCTestCase {

    // MARK: - Properties
    private var sut: SwiftLog.Type!

    // MARK: - Setup and Teardown
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SwiftLog.self
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    // MARK: - Tests

    func testSaveStringSuccess() {
        // Given
        let expectation = self.expectation(description: "SwiftLog completes successfully")
        let mockString = "Test string"

        // When
        sut.saveString(mockString) { result in
            // Then
            switch result {
            case .success():
                XCTAssertTrue(true, "Expected success but got success.")
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testSaveStringFailure() {
        // Given
        let expectation = self.expectation(description: "SwiftLog fails with invalid input")
        let invalidString = "" // Invalid input for testing

        // When
        sut.saveString(invalidString) { result in
            // Then
            switch result {
            case .success():
                XCTFail("Expected failure but got success.")
            case .failure(let error):
                XCTAssertNotNil(error, "Expected an error but got nil.")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
}
