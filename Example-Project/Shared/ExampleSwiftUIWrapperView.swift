import UIKit
import SwiftUI

struct ExampleSwiftUIWrapperView: UIViewRepresentable {
    typealias UIViewType = ExampleGameView

    var game: GGM_Game
    var gridType: GGM_UIView.GridType

    func makeUIView(context: Context) -> ExampleGameView {
        let view = ExampleGameView(frame: .zero, gameModel: game)
        view.gridType = gridType
        view.setRecognizesTaps(true)
        return view
    }

    func updateUIView(_ uiView: ExampleGameView, context: Context) {
        uiView.refreshViewPositionsAndStates()
    }
}
