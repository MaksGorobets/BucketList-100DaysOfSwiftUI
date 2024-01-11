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
        
        let viewModel: MapView.ViewModel
        
        var isPinSet = false
        
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
        }
            
        }
        var currentNumbers = [Int]()
        var rightCombo = [Int]()
        
        var isShowingAlert = false
        var alertMessage = ""
        
        func savePin() {
            print("Saving a new pin \(currentNumbers)")
            FileManager().write(object: currentNumbers, to: "PinCombo")
        }
        
        func createButton(_ number: Int, _ action: @escaping () -> Void) -> some View {
            Button(String(number + 1), action: action)
                .buttonStyle(.bordered)
                .clipShape(.circle)
                .font(.system(size: 50))
        }
        
        func setPin() {
            rightCombo = currentNumbers
            savePin()
            alertMessage = "Success!"
            isShowingAlert = true
            currentNumbers.removeAll()
            isPinSet = true
            UserDefaults.standard.setValue(isPinSet, forKey: "Pin")
        }
        
        func unlock() {
            viewModel.isUnlocked = true
            currentNumbers.removeAll()
        }
        
        func wrongPin() {
            alertMessage = "Wrong PIN!"
            isShowingAlert = true
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
                self.rightCombo = try FileManager().read(from: "PinCombo", as: [Int].self)
            } catch {
                print(error)
            }
        }
        
    }
}
