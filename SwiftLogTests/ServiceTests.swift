//
//  ServiceTests.swift
//  SwiftLogTests
//
//  Created by Alexandre Oliveira on 28/08/2024.
//

import XCTest
@testable import SwiftLog

class ServiceTests: XCTestCase {

    // MARK: - Properties
    var sut: Service!
    var session: URLSession!

    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()
        session = makeMockSession()
        sut = makeSUT(session: session)
    }

    override func tearDown() {
        sut = nil
        session = nil
        MockURLProtocol.mockResponse = nil
        super.tearDown()
    }

    // MARK: - Helper Methods
    private func makeMockSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    private func makeSUT(session: URLSession) -> Service {
        return Service(session: session)
    }

    // MARK: - Tests

    func testSendStringSuccess() {
        // Given
        let mockResponseData = "{\"message\":\"String stored successfully!\"}".data(using: .utf8)
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://us-central1-mobilesdklogging.cloudfunctions.net/saveString")!,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        
        MockURLProtocol.mockResponse = (mockResponseData, mockURLResponse, nil)
        let expectation = expectation(description: "Service completes successfully")

        // When
        sut.sendString("Test string") { result in
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

    func testSendStringFailure() {
        // Given
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://us-central1-mobilesdklogging.cloudfunctions.net/saveString")!,
                                              statusCode: 400,
                                              httpVersion: nil,
                                              headerFields: nil)
        
        MockURLProtocol.mockResponse = (nil, mockURLResponse, nil)
        let expectation = expectation(description: "Service fails with server error")

        // When
        sut.sendString("Test string") { result in
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

    func testInvalidURL() {
        // Given
        let malformedURLString = "https :// invalid-url" // Intentionally invalid URL
        sut = Service(urlString: malformedURLString, session: session)
        let expectation = expectation(description: "Service fails due to invalid URL")

        // When
        sut.sendString("Test") { result in
            // Then
            switch result {
            case .success():
                XCTFail("Expected failure but got success.")
            case .failure(let error):
                if case Service.ServiceError.invalidURL = error {
                    XCTAssertTrue(true, "Received expected invalidURL error.")
                } else {
                    XCTFail("Expected invalidURL error but got: \(error)")
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
}
