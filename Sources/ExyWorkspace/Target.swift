/// A target in an Xcode project.
public struct Target: Hashable {
  /// The project that this target resides in.
  public var project: Project

  /// The display name of the target.
  public var name: String

  public init(project: Project, name: String) {
    self.project = project
    self.name = name
  }
}

extension Target {
  /// Information about a target.
  public struct Info: Hashable {
    /// The target that this information describes.
    public let target: Target
  }
}

