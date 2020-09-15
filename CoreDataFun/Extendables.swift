//
//  Extendables.swift
//  CoreDataFun
//
//  Created by Gil Estes on 9/15/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import Foundation
import SwiftUI

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
