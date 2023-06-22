//
//  RecipeListTests.swift
//  SpoonacularAmarisTests
//
//  Created by Juan Manuel Moreno on 21/06/23.
//

import XCTest
@testable import SpoonacularAmaris

final class TestRecipeList: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testAvailable() {
        XCTAssertTrue(APIClient.isInternetAvailable)
    }
    
    func testResponseNotNil() {
        APIClient.requestRecipeListMock( completion: { (response, error) in
            XCTAssertNotNil(response)
        })
    }

    func testDataNotNil() {
        APIClient.requestRecipeListMock( completion: { (response, error) in
            let results = response?.results
            XCTAssertNotNil(results)
        })
    }
    
    func testDataNotEmpty() {
        APIClient.requestRecipeListMock( completion: { (response, error) in
            let results = response?.results
            XCTAssertTrue(!(results!.isEmpty))
        })
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
