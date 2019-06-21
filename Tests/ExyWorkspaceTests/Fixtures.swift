import Foundation

enum Fixtures {
	private static func url(_ fixture: String) -> URL {
		return URL(fileURLWithPath: #file)
			.deletingLastPathComponent()
			.appendingPathComponent("Fixtures", isDirectory: true)
			.appendingPathComponent(fixture, isDirectory: true)
	}

	static let reactiveCocoa = ReactiveCocoa(url("ReactiveCocoa"))
}

extension Fixtures {
	struct ReactiveCocoa {
		let url: URL

		init(_ url: URL) {
			self.url = url
		}
	}
}
