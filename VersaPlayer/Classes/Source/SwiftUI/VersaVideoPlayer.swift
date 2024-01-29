import AVKit
import SwiftUI

public struct VersaVideoPlayer: UIViewRepresentable {
	@Binding private var video: VersaVideo
	private let controlsConfig: ControlsConfig
	private let onSkip: (Int) -> Void
	private let onVideoEnd: () -> Void

	public init(
		for video: Binding<VersaVideo>,
		controlsConfig: ControlsConfig = .default,
		onSkip: @escaping (Int) -> Void = { _ in },
		onVideoEnd: @escaping () -> Void = {}
	) {
		self._video = video
		self.controlsConfig = controlsConfig
		self.onSkip = onSkip
		self.onVideoEnd = onVideoEnd
	}

	public func makeUIView(context: Context) -> VersaPlayerView {
		let view = VersaPlayerView()
		view.layer.backgroundColor = UIColor.black.cgColor
		view.playbackDelegate = context.coordinator
		
		if video.resizeFill {
			view.renderingView.playerLayer.videoGravity = .resizeAspectFill
		}

		let controls = makeControls()
		view.use(controls: controls)
		view.controls?.behaviour.shouldAutohide = controlsConfig.shouldAutoHide

		video.remote.playAction = {
			view.play()
		}
		video.remote.pauseAction = {
			view.pause()
		}

		return view
	}

	private func makeControls() -> VersaPlayerControls {
		switch controlsConfig.type {
		case .full:
			let controlBar = VersaControlBar()
			return controlBar.wrappedWithPlayerControls(offset: controlsConfig.offset)

		case .minimal:
			let controlBar = VersaControlBarMin(onSkip: onSkip)
			return controlBar.wrappedWithPlayerControls(offset: controlsConfig.offset)
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(onVideoEnd: onVideoEnd)
	}

	public func updateUIView(_ uiView: VersaPlayerView, context: Context) {
		let newVideo = if let asset = uiView.player.currentItem?.asset as? AVURLAsset {
			asset.url != video.url
		} else {
			true
		}

		if newVideo {
			if let url = video.url {
				uiView.set(item: VersaPlayerItem(url: url))
				if video.autoPlay {
					uiView.play()
				} else {
					uiView.pause()
				}
			} else {
				uiView.set(item: nil)
			}
		}

		if uiView.player.isMuted != video.isMuted {
			uiView.player.isMuted = video.isMuted
		}
	}

	public static func dismantleUIView(_ uiView: VersaPlayerView, coordinator: Coordinator) {
		uiView.set(item: nil)
	}

	public class Coordinator: NSObject, VersaPlayerPlaybackDelegate {
		private let onVideoEnd: () -> Void

		init(onVideoEnd: @escaping () -> Void) {
			self.onVideoEnd = onVideoEnd
		}

		public func playbackDidEnd(player: VersaPlayer) {
			onVideoEnd()
		}
	}
}

struct VersaVideoPlayer_Previews: PreviewProvider {
	struct ListPreview: View {
		@State private var video = VersaVideo(url: nil)
		@State private var currentIndex: Int = 0

		private let videos = [
			URL(string: "https://assets.afcdn.com/video49/20210722/v_645516.m3u8")!,
			URL(string: "http://sample.vodobox.net/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8")!
		]

		var body: some View {
			VStack {
				VersaVideoPlayer(
					for: $video,
					controlsConfig: ControlsConfig(type: .minimal),
					onSkip: onSkip,
					onVideoEnd: {
						onSkip(delta: 1)
					}
				)
				.aspectRatio(1.78, contentMode: .fit)

				HStack {
					Button("Play") {
						video.remote.play()
					}

					Button("Pause") {
						video.remote.pause()
					}

					Button("Next Video") {
						onSkip(delta: 1)
					}

					Button("Unload") {
						video.url = nil
					}
				}
			}
			.onAppear {
				video.url = videos[currentIndex]
			}
		}

		private func onSkip(delta: Int) {
			let nextIndex = currentIndex + delta
			guard nextIndex >= 0 && nextIndex < videos.count else { return }
			currentIndex = nextIndex
			video.url = videos[currentIndex]
		}
	}

	static var previews: some View {
		if let url = URL(string: "http://sample.vodobox.net/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8") {
			VersaVideoPlayer(
				for: .constant(VersaVideo(url: url, isMuted: true, resizeFill: true)),
				controlsConfig: ControlsConfig(type: .full, offset: 60),
				onVideoEnd: {
					print("video ended")
				}
			)
		}

		ListPreview()
	}
}
