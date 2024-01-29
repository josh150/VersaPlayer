import Foundation

public struct ControlsConfig {
	public let type: ControlsType
	public let offset: CGFloat
	public let shouldAutoHide: Bool

	public init(type: ControlsType, offset: CGFloat = 0, shouldAutoHide: Bool = true) {
		self.type = type
		self.offset = offset
		self.shouldAutoHide = shouldAutoHide
	}

	public static let `default`: ControlsConfig = ControlsConfig(type: .full, offset: 8)

	public enum ControlsType {
		case minimal
		case full
	}
}
