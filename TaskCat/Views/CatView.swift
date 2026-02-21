import SwiftUI

struct CatView: View {

    var state: CatState
    var height: CGFloat
    @State private var offsetX: CGFloat = -150
    @State private var offsetY: CGFloat = 0

    // ← 追加: 歩き用フレーム
    @State private var currentFrame = 0
    private let walkFrames: [String] = (1...89).map { "cat_walk_\($0)" } // 24フレーム

    var body: some View {
        Image(walkFrames[currentFrame])
            .resizable()
            .scaledToFit()
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .shadow(color: .black.opacity(0.08), radius: 20, y: 10)
            .onAppear {
                startFrameTimer()
            }
    }


    private func startFrameTimer() {
        Timer.scheduledTimer(withTimeInterval: 1/24, repeats: true) { _ in
            currentFrame = (currentFrame + 1) % walkFrames.count
        }
    }

}
