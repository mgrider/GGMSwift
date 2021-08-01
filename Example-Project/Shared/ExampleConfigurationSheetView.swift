import SwiftUI

struct ExampleConfigurationSheetView: View {

    @ObservedObject var gameData: ExampleGameDataObservable

    var body: some View {

        NavigationView {

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

                Toggle(isOn: $gameData.respondsToDragGesture, label: {
                    Text("Drag Changes Grid States")
                })
                Toggle(isOn: $gameData.respondsToTapGesture, label: {
                    Text("Tap Changes Grid States")
                })

                Spacer()

            }.padding()

            .navigationBarTitle(Text("Configuration"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(
                    action: {
                            print("Dismissing sheet view...")
                        self.gameData.configurationShown = false
                    }) {
                            Text("Done").bold()
                    }
            )

        } // NavigationView

    }
}

struct ExampleConfigurationSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExampleConfigurationSheetView(
                gameData: ExampleGameDataObservable()
            )
        }
    }
}
