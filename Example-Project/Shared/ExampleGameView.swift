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
            case .dragStart:
                return .yellow
            case .dragContinue:
                return .orange
            case .dragEnd:
                return .purple
            }
        }
        else {
            return .clear
        }
    }

    override func handleTap(atCoord point: GGM_Game.Point) {
        if let realState = GGM_Game.State(rawValue: game.stateAt(x: point.x, y: point.y) ?? game.stateDefault) {
            game.setState(atX: point.x, andY: point.y, to: game.stateAfter(state: realState).rawValue)
            refreshViewState(forX: point.x, andY: point.y)
        } else {
            game.setState(atX: point.x, andY: point.y, to: 1)
            refreshViewState(forX: point.x, andY: point.y)
        }
        // this isn't necessary, but gives us a nice print in the console
        super.handleTap(atCoord: point)
    }

    override func handleDragBegan(atCoord point: GGM_Game.Point) {
        game.setState(atX: point.x, andY: point.y, to: Int(GGM_Game.State.dragStart.rawValue))
        // this isn't necessary, but gives us a nice print in the console
        super.handleDragBegan(atCoord: point)
    }

    override func handleDragContinued(atCoord point: GGM_Game.Point) {
        if let pointBegan = dragCoordBegan, point != pointBegan {
            game.setState(atX: point.x, andY: point.y, to: Int(GGM_Game.State.dragContinue.rawValue))
        }
        // this isn't necessary, but gives us a nice print in the console
        super.handleDragContinued(atCoord: point)
    }

    override func handleDragEnded(atCoord point: GGM_Game.Point) {
        game.setState(atX: point.x, andY: point.y, to: Int(GGM_Game.State.dragEnd.rawValue))
        // this isn't necessary, but gives us a nice print in the console
        super.handleDragEnded(atCoord: point)
    }

}
