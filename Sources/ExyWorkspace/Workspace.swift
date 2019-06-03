import Foundation

/// An Xcode workspace
public struct Workspace: Hashable {
  /// The file URL of the workspace.
  public var url: URL
}

extension Workspace {
  public struct Info: Hashable {
    /// The workspace that this information describes.
    public var workspace: Workspace

    /// The schemes contained directly in the workspace.
    ///
    /// - note: This does not include schemes contained in the projects in the workspace.
    public var schemes: Set<Scheme.Info>

    /// The projects in the workspace.
    public var projects: Set<Project.Info>
  }
}
