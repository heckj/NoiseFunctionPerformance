import XCTest
@testable import NoiseFunctionPerformance
import MurmurHash_Swift

final class NoiseFunctionPerformanceTests: XCTestCase {
    let iterationCount = 10000
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let a1: UInt32 = MurmurPRNG_x86_32(seed: 123456678).lookup()
        XCTAssertNotNil(a1)
        let a2: [UInt32] = MurmurPRNG_x86_128(seed: 123456678).lookup()
        XCTAssertNotNil(a2)
        XCTAssertEqual(a2.count, 4)
        let a3: [UInt64] = MurmurPRNG_x64_128(seed: 123456678).lookup()
        XCTAssertNotNil(a3)
        XCTAssertEqual(a3.count, 2)
        print(UInt32.bitWidth) //32
        print(UInt64.bitWidth) //64
        //print(Double.) // UInt64 -> Double
    }
    
    func testConsistency_MurmurPRNG_x86_32() throws {
        let seed: UInt32 = 235474323
        var firstResults: [UInt32] = []
        let subject1 = MurmurPRNG_x86_32(seed: seed)
        for _ in 0...10 {
            firstResults.append(subject1.lookup())
        }
        
        var secondResults: [UInt32] = []
        let subject2 = MurmurPRNG_x86_32(seed: seed)
        for _ in 0...10 {
            secondResults.append(subject2.lookup())
        }
        XCTAssertEqual(firstResults, secondResults)
    }

    func testConsistency_HasherPRNG() throws {
        let seed: UInt32 = 235474323
        var firstResults: [Int] = []
        let subject1 = HasherPRNG(seed: seed)
        for _ in 0...10 {
            firstResults.append(subject1.lookup())
        }
        
        var secondResults: [Int] = []
        let subject2 = HasherPRNG(seed: seed)
        for _ in 0...10 {
            secondResults.append(subject2.lookup())
        }
        XCTAssertEqual(firstResults, secondResults)
    }

    func testPerf1() throws {
        let q = MurmurPRNG_x86_32(seed: 123456678)
        measure {
            for _ in 0...iterationCount {
                _ = q.lookup()
            }
        }
    }

    func testPerf2() throws {
        let q = MurmurPRNG_x86_128(seed: 123456678)
        measure {
            for _ in 0...iterationCount {
                _ = q.lookup()
            }
        }
    }

    func testPerf3() throws {
        let q = MurmurPRNG_x64_128(seed: 123456678)
        measure {
            for _ in 0...iterationCount {
                _ = q.lookup()
            }
        }
    }

    func testPerf4() throws {
        let q = HasherPRNG(seed: 123456678)
        measure {
            for _ in 0...iterationCount {
                _ = q.lookup()
            }
        }
    }

}
