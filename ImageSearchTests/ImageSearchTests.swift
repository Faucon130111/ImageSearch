//
//  ImageSearchTests.swift
//  ImageSearchTests
//
//  Created by 박본혁 on 2020/12/08.
//

import XCTest
@testable import ImageSearch

class ImageSearchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetworkService_fetchImages() {
        // given
        let session = SessionStub()
        let networkService = NetworkService(session: session)
        
        // when
        let _ = networkService.fetchImages(
            query: "brandi",
            page: 1
        )
        
        // then
        let params = session.requestParameters
        let dictionary: [String: Any]? = params?.parameters
        
        XCTAssertEqual(
            params?.method,
            .get
        )
        XCTAssertEqual(
            try params?.url.asURL().absoluteString,
            "https://dapi.kakao.com/v2/search/image"
        )
        XCTAssertEqual(
            dictionary?["query"] as? String,
            "brandi"
        )
    }

}
