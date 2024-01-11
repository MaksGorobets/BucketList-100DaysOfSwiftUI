//
//  PinView.swift
//  BucketList
//
//  Created by Maks Winters on 11.01.2024.
//

import SwiftUI

struct PinView: View {
    
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .stroke(.primary)
            .frame(width: 175, height: 50)
            .padding(.vertical)
            .overlay (
                HStack {
                    ForEach(0..<viewModel.pressNum, id: \.self) { press in
                        Text("*")
                    }
                }
            )
        
        if viewModel.isPinSet == false {
            Text("Set a pin for a spare unlock method!")
                .foregroundStyle(.red)
        }
        
        Grid {
            GridRow {
                ForEach(0..<3) { number in
                    viewModel.createButton(number) {
                        viewModel.pressNum += 1
                        viewModel.currentNumbers.append(number)
                        print("Appending \(number)")
                    }
                }
            }
            GridRow {
                ForEach(3..<6) { number in
                    viewModel.createButton(number) {
                        viewModel.pressNum += 1
                        viewModel.currentNumbers.append(number)
                        print("Appending \(number)")
                    }
                }
            }
            GridRow {
                ForEach(6..<9) { number in
                    viewModel.createButton(number) {
                        viewModel.pressNum += 1
                        viewModel.currentNumbers.append(number)
                        print("Appending \(number)")
                    }
                }
            }
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.isShowingAlert) {
            Button("Ok") {
                viewModel.resetPinField()
            }
        }
    }
    init(viewModel: MapView.ViewModel) {
        self.viewModel = ViewModel(viewModel: viewModel)
    }
}

#Preview {
    PinView(viewModel: MapView().viewModel)
}
