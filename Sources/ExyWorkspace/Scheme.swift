import Foundation

/// An Xcode scheme.
public struct Scheme: Hashable {
  /// The display name of the scheme.
  public var name: String

  /// The location of the scheme on disk.
  public var url: URL

  public init(name: String, url: URL) {
    self.name = name
    self.url = url
  }
}

extension Scheme: Comparable {
  public static func < (lhs: Scheme, rhs: Scheme) -> Bool {
    return lhs.name < rhs.name
  }
}

