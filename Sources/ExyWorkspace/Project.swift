import Foundation

/// An Xcode project.
public struct Project: Hashable {
  /// The file URL of the project.
  public var url: URL
}

extension Project {
  /// Information from an Xcode project
  public struct Info: Hashable {
    /// The project that this information describes.
    public var project: Project

    /// The schemes that are contained in the project.
    public var schemes: Set<Scheme.Info>

    /// The targets in the project.
    public var targets: Set<Target.Info>
  }
}
