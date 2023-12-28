//
//  UrlRouteManagerTests.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/25.
//

import XCTest
@testable import MixLedger // 导入您的应用程序模块

class UrlRouteManagerTests: XCTestCase {
    
    var sut: UrlRouteManager = UrlRouteManager()
    
    func testCreateUrlString() {
        let endpoint = UrlRouteManager.EndPoint.account
        let components = ["1", "2", "3", "4"]
        let url = UrlRouteManager.createUrlString(for: endpoint, components: components)
        
        XCTAssertEqual(url, "MixLedger://account/1/2/3/4")
    }
    
    func testCanOpen() {
        let url = URL(string: "MixLedger://account/12344")!
        XCTAssertTrue(sut.canOpen(url: url))
    }
    
    
}
