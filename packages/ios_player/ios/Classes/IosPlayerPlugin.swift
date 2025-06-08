

import Flutter
import UIKit
import SwiftUI
import AVKit

// MARK: - SwiftUI Video Player View
struct NativeVideoPlayer: View {
    /// Video manzili Flutter’dan keladi
    let videoURL: URL

    /// AVPlayer ni bitta joyda boshqarish
    @StateObject private var playerController = PlayerController.shared

    // UI holatlar
    @State private var isPlaying          = false
    @State private var isShowControls     = true
    @State private var progress: Double   = 0
    @State private var total: Double      = 0

    var body: some View {
        VideoPlayer(player: playerController.player)
            .aspectRatio(16/9, contentMode: .fit)
            .background(Color.black.opacity(0.0001))
            .contentShape(Rectangle())
            .onTapGesture { toggleControls() }
            .overlay(alignment: .topTrailing)  { topBar }
            .overlay(alignment: .bottom)       { bottomBar }
            .overlay                          { centerControls }
            .onAppear {
                playerController.replaceItem(url: videoURL)
                total = playerController.player.currentItem?.duration.seconds ?? 0
                hideControls(after: 4)
            }
    }

    // MARK: - Control visibility
    private func toggleControls() {
        withAnimation(.easeInOut) { isShowControls.toggle() }
        if isShowControls { hideControls(after: 4) }
    }

    private func hideControls(after delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeInOut) { isShowControls = false }
        }
    }

    // MARK: - Overlays
    @ViewBuilder private var topBar: some View {
        if isShowControls {
            HStack(spacing: 16) {
                controlIcon("speaker.slash.fill") // mute icon
                Spacer()
                controlIcon("airpodsmax")
                controlIcon("airplayvideo")
                controlIcon("arrow.up.left.and.arrow.down.right") // resize icon
            }
            .font(.title2)
            .foregroundColor(.white)
            .padding()
        }
    }

    @ViewBuilder private var centerControls: some View {
        if isShowControls {
            HStack(spacing: 32) {
                controlIcon("backward.end.fill")
                controlIcon(isPlaying ? "pause.circle.fill" : "play.circle.fill", size: 52)
                    .onTapGesture {
                        isPlaying ? playerController.pause() : playerController.play()
                        isPlaying.toggle()
                        hideControls(after: 1)
                    }
                controlIcon("forward.end.fill")
            }
        }
    }

    @ViewBuilder private var bottomBar: some View {
        if isShowControls {
            VStack(spacing: 12) {
                // progress bar
                ProgressView(value: progress, total: total)
                    .progressViewStyle(.linear)
                    .tint(.gray)
                // time & extra controls
                HStack {
                    Text("0:00 / 0:00")
                        .font(.caption)
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 8) {
                        controlIcon("speaker.slash.fill")
                        extraButton("1x")
                        extraButton("CC")
                        extraButton("HD")
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Reusable small views
    @ViewBuilder private func controlIcon(_ systemName: String, size: CGFloat = 24) -> some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundColor(.white)
    }

    @ViewBuilder private func extraButton(_ text: String) -> some View {
        Text(text)
            .font(.caption2)
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.white, lineWidth: 1))
    }
}

// MARK: - PlayerController singleton
final class PlayerController: ObservableObject {
    static let shared = PlayerController()
    let player = AVPlayer()
    private init() { }
    func replaceItem(url: URL) { player.replaceCurrentItem(with: AVPlayerItem(url: url)) }
    func play()  { player.play() }
    func pause() { player.pause() }
}

// MARK: - Flutter plugin bridge
@objc(IosPlayerPlugin)
public class IosPlayerPlugin: NSObject, FlutterPlugin {
    private static let channelName = "ios_player"
    private static var hostingController: UIHostingController<NativeVideoPlayer>?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
        let instance = IosPlayerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "openPlayer":
            guard let args = call.arguments as? [String: Any],
                  let urlString = args["url"] as? String,
                  let url = URL(string: urlString) else {
                result(FlutterError(code: "BAD_ARGS", message: "URL not provided", details: nil))
                return
            }
            presentPlayer(with: url)
            result(nil)

        case "play":
            PlayerController.shared.play(); result(nil)
        case "pause":
            PlayerController.shared.pause(); result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // Present SwiftUI player modally
    private func presentPlayer(with url: URL) {
        DispatchQueue.main.async {
            let v = NativeVideoPlayer(videoURL: url)
            let host = UIHostingController(rootView: v)
            IosPlayerPlugin.hostingController = host
            guard let root = UIApplication.shared.windows.first?.rootViewController else { return }
            root.present(host, animated: true)
        }
    }
}
