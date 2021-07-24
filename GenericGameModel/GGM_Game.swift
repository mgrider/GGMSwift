import Foundation

/// Base model for game data.
struct GGM_Game: Codable, CustomStringConvertible {

    // MARK: convenience properties

    /// Whether or not the game is over.
    var isOver = false

    /// Whether or not the game is paused.
    var isPaused = false

    // MARK: Date & time & game duration (mostly still TODO)

    /// The start datetime of the game.
    var gameTimeStartDate: Date

    // MARK: state properties

    /// A default variable for grid states.
    var stateDefault = -1

    /// The value representing an empty game state
    var stateEmpty = -1

    /// game states are between 0 and gridMaxStateInt
    var stateMax = 1

    /// A multidimensional array representing the state of each grid space
    var states = [[Int]]()

    // MARK: grid properties

    /// Height of the grid in "units".
    var gridHeight: Int

    /// Width of the grid in "units".
    var gridWidth: Int

    // MARK: Initializers & setup

    /// Initializer for the GGM_Model instance.
    init(gridWidth: Int = 8,
         gridHeight: Int = 8,
         stateDefault: Int = 0,
         startDate: Date = Date()) {
        self.gameTimeStartDate = startDate
        self.gridWidth = 4
        self.gridHeight = 4
        self.stateDefault = stateDefault

        setupGrid()
    }

    /// This re-creates the "grid", which is essentially the multidimensional state array. Called on init.
    mutating func setupGrid() {
        states.removeAll()
        for _ in 0...gridHeight {
            states.append(Array(repeating: stateDefault, count: gridWidth))
        }
    }

    // MARK: setting state

    /// set a single state when x and y are known
    mutating func setState(atX x: Int, andY y: Int, to state: Int) {
        states[y][x] = state
    }

    /// get a random possible state int between 0 and `stateMax`
    func randomStateInt() -> Int {
        return Int.random(in: 0...stateMax)
    }

    /// completely randomize the grid states with values between `0` and `stateMax`
    mutating func randomizeStates() {
        for y in 0...gridHeight {
            for x in 0...gridWidth {
                states[y][x] = randomStateInt()
            }
        }
    }

    /// set all states to this new value
    mutating func setAllStates(to state: Int) {
        for y in 0...gridHeight {
            for x in 0...gridWidth {
                states[y][x] = state
            }
        }
    }

    // MARK: getting state

    /// get a single state value
    func stateAt(x: Int, y: Int) -> Int? {
        guard x >= 0, y >= 0, x < gridWidth, y < gridHeight else {
            return nil
        }
        return states[y][x]
    }

    /// get a state in a position one unit away in a given direction
    func state(inDirection: GGM_Direction, fromX x: Int, andY y: Int) -> Int? {
        switch inDirection {
        case .up:
            return stateAt(x: x, y: y-1)
        case .down:
            return stateAt(x: x, y: y+1)
        case .left:
            return stateAt(x: x-1, y: y)
        case .right:
            return stateAt(x: x+1, y: y)
        }
    }

    // MARK: debug

    /// `toString` for debugging
    func toString() -> String {
        var string = "GGM_Game (\(type(of: self))) \n"
        string += "\(String(describing: state)) \n"
        string += "Game Over: \(isOver), Paused: \(isPaused)"
        return string
    }

    /// This exists to satisfy `CustomStringConvertible`, and allow you to
    /// `print("\(game)")` where game is an instance of `GGM_Game`.
    var description: String {
        return toString()
    }

}
