//
//  ContentView.swift
//  Shared
//
//  Created by Martin Grider on 7/2/21.
//

import SwiftUI

struct ExampleContentView: View {
    @State var game = GGM_Game(gridWidth: 8, gridHeight: 8)
    @State private var selectedViewType = 0
    @State private var selectedSizeX = 8.0
    @State private var selectedSizeY = 8.0
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
                Text("Size X: \(selectedSizeX, specifier: "%.0f")")
                Slider(value: $selectedSizeX, in: 1.0...20.0, step: 1.0)
                Spacer(minLength: 20)
                Text("Size Y: \(selectedSizeY, specifier: "%.0f")")
                Slider(value: $selectedSizeY, in: 1.0...20.0, step: 1.0)
            }.padding()
            ExampleSwiftUIWrapperView(game: game, gridType: .color)
                .background(Color.red)
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
