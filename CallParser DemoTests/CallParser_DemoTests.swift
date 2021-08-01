//
//  CallParser_DemoTests.swift
//  CallParser DemoTests
//
//  Created by Peter Bourget on 7/29/21.
//  Copyright © 2021 Peter Bourget. All rights reserved.
//

import XCTest
import CallParser

class CallParser_DemoTests: XCTestCase {

  let callParser: PrefixFileParser = PrefixFileParser()
  lazy var callLookup: CallLookup = {
    return CallLookup(prefixFileParser: callParser)
  }()

//  override init() {
//    //callParser = PrefixFileParser()
//    //callLookup = CallLookup(prefixFileParser: callParser)
//    super.init()
//  }
//
//  override init(selector: Selector) {
//      //callParser = PrefixFileParser()
//      //callLookup = CallLookup(prefixFileParser: callParser)
//      super.init(selector: selector)
//  }
//
//  override init(invocation: NSInvocation?) {
//
//      super.init(invocation: invocation)
//  }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCallLookup() throws {
        // Use XCTAssert and related functions to verify your tests produce the correct results.

      var result = [Hit]()
      var expected: Int

      // Add calls where mask ends with '.' ie: KG4AA and as compare KG4AAA
       let testCallSigns = ["TX9", "TX4YKP/R", "/KH0PR", "W6OP/4", "OEM3SGU/3", "AM70URE/8", "5N31/OK3CLA", "BV100", "BY1PK/VE6LB", "VE6LB/BY1PK", "DC3RJ/P/W3", "RAEM", "AJ3M/BY1RX", "4D71/N0NM"]

      let testResult = [0,7,1,1,0,1,1,0,0,1,1,0,1,1]

      for (index, callSign) in testCallSigns.enumerated() {
        result = callLookup.lookupCall(call: callSign)
        expected = testResult[index]
        XCTAssert(expected == result.count, "Expected: \(expected) :: Result: \(result.count)")
      }

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
