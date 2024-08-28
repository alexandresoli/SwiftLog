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
        session = createMockSession()
        sut = createService(session: session)
    }

    override func tearDown() {
        sut = nil
        session = nil
        MockURLProtocol.mockResponse = nil
        super.tearDown()
    }

    // MARK: - Helper Methods
    private func createMockSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    private func createService(session: URLSession) -> Service {
        return Service(session: session)
    }

    private func validURL() -> URL {
        guard let url = URL(string: "https://us-central1-mobilesdklogging.cloudfunctions.net/saveString") else {
            fatalError("Valid URL could not be created.")
        }
        return url
    }

    private func createMockResponse(statusCode: Int) -> HTTPURLResponse {
        return HTTPURLResponse(url: validURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }

    // MARK: - Tests

    func testSendStringSuccess() {
        // Given
        let mockResponseData = "{\"message\":\"String stored successfully!\"}".data(using: .utf8)
        let mockURLResponse = createMockResponse(statusCode: 200)
        MockURLProtocol.mockResponse = (mockResponseData, mockURLResponse, nil)
        let expectation = expectation(description: "Service completes successfully")

        // When
        sut.sendString("Test string") { result in
            // Then
            switch result {
            case .success():
                break
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testSendStringFailsWithServerError() {
        // Given
        let mockURLResponse = createMockResponse(statusCode: 400)
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

    func testServiceFailsWithInvalidURL() {
        // Given
        let invalidURLString = "https :// invalid-url"
        sut = Service(urlString: invalidURLString, session: session)
        let expectation = expectation(description: "Service fails due to invalid URL")

        // When
        sut.sendString("Test") { result in
            // Then
            switch result {
            case .success():
                XCTFail("Expected failure due to invalid URL, but got success.")
            case .failure(let error):
                XCTAssertEqual(error as? Service.ServiceError, .invalidURL, "Expected invalidURL error but got: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
}
