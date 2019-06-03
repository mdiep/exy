import ExyLib
import ExyWorkspace
import XCTest

extension Scheme {
  private init(_ name: String) {
    self.init(name: name, url: URL(fileURLWithPath: "/\(name)"))
  }

  fileprivate static let A = Scheme("A")
  fileprivate static let B = Scheme("B")
  fileprivate static let C = Scheme("C")
  fileprivate static let D = Scheme("D")
  fileprivate static let E = Scheme("E")
}

final class BuildGraphDescriptionTests: XCTestCase {
  func test() {
    let graph = BuildGraph([
      .A: [],
      .B: [.A],
      .C: [.A, .B],
      .D: [.A],
      .E: [.A, .B, .C, .D],
    ])

    let expected = """
      A:
      B:
        - A
      C:
        - A
        - B
      D:
        - A
      E:
        - A
        - B
        - C
        - D
      """

    XCTAssertEqual(graph.description, expected)
  }
}

