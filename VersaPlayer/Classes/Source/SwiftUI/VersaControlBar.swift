import Foundation
import UIKit

class VersaControlBar: UIView {
	private let height: CGFloat = 32
	private let buttonWidth: CGFloat = 32
	private let controlSpacing: CGFloat = 8

	let playPauseButton = VersaStatefulButton()
	let currentTimeLabel = VersaTimeLabel()
	let seekbarSlider = VersaSeekbarSlider()
	let totalTimeLabel = VersaTimeLabel()
	let fullscreenButton = VersaStatefulButton()
	let bufferingView = UIActivityIndicatorView(style: .medium)
	let muteButton = VersaStatefulButton()

	init() {
		super.init(frame: .zero)
		sharedInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		sharedInit()
	}

	private func sharedInit() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .black.withAlphaComponent(0.8)
		layer.cornerRadius = height / 2

		buildPlayButton()
		buildCurrentTimeLabel()
		buildFullscreenButton()
		buildMuteButton()
		buildTotalTimeLabel()
		buildSeekbarSlider()
		buildBufferingView()

	}

	private func buildPlayButton() {
		playPauseButton.translatesAutoresizingMaskIntoConstraints = false
		playPauseButton.activeImage = UIImage(systemName: "pause")
		playPauseButton.inactiveImage = UIImage(systemName: "play")
		playPauseButton.tintColor = .white
		addSubview(playPauseButton)

		NSLayoutConstraint.activate([
			playPauseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: controlSpacing),
			playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			playPauseButton.widthAnchor.constraint(equalToConstant: buttonWidth),
			playPauseButton.heightAnchor.constraint(equalToConstant: height)
		])
	}

	private func buildCurrentTimeLabel() {
		currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
		currentTimeLabel.textColor = .white
		currentTimeLabel.font = .systemFont(ofSize: 12)
		addSubview(currentTimeLabel)

		NSLayoutConstraint.activate([
			currentTimeLabel.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor),
			currentTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}

	private func buildSeekbarSlider() {
		seekbarSlider.translatesAutoresizingMaskIntoConstraints = false
		seekbarSlider.tintColor = .white
		seekbarSlider.thumbTintColor = .white

		let img = rectangleImage()

		for state: UIControl.State in [.normal, .selected, .disabled, .focused, .highlighted, .application, .reserved] {
			seekbarSlider.setThumbImage(img, for: state)
		}

		addSubview(seekbarSlider)

		NSLayoutConstraint.activate([
			seekbarSlider.leadingAnchor.constraint(equalTo: currentTimeLabel.trailingAnchor, constant: controlSpacing),
			seekbarSlider.trailingAnchor.constraint(equalTo: totalTimeLabel.leadingAnchor, constant: -controlSpacing),
			seekbarSlider.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}

	private func rectangleImage() -> UIImage {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 4, height: 16))
		let rectangle = CGRect(x: 0, y: 0, width: 4, height: 16)

		let img = renderer.image { ctx in
			ctx.cgContext.setFillColor(UIColor.white.cgColor)
			ctx.cgContext.addRect(rectangle)
			ctx.cgContext.drawPath(using: .fill)
		}

		return img
	}

	private func buildTotalTimeLabel() {
		totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
		totalTimeLabel.textColor = .white
		totalTimeLabel.font = .systemFont(ofSize: 12)
		addSubview(totalTimeLabel)

		NSLayoutConstraint.activate([
			totalTimeLabel.trailingAnchor.constraint(equalTo: muteButton.leadingAnchor),
			totalTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}

	private func buildFullscreenButton() {
		fullscreenButton.translatesAutoresizingMaskIntoConstraints = false
		fullscreenButton.activeImage = UIImage(systemName: "xmark")
		fullscreenButton.inactiveImage = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
		fullscreenButton.tintColor = .white
		addSubview(fullscreenButton)

		NSLayoutConstraint.activate([
			fullscreenButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -controlSpacing),
			fullscreenButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			fullscreenButton.widthAnchor.constraint(equalToConstant: buttonWidth),
			fullscreenButton.heightAnchor.constraint(equalToConstant: height)
		])
	}

	private func buildMuteButton() {
		muteButton.translatesAutoresizingMaskIntoConstraints = false
		muteButton.activeImage = UIImage(systemName: "speaker.slash.fill")
		muteButton.inactiveImage = UIImage(systemName: "speaker.fill")
		muteButton.tintColor = .white
		addSubview(muteButton)

		NSLayoutConstraint.activate([
			muteButton.trailingAnchor.constraint(equalTo: fullscreenButton.leadingAnchor),
			muteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			muteButton.widthAnchor.constraint(equalToConstant: buttonWidth),
			muteButton.heightAnchor.constraint(equalToConstant: height)
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
			leadingAnchor.constraint(equalTo: controls.leadingAnchor, constant: 16),
			trailingAnchor.constraint(equalTo: controls.trailingAnchor, constant: -16),
			bottomAnchor.constraint(equalTo: controls.bottomAnchor, constant: -offset),
			heightAnchor.constraint(equalToConstant: height)
		])

		controls.playPauseButton = playPauseButton
		controls.currentTimeLabel = currentTimeLabel
		controls.seekbarSlider = seekbarSlider
		controls.totalTimeLabel = totalTimeLabel
		controls.fullscreenButton = fullscreenButton
		controls.bufferingView = bufferingView
		controls.muteButton = muteButton

		return controls
	}
}
