//
//  SEDetailTests.swift
//  SeriesTests
//
//  Created by Jesus Cueto on 1/14/22.
//

import XCTest
@testable import Series

class SEDetailTests: XCTestCase {
    
    var request: NetworkManager?
    var id: String?
    var repository: SEShowDetailRepository?
    var posterRepository: SEPosterRepository?
    var interactor: SEShowDetailInteractor?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        request = NetworkManager()
        repository = SEShowDetailRepository(from: request!)
        posterRepository = SEPosterRepository(from: request!)
        interactor = SEShowDetailInteractor(from: repository!, posterRepository: posterRepository!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.request = nil
        self.id = nil
        self.repository = nil
        self.posterRepository = nil
        self.interactor = nil
    }

    func testGetDetailInfo() throws {
        let expectation = XCTestExpectation(description: "Test show's Detail info")
        var expectedResult: SEShowDetailModel?
        self.repository?.getShowDetail(fromId: "2", success: { detail in
            expectedResult = detail
            expectation.fulfill()
        }, failure: { _ in
            XCTFail("Should not recieved an error")
        })
        wait(for: [expectation], timeout: 2)
        XCTAssertNotNil(expectedResult)
        XCTAssert(("\(expectedResult?.id ?? 0)") == "2")
    }
    
    func testEpisodeData() throws {
        let expectation = XCTestExpectation(description: "Test Episode's Detail info")
        var expectedResult: [SEShowEpisodeCellData]?
        self.interactor?.getEpisodesBySeason(id: "5", success: { episodes, episodesData in
            expectedResult = episodesData
            expectation.fulfill()
        }, failure: { _ in
            XCTFail("Should not recieved an error")
        })
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(expectedResult)
    }
    
    func testSeasonsData() throws {
        let expectation = XCTestExpectation(description: "Test Season's Detail info")
        var expectedResult: [SEShowSeasonModel]?
        self.interactor?.getShowSeasons(id: "2", success: { seasons in
            expectedResult = seasons
            expectation.fulfill()
        }, failure: { error in
            XCTFail("Should not recieved an error")
        })
        wait(for: [expectation], timeout: 2)
        XCTAssertNotNil(expectedResult)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
