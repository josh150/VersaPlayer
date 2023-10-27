import AVKit
import SwiftUI

public struct VersaVideoPlayer: UIViewRepresentable {
	@Binding private var video: VersaVideo
	private let onVideoEnd: () -> Void

	public init(for video: Binding<VersaVideo>, onVideoEnd: @escaping () -> Void = {}) {
		self._video = video
		self.onVideoEnd = onVideoEnd
	}

	public func makeUIView(context: Context) -> VersaPlayerView {
		let view = VersaPlayerView()
		view.layer.backgroundColor = UIColor.black.cgColor
		view.playbackDelegate = context.coordinator

		let controls = makeControls()
		view.use(controls: controls)
		view.controls?.behaviour.shouldAutohide = true

		return view
	}

	private func makeControls() -> VersaPlayerControls {
		let controlBar = VersaControlBar()
		return controlBar.wrappedWithPlayerControls()
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
			uiView.set(item: VersaPlayerItem(url: video.url))
			if video.autoPlay {
				uiView.play()
			} else {
				uiView.pause()
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
	struct ListPreview: SwiftUI.View {
		@State private var video = VersaVideo(url: URL(string: "https://assets.afcdn.com/video49/20210722/v_645516.m3u8")!)

		var body: some SwiftUI.View {
			VStack {
				VersaVideoPlayer(for: $video) {
					nextVideo()
				}
				.aspectRatio(1.78, contentMode: .fit)

				SwiftUI.Button("Next Video") {
					nextVideo()
				}
			}
		}

		private func nextVideo() {
			video.url = URL(string: "http://sample.vodobox.net/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8")!
		}
	}

	static var previews: some SwiftUI.View {
		if let url = URL(string: "http://sample.vodobox.net/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8") {
			VersaVideoPlayer(for: .constant(VersaVideo(url: url, isMuted: true))) {
				print("video ended")
			}
			.aspectRatio(1.78, contentMode: .fit)
		}

		ListPreview()
	}
}
