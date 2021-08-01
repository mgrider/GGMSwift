import SwiftUI

struct ExampleContentView: View {
    @StateObject var gameData = ExampleGameDataObservable()

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        Text("Grid")
                        Picker("View Type", selection: $gameData.gridType, content: {
                                Text("Square").tag(GGM_UIView.GridType.color)
            //                    Text("Hex").tag(GGM_UIView.GridType.hex)
                                Text("Label").tag(GGM_UIView.GridType.textLabel)
            //                    Text("Triangle").tag(3)
                            }).pickerStyle(SegmentedPickerStyle())
                    }
                    HStack {
                        Text("Size X: \(gameData.gameColumns, specifier: "%.0f")")
                        Slider(value: $gameData.gameColumns, in: 1.0...20.0, step: 1.0)
                        Spacer(minLength: 20)
                        Text("Size Y: \(gameData.gameRows, specifier: "%.0f")")
                        Slider(value: $gameData.gameRows, in: 1.0...20.0, step: 1.0)
                    }
                }.padding()

                ExampleSwiftUIWrapperView(gameData: gameData)
            }
            .navigationBarTitle("Generic Game Model", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.gameData.configurationShown = true
                }, label: {
                    Text("Edit").bold()
                }))
        }.sheet(isPresented: $gameData.configurationShown) {
            ExampleConfigurationSheetView(gameData: gameData)
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
