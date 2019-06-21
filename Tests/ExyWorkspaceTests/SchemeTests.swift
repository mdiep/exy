import ExyWorkspace
import XCTest

final class SchemeLessThanTests: XCTestCase {
  func test() {
    let a = Scheme(name: "A", url: URL(fileURLWithPath: "/B"))
    let b = Scheme(name: "B", url: URL(fileURLWithPath: "/A"))

	print("\(Fixtures.reactiveCocoa.url)")

    XCTAssertLessThan(a, b)
    XCTAssertGreaterThan(b, a)
  }
}

