import UIKit

final class ExampleGameView: GGM_UIView {

    override func stateColor(forState state: Int) -> UIColor {
        if let realState = GGM_Game.State(rawValue: state) {
            switch realState {
            case .blue:
                return .blue
            case .green:
                return .green
            case .red:
                return .red
            }
        }
        else {
            return .clear
        }
    }

    override func handleTap(atX x: Int, andY y: Int) {
        if let realState = GGM_Game.State(rawValue: game.stateAt(x: x, y: y) ?? game.stateDefault) {
            game.setState(atX: x, andY: y, to: game.stateAfter(state: realState).rawValue)
            refreshViewState(forX: x, andY: y)
        } else {
            game.setState(atX: x, andY: y, to: 1)
            refreshViewState(forX: x, andY: y)
        }
        super.handleTap(atX: x, andY: y)
    }

}
