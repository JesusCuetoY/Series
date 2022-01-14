//
//  SeriesTests.swift
//  SeriesTests
//
//  Created by Jesus Cueto on 1/11/22.
//

import XCTest
@testable import Series

// MARK: - ShowListTest cases
class SeriesTests: XCTestCase {
    
    private var repostory: SEShowRepositoryProtocol?
    private var network: NetworkManager?
    private var interactor: SEShowUseCase?
    private var presenter: SEShowCellPresenterInput?

    // MARK: - Setup
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.network = NetworkManager()
        self.repostory = SEShowRepository(from: network!)
        self.interactor = SEShowInteractor(from: repostory!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.network = nil
        self.repostory = nil
        self.interactor = nil
    }
    
    // MARK: - Tests
    func testShowPageRequest() throws {
        let expectation = XCTestExpectation(description: "Test show's pagination")
        var expectedResult: [SEShowDetailModel] = []
        self.repostory?.getShowList(byPage: "200", success: { showList in
            expectedResult = showList
            expectation.fulfill()
        }, failure: { error in
            XCTFail("Should not recieved an error")
        })
        wait(for: [expectation], timeout: 2)
        XCTAssert(!expectedResult.isEmpty)
    }
    
    func testShowSearchRequest() throws {
        let expectation = XCTestExpectation(description: "Test show's pagination")
        var expectedResult: [SEShowSearchDetailModel] = []
        self.repostory?.getFilteredShows(from: "girl", success: { showList in
            expectedResult = showList
            expectation.fulfill()
        }, failure: { error in
            XCTFail("Should not recieved an error")
        })
        wait(for: [expectation], timeout: 2)
        XCTAssert(!expectedResult.isEmpty)
    }

    func testShowPageError() throws {
        let expectation = XCTestExpectation(description: "Test failure output")
        var expectedMessage = SEKeys.MessageKeys.emptyText
        self.repostory?.getShowList(byPage: "-1", success: { _ in
            XCTFail("Should receive an error")
        }, failure: { error in
            expectedMessage = error.message ?? SEKeys.MessageKeys.emptyText
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual("Invalid value for page", expectedMessage)
    }
    
    func testEmptySearchError() throws {
        let expectation = XCTestExpectation(description: "Test failure empty search result")
        let id = "-1"
        var expectedMessage = SEKeys.MessageKeys.emptyText
        self.interactor?.getFilteredShows(from: id, success: { _ in
            XCTFail("Should receive an error")
        }, failure: { error in
            expectedMessage = error.message ?? SEKeys.MessageKeys.emptyText
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(NSLocalizedString(SEKeys.MessageKeys.listSearchEmptyErrorMessage, comment: SEKeys.MessageKeys.emptyText).replacingOccurrences(of: "%@", with: id), expectedMessage)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
