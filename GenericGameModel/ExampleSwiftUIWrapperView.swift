import UIKit
import SwiftUI

struct ExampleSwiftUIWrapperView: UIViewRepresentable {
    typealias UIViewType = GGM_UIView

    var game: GGM_Game
    var gridType: GGM_UIView.GridType

    func makeUIView(context: Context) -> GGM_UIView {
        let view = GGM_UIView(frame: .zero, gameModel: game)
        view.gridType = gridType
        return view
    }

    func updateUIView(_ uiView: GGM_UIView, context: Context) {
        uiView.refreshViewPositionsAndStates()
    }
}
