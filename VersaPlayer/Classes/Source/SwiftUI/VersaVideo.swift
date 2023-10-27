import Foundation

public struct VersaVideo {
	public var url: URL
	public var autoPlay: Bool
	public var isMuted: Bool

	public init(url: URL, autoPlay: Bool = true, isMuted: Bool = false) {
		self.url = url
		self.autoPlay = autoPlay
		self.isMuted = isMuted
	}
}
