//
import SwiftUI

struct ExampleContentView: View {
    @StateObject var gameData = ExampleGameDataObservable()
    @State private var selectedViewType = 0

    var body: some View {
        VStack {
            HStack {
                Text("Generic Game Model")
                    .padding(.horizontal)
                Picker("View Type", selection: $selectedViewType, content: {
                    Text("Square").tag(0)
                    Text("Hex").tag(1)
                    Text("Label").tag(2)
                    Text("Triangle").tag(3)
                }).pickerStyle(SegmentedPickerStyle()).padding()
            }
            HStack {
                Text("Size X: \(gameData.gameColumns, specifier: "%.0f")")
                Slider(value: $gameData.gameColumns, in: 1.0...20.0, step: 1.0)
                Spacer(minLength: 20)
                Text("Size Y: \(gameData.gameRows, specifier: "%.0f")")
                Slider(value: $gameData.gameRows, in: 1.0...20.0, step: 1.0)
            }.padding()
            ExampleSwiftUIWrapperView(gameData: gameData)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExampleContentView()
            ExampleContentView()
                .previewLayout(.fixed(width: 1366, height: 1024))
            ExampleContentView()
                .previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
            ExampleContentView()
                .previewDevice("iPhone 12")
        }
    }
}
