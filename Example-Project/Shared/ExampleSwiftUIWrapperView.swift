import UIKit
import SwiftUI

struct ExampleSwiftUIWrapperView: UIViewRepresentable {
    typealias UIViewType = ExampleGameView

    @ObservedObject var gameData: ExampleGameDataObservable

    func makeUIView(context: Context) -> ExampleGameView {
        let view = ExampleGameView(frame: .zero, gameModel: GGM_Game())
        view.gridType = gameData.gridType
        view.setRecognizesTaps(true)
        return view
    }

    func updateUIView(_ uiView: ExampleGameView, context: Context) {
        uiView.game.gridHeight = Int(gameData.gameRows)
        uiView.game.gridWidth = Int(gameData.gameColumns)
        uiView.gridType = gameData.gridType
        uiView.setRecognizesTaps(gameData.respondsToTapGesture)
        uiView.setRecognizesDrags(gameData.respondsToDragGesture)
    }
}
