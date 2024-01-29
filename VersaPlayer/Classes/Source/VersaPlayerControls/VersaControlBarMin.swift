import Foundation
import UIKit

class VersaControlBarMin: UIView {
	private let height: CGFloat = 32
	private let buttonWidth: CGFloat = 32
	private let controlSpacing: CGFloat = 24

	let playPauseButton = VersaStatefulButton()
	let backButton = VersaStatefulButton()
	let nextButton = VersaStatefulButton()
	let bufferingView = UIActivityIndicatorView(style: .medium)

	let onSkip: (Int) -> Void

	init(onSkip: @escaping (Int) -> Void) {
		self.onSkip = onSkip
		super.init(frame: .zero)
		sharedInit()
	}
	
	required init?(coder: NSCoder) {
		self.onSkip = { _ in }
		super.init(coder: coder)
		sharedInit()
	}

	private func sharedInit() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .clear

		buildBackButton()
		buildPlayButton()
		buildNextButton()
		buildBufferingView()

	}

	private func buildBackButton() {
		backButton.translatesAutoresizingMaskIntoConstraints = false
		backButton.activeImage = UIImage(systemName: "backward.end")
		backButton.inactiveImage = UIImage(systemName: "backward.end")
		backButton.tintColor = .white
		backButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
		backButton.layer.cornerRadius = buttonWidth / 2
		backButton.addTarget(self, action: #selector(skipBack), for: .touchUpInside)
		addSubview(backButton)

		NSLayoutConstraint.activate([
			backButton.leadingAnchor.constraint(equalTo: leadingAnchor),
			backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			backButton.widthAnchor.constraint(equalToConstant: buttonWidth),
			backButton.heightAnchor.constraint(equalToConstant: height)
		])
	}

	private func buildPlayButton() {
		playPauseButton.translatesAutoresizingMaskIntoConstraints = false
		playPauseButton.activeImage = UIImage(systemName: "pause")
		playPauseButton.inactiveImage = UIImage(systemName: "play")
		playPauseButton.tintColor = .white
		playPauseButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
		playPauseButton.layer.cornerRadius = buttonWidth / 2
		addSubview(playPauseButton)

		NSLayoutConstraint.activate([
			playPauseButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: controlSpacing),
			playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			playPauseButton.widthAnchor.constraint(equalToConstant: buttonWidth),
			playPauseButton.heightAnchor.constraint(equalToConstant: height)
		])
	}

	private func buildNextButton() {
		nextButton.translatesAutoresizingMaskIntoConstraints = false
		nextButton.activeImage = UIImage(systemName: "forward.end")
		nextButton.inactiveImage = UIImage(systemName: "forward.end")
		nextButton.tintColor = .white
		nextButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
		nextButton.layer.cornerRadius = buttonWidth / 2
		nextButton.addTarget(self, action: #selector(skipNext), for: .touchUpInside)
		addSubview(nextButton)

		NSLayoutConstraint.activate([
			nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: controlSpacing),
			nextButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			nextButton.widthAnchor.constraint(equalToConstant: buttonWidth),
			nextButton.heightAnchor.constraint(equalToConstant: height)
		])
	}

	private func buildBufferingView() {
		bufferingView.translatesAutoresizingMaskIntoConstraints = false
		bufferingView.color = .white
		addSubview(bufferingView)
		bufferingView.startAnimating()

		NSLayoutConstraint.activate([
			bufferingView.centerXAnchor.constraint(equalTo: centerXAnchor),
			bufferingView.centerYAnchor.constraint(equalTo: centerYAnchor),
			bufferingView.widthAnchor.constraint(equalToConstant: height),
			bufferingView.heightAnchor.constraint(equalToConstant: height)
		])
	}

	func wrappedWithPlayerControls(offset: CGFloat) -> VersaPlayerControls {
		let controls = VersaPlayerControls()
		controls.addSubview(self)

		NSLayoutConstraint.activate([
			centerXAnchor.constraint(equalTo: controls.centerXAnchor),
			centerYAnchor.constraint(equalTo: controls.centerYAnchor, constant: -offset),
			widthAnchor.constraint(equalToConstant: 144),
			heightAnchor.constraint(equalToConstant: height)
		])

		controls.playPauseButton = playPauseButton
		controls.bufferingView = bufferingView

		return controls
	}

	@objc private func skipBack() {
		onSkip(-1)
	}

	@objc private func skipNext() {
		onSkip(1)
	}
}
