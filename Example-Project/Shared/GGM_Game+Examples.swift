import Foundation

extension GGM_Game {
    enum State: Int {
        case red
        case blue
        case green
    }

    func stateAfter(state: State) -> State {
        switch state {
        case .red:
            return .blue
        case .blue:
            return .green
        case .green:
            return .red
        }
    }
}
