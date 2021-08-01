import UIKit

/// A `UIView` subclass meant to visually represent a single `GGM_Game` instance.
class GGM_UIView: UIView {

    // MARK: Types

    enum GridType: Hashable {
        case color
        // TODO: flush out all these grid types
//        case custom
//        case hex
//        case hexSquare
//        case image
        case textLabel
//        case triangle
    }

    // MARK: Game/Grid Properties

    /// Game model instance.
    var game: GGM_Game {
        didSet {
            setupInitialGridViewArray()
        }
    }

    /// Height of each subview in the grid. (Not actually pixels, but in logical units.)
    private(set) var gridPixelHeight: CGFloat = 1.0

    /// Width of each subview in the grid. (Not actually pixels, rather logical units.)
    private(set) var gridPixelWidth: CGFloat = 1.0

    /// The type of our grid subviews.
    var gridType: GridType = .color {
        didSet {
            setupInitialGridViewArray()
        }
    }

    /// An array of arrays of grid views.
    private(set) var gridViewArray = [[UIView]]()


    // MARK: Initialization & Setup

    init(frame: CGRect, gameModel: GGM_Game) {
        self.game = gameModel
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        print("TODO: support IB.")
        return nil
    }

    override func layoutSubviews() {
        setupInitialGridViewArray()
    }

    /// Basically just clear out all the old views here
    private func removeSubviewsFromGridViewArray() {
        for array in gridViewArray {
            for view in array {
                view.removeFromSuperview()
            }
        }
        gridViewArray.removeAll()
    }

    /// Creates the initial array of subviews.
    func setupInitialGridViewArray() {
        removeSubviewsFromGridViewArray()
        setupPixelSizes()
        // setup the actual array
        for y in 0..<game.gridHeight {
            var row = [UIView]()
            for x in 0..<game.gridWidth {
                let view = newSubviewForGameState(game.stateAt(x: x, y: y) ?? game.stateDefault)
                addSubview(view)
                row.append(view)
            }
            gridViewArray.append(row)
        }
        refreshAllViewPositions()
    }

    /// Calculate the size of our subviews.
    func setupPixelSizes() {
        switch (gridType) {
        default:
            setupPixelSizesSquareGrid()
        }
    }

    /// Figure out how many pixels tall and wide each subview should be.
    private func setupPixelSizesSquareGrid() {
        gridPixelWidth = CGFloat(self.frame.size.width / CGFloat(game.gridWidth));
        gridPixelHeight =  CGFloat(self.frame.size.height / CGFloat(game.gridHeight));
    }


    // MARK: retrieving specific views

    /// Get a grid subview at `GGM_Game.Point`
    func viewFor(point: GGM_Game.Point) -> UIView? {
        guard point.x >= 0, point.y >= 0, point.x < game.gridWidth, point.y < game.gridHeight else {
            return nil
        }
        return gridViewArray[point.y][point.x]
    }

    /// Get a grid subview at x,y
    func viewFor(x: Int, y: Int) -> UIView? {
        guard x >= 0, y >= 0, x < game.gridWidth, y < game.gridHeight else {
            return nil
        }
        return gridViewArray[y][x]
    }


    // MARK: customization of subviews

    /// Returning a color for each state in your game model.
    /// Override this function to provide your own colors.
    ///
    /// - Parameter state: The `Int` value corresponding to the state.
    /// - Returns: `UIColor`
    open func stateColor(forState state: Int) -> UIColor {
        switch state {
        case 0: return .blue
        case 1: return .green
        case 2: return .red
        default: return .clear
        }
    }

    /// Returning some text for each state in your game model.
    /// Override this function to provide your own.
    ///
    /// - Parameter state: The `Int` value corresponding to the state.
    /// - Returns: A `String` representation of the state value.
    open func stateTextString(forState state: Int) -> String {
        return "\(state)"
    }


    /// Retrieving a new subview for each view in the grid. Override this function if you want to implement
    /// custom `UIView` subclasses for your grid.
    /// - Parameter state: An `Int` value corresponding to the state for the view.
    open func newSubviewForGameState(_ state: Int) -> UIView {
        switch gridType {
        case .color:
            let view = UIView()
            view.backgroundColor = stateColor(forState: state)
            return view
        case .textLabel:
            let label = UILabel()
            label.numberOfLines = 3
            label.adjustsFontSizeToFitWidth = true
            label.lineBreakMode = .byWordWrapping
            label.textAlignment = .center
            label.minimumScaleFactor = 0.5
            label.font = .systemFont(ofSize: 11)
            label.layer.borderColor = UIColor.darkGray.cgColor
            label.layer.borderWidth = 3.0
            label.text = stateTextString(forState: state)
            return label
        }
    }

    // MARK: refreshing/updating views

    /// Refreshes all view positions.
    func refreshAllViewPositions() {
        for y in 0..<game.gridHeight {
            for x in 0..<game.gridWidth {
                refreshViewPosition(forX: x, andY: y)
            }
        }
    }

    /// Refreshes view position and state for x,y.
    open func refreshView(forX x: Int, andY y: Int) {
        refreshViewPosition(forX: x, andY: y)
        refreshViewState(forX: x, andY: y)
    }

    /// Repositions the view for x,y. Note that this does not account for state.
    /// - Parameters:
    ///   - x: The horizontal coordinate position.
    ///   - y: The vertical coordinate position.
    open func refreshViewPosition(forX x: Int, andY y: Int) {
        switch gridType {
        case .color, .textLabel:
            let view = gridViewArray[y][x]
            let point = pixelPoint(forX: x, andY: y)
            view.frame = CGRect(x: point.x, y: point.y, width: gridPixelWidth, height: gridPixelHeight)
        }
    }

    /// Refresh all view positions and states.
    func refreshViewPositionsAndStates() {
        for y in 0..<game.gridHeight {
            for x in 0..<game.gridWidth {
                refreshViewPosition(forX: x, andY: y)
                refreshViewState(forX: x, andY: y)
            }
        }
    }

    /// Updates the state for view at x,y.
    /// - Parameters:
    ///   - x: The horizontal coordinate position.
    ///   - y: The vertical coordinate position.
    open func refreshViewState(forX x: Int, andY y: Int) {
        guard let state = game.stateAt(x: x, y: y) else {
            // don't refresh states that aren't found
            return
        }
        switch gridType {
        case .color:
            let color = stateColor(forState: state)
            gridViewArray[y][x].backgroundColor = color
        case .textLabel:
            if let label = gridViewArray[y][x] as? UILabel {
                label.text = stateTextString(forState: state)
            }
        }
    }


    // MARK: pixels and coordinates

    /// Get the pixel coordinates for a given x,y coordinate.
    /// - Parameters:
    ///   - x: The horizontal coordinate position.
    ///   - y: The vertical coordinate position.
    /// - Returns: A `CGPoint` with relevant pixel coordinates.
    func pixelPoint(forX x: Int, andY y: Int) -> CGPoint {
        switch gridType {
        case .color, .textLabel:
            let pixelX = gridPixelWidth * CGFloat(x)
            let pixelY = gridPixelHeight * CGFloat(y)
            return CGPoint(x: pixelX, y: pixelY)
        }
    }

    /// Get the coordinate point for a given pixel `CGPoint`.
    /// - Parameter pixelPoint: A pixel coordinate, presumably within the bounds of this view.
    /// - Returns: A `CGPoint` containing coordinates corresponding to x,y values in our game object.
    func coordinatePointFor(pixelPoint: CGPoint) -> GGM_Game.Point {
        guard CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height).contains(pixelPoint) else {
            return (x: -1, y: -1);
        }
        switch gridType {
        case .color, .textLabel:
            let x = Int(pixelPoint.x / gridPixelWidth);
            let y = Int(pixelPoint.y / gridPixelHeight);
            return (x: x, y: y)
        }
    }


    // MARK: tap touch detection

    /// An optional `UITapGestureRecognizer`. If this is nil, tap recognition is disabled.
    private var tapRecognizer: UITapGestureRecognizer?

    /// Call this function to enable or disable tap gesture recognition.
    /// - Parameter shouldRecognizeTaps: Bool
    final func setRecognizesTaps(_ shouldRecognizeTaps: Bool) {
        if tapRecognizer == nil && shouldRecognizeTaps {
            tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(recognizeATap))
            addGestureRecognizer(tapRecognizer!)
        }
        else if let tapRecognizer = tapRecognizer, !shouldRecognizeTaps {
            removeGestureRecognizer(tapRecognizer)
            self.tapRecognizer = nil
        }
    }

    /// The handler for our tap gesture recognizer. This will call `handleTap(atX:andY:)`,
    /// which is what you want to override in your subclass.
    @objc private func recognizeATap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        let coordinates = coordinatePointFor(pixelPoint: location)
        handleTap(atCoord: (x: coordinates.x, y: coordinates.y))
    }

    /// A tap was detected at x,y (in coordinate space). Override this in your subclass to provide
    /// any functionality.
    open func handleTap(atCoord point: GGM_Game.Point) {
        // override this in your subclass
        debugGesturePrint("in GGM_UIView.m ... handleTap(atCoord:) (\(point.x),\(point.y))")
    }


    // MARK: drag touch detection

    /// A game coordinate point where the current drag began. This will be `nil` when a drag is
    /// not in progress, or more specifically after `handleDragEnded(atCoord:)` is called.
    var dragCoordBegan: GGM_Game.Point?

    /// A game coordinate point where the drag is currently happening.
    var dragCoordCurrent: GGM_Game.Point?

    /// Whether or not any drag gestures should move the view where the drag began. The default value is false.
    var dragMovesOriginView = false

    /// The `CGPoint` where the current drag began.
    private(set) var dragPixelPointBegan: CGPoint?

    /// The `CGPoint` where the drag is currently.
    private(set) var dragPixelPointCurrent: CGPoint?

    /// An optional `UIPanGestureRecognizer`. If this is `nil` (the default), drag gestures are disabled.
    private var dragRecognizer: UIPanGestureRecognizer?

    /// Call this function to enable dragging between coordinates of the game grid.
    ///
    /// You will almost certainly want to implement one or some of the following:
    /// - `handleDragBegan(atCoord:)`
    /// - `handleDragContinued(atCoord:)`
    /// - `handleDragEnded(atCoord:)`
    ///
    /// Also see exposed variables:
    /// - `dragCoordBegan: CGPoint`
    /// - `dragCoordCurrent: CGPoint`
    /// - `dragMovesOriginView: Bool`
    ///
    /// - Parameter shouldRecognizeDrags: `true` to enable drag gestures, `false` to disable.
    final func setRecognizesDrags(_ shouldRecognizeDrags: Bool) {
        if dragRecognizer == nil && shouldRecognizeDrags {
            dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(recognizeADrag(sender:)))
            addGestureRecognizer(dragRecognizer!)
        }
        else if let dragRecognizer = dragRecognizer, !shouldRecognizeDrags {
            removeGestureRecognizer(dragRecognizer)
            self.dragRecognizer = nil
        }
    }

    /// The internal handler for our drag gesture recognizer.
    @objc private func recognizeADrag(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self)
        let coordinate = coordinatePointFor(pixelPoint: location)
        switch sender.state {
        case .began:
            dragCoordBegan = coordinate
            dragPixelPointBegan = location
            handleDragBegan(atCoord: coordinate)
        case .ended:
            dragCoordCurrent = coordinate
            dragPixelPointCurrent = location
            if dragMovesOriginView {
                dragMoveOriginEnd()
            }
            handleDragEnded(atCoord: coordinate)
            dragCoordBegan = nil
            dragCoordCurrent = nil
        case .changed:
            dragCoordCurrent = coordinate
            dragPixelPointCurrent = location
            if dragMovesOriginView {
                dragMoveOriginContinue()
            }
            handleDragContinued(atCoord: coordinate)
        default:
            // there are various other states we don't care about
            return
        }
    }

    ///
    private func dragMoveOriginContinue() {
        guard let startPoint = dragCoordBegan,
              let startView = viewFor(point: startPoint),
              let pixelStart = dragPixelPointBegan,
              let pixelCurrent = dragPixelPointCurrent else {
            return
        }
        bringSubviewToFront(startView)
        let offsetX = pixelCurrent.x - pixelStart.x
        let offsetY = pixelCurrent.y - pixelStart.y
        // TODO
    }

    ///
    private func dragMoveOriginEnd() {
        // TODO
        dragPixelPointBegan = nil
        dragPixelPointCurrent = nil
    }

    /// A drag began at `point` (x,y in coordinate space). Override this in your subclass to provide
    /// any real functionality. Also see `dragCoordBegan: CGPoint` and `dragMovesOriginView: Bool`.
    open func handleDragBegan(atCoord point: GGM_Game.Point) {
        // override this in your subclass
        debugGesturePrint("in GGM_UIView.m ... handleDragBegan(atCoord:) (\(point.x),\(point.y))")
    }

    /// A drag continued at `point` (x,y in coordinate space). Override this in your subclass to provide
    /// any real functionality.
    open func handleDragContinued(atCoord point: GGM_Game.Point) {
        // override this in your subclass
        debugGesturePrint("in GGM_UIView.m ... handleDragContinued(atCoord:) (\(point.x),\(point.y))")
    }

    /// A drag ended at `point` (x,y in coordinate space). Override this in your subclass to provide
    /// any real functionality.
    open func handleDragEnded(atCoord point: GGM_Game.Point) {
        // override this in your subclass
        debugGesturePrint("in GGM_UIView.m ... handleDragEnded(atCoord:) (\(point.x),\(point.y))")
    }


    // MARK: debug related

    /// A `Bool` indicating whether or not to `print()` gesture-related debug messages.
    final var debugGestures = true

    /// Determines whether to print gesture debug statements here.
    private func debugGesturePrint(_ statement: String) {
        guard debugGestures else { return }
        #if DEBUG
        print(statement)
        #endif
    }

}
