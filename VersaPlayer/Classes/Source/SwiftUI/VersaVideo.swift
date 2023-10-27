import Foundation

public struct VersaVideo {
	public var url: URL
	public var autoPlay: Bool
	public var isMuted: Bool
	public let remote: VersaVideoRemote

	public init(url: URL, autoPlay: Bool = true, isMuted: Bool = false) {
		self.url = url
		self.autoPlay = autoPlay
		self.isMuted = isMuted
		self.remote = VersaVideoRemote()
	}
}

public class VersaVideoRemote {
	internal var playAction: (() -> Void)?
	internal var pauseAction: (() -> Void)?

	internal init() {}

	public func play() {
		playAction?()
	}

	public func pause() {
		pauseAction?()
	}
}
