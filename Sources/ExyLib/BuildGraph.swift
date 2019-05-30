/// The graph of dependencies that need to be built.
///
/// This is the output of `exy graph`.
public struct BuildGraph: Hashable {
  private var dependencies: [Scheme: [Scheme]]

  public init(_ dependencies: [Scheme: [Scheme]]) {
    self.dependencies = dependencies
  }
}

extension BuildGraph: CustomStringConvertible {
  public var description: String {
    // A YAML document that lists the dependencies
    return dependencies
      .sorted { $0.key < $1.key }
      .map { edges in
        let scheme = "\(edges.key.name):"
        let dependencies = edges.value.map { "  - \($0.name)" }
        return ([scheme] + dependencies).joined(separator: "\n")
      }
      .joined(separator: "\n")
  }
}

