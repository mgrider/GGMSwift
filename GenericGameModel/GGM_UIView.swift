import UIKit

/// A `UIView` subclass meant to visually represent a single `GGM_Game` instance.
class GGM_UIView: UIView {

    // MARK: Types

    enum GridType {
        case color
        // TODO: flush out all these grid types
//        case custom
//        case hex
//        case hexSquare
//        case image
//        case textLabel
//        case triangle
    }

    // MARK: Properties

    /// Game model instance.
    var game: GGM_Game

    /// Height of each subview (not actually pixels, but in logical units).
    var gridPixelHeight: CGFloat = 1.0

    /// Width of each subview (not actually pixels, rather logical units).
    var gridPixelWidth: CGFloat = 1.0

    /// The type of our grid subviews.
    var gridType: GridType = .color {
        didSet {
            setupInitialGridViewArray()
        }
    }

    /// An array of arrays of grid views.
    var gridViewArray = [[UIView]]()


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

    // MARK: customization of subviews

    /// Returning a color for each state in your game model.
    /// - Parameter state: The `Int` value corresponding to the state.
    /// - Returns: `UIColor`
    open func colorForGameState(_ state: Int) -> UIColor {
        switch state {
        case 0: return .blue
        case 1: return .green
        case 2: return .red
        default: return .clear
        }
    }

    /// Retrieving a new subview for each view in the grid. Override this function if you want to implement
    /// custom `UIView` subclasses for your grid.
    /// - Parameter state: An `Int` value corresponding to the state for the view.
    open func newSubviewForGameState(_ state: Int) -> UIView {
        switch gridType {
        case .color:
            let view = UIView()
            view.backgroundColor = colorForGameState(state)
            return view
        }
    }

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
        case .color:
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
            let color = colorForGameState(state)
            gridViewArray[y][x].backgroundColor = color
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
        case .color:
            let pixelX = gridPixelWidth * CGFloat(x)
            let pixelY = gridPixelHeight * CGFloat(y)
            return CGPoint(x: pixelX, y: pixelY)
        }
    }

    /// Get the coordinate point for a given pixel `CGPoint`.
    /// - Parameter pixelPoint: A pixel coordinate, presumably within the bounds of this view.
    /// - Returns: A `CGPoint` containing coordinates corresponding to x,y values in our game object.
    func coordinatePointFor(pixelPoint: CGPoint) -> CGPoint {
        guard CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height).contains(pixelPoint) else {
            return CGPoint(x: -1, y: -1);
        }
        switch gridType {
        case .color:
            let x = pixelPoint.x / gridPixelWidth;
            let y = pixelPoint.y / gridPixelHeight;
            return CGPoint(x: x, y: y)
        }
    }

    // MARK: tap touch detection

    private var tapRecognizer: UITapGestureRecognizer?

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

    @objc private func recognizeATap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        let coordinates = coordinatePointFor(pixelPoint: location)
        handleTap(atX: Int(coordinates.x), andY: Int(coordinates.y))
    }

    open func handleTap(atX x: Int, andY y: Int) {
        // override this in your subclass
        print("in GGM_UIView.m ... handleTap(atX:andY:) (\(x),\(y))")
    }

}
