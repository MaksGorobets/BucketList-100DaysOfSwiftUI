//
//  PinViewModel.swift
//  BucketList
//
//  Created by Maks Winters on 11.01.2024.
//

import Foundation
import SwiftUI

extension PinView {
    @Observable
    final class ViewModel {
        
        let fileManager = FileManagerStatic.fileManager
        
        let viewModel: MapView.ViewModel
        
        var isPinSet = false
        
        var currentNumbers = [Int]()
        var rightCombo = [Int]()
        
        var isShowingAlert = false
        var alertMessage = ""
        
        var pressNum = 0 { didSet {
            print("Press num is \(pressNum)")
            if pressNum == 4 {
                if isPinSet == false {
                    setPin()
                    isPinSet = true
                } else {
                    if currentNumbers == rightCombo {
                        unlock()
                    } else {
                        wrongPin()
                    }
                }
            }
        }}
        
        func savePin() {
            print("Saving a new pin \(currentNumbers)")
            FileManager().write(object: currentNumbers, to: "PinCombo")
        }
        
        func createButton(_ number: Int, _ action: @escaping () -> Void) -> some View {
            Button {
                action()
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color(.pinPadButton))
                    .overlay (
                        Text(String(number + 1))
                    )
            }
            .frame(width: 75, height: 75)
            .buttonStyle(.plain)
        }
        
        func setPin() {
            rightCombo = currentNumbers
            savePin()
            alertUser("Success!")
            currentNumbers.removeAll()
            isPinSet = true
            UserDefaults.standard.setValue(isPinSet, forKey: "Pin")
        }
        
        func alertUser(_ message: String) {
            alertMessage = message
            isShowingAlert = true
        }
        
        func unlock() {
            viewModel.isUnlocked = true
            currentNumbers.removeAll()
        }
        
        func wrongPin() {
            alertUser("Wrong PIN!")
        }
        
        func resetPinField() {
            pressNum = 0
            currentNumbers.removeAll()
        }
        
        init(viewModel: MapView.ViewModel) {
            let defaults = UserDefaults.standard
            self.viewModel = viewModel
            self.isPinSet = defaults.object(forKey: "Pin") as? Bool ?? false
            do {
                self.rightCombo = try fileManager.read(from: "PinCombo", as: [Int].self)
            } catch {
                print(error)
            }
        }
        
    }
}
