import UIKit
import AVFoundation
enum PlayVoiceType {
    case loadPoint
    case unloadPoint
    case newNotification
}
class VoicePlaybackManager {
    static func playWithType(_ type: PlayVoiceType) {
        var resourceName = ""
        switch type {
        case .loadPoint:
            resourceName = "voice_load_point"
        case .unloadPoint:
            resourceName = "voice_unload_point"
        case .newNotification:
            resourceName = "voice_notification"
        }
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "mp3") else {
            return
        }
        let player = AVPlayer.init(playerItem: AVPlayerItem.init(url: url))
        let layer = AVPlayerLayer.init(player: player)
        UIApplication.shared.keyWindow?.layer.addSublayer(layer)
        layer.frame = .zero
        player.play()
    }
}
