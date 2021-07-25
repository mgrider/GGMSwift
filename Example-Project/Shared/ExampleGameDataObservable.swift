import Foundation

class ExampleGameDataObservable: ObservableObject {

    @Published var gameColumns = 8.0

    @Published var gameRows = 8.0

    @Published var gridType = GGM_UIView.GridType.color

}
