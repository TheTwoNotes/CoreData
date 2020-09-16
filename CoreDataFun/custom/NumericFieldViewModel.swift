//
//  NumericFieldViewModel.swift
//  CoreDataFun
//
//  Created by Gil Estes on 9/16/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import Combine

class NumericFieldViewModel: ObservableObject {
    @Published var wasEdited: Bool = false

    let decimal: String
    let characterLimit: Int
    let maximumNumber: Int

    var textValue: String = "" {
        willSet {
            objectWillChange.send()
        }
    }

    var integer16Value: Int16 {
        return Int16(enteredTextValue) ?? 0
    }

    var integerValue: Int {
        return Int(enteredTextValue) ?? 0
    }

    var isPopulated: Bool {
        return textValue.count > 0 && enteredTextValue.count > 0
    }

    var count: Int {
        enteredTextValue.count
    }

    var enteredTextValue: String = "" {
        willSet {
            objectWillChange.send()
        }
        didSet {
            let filteredValue = enteredTextValue.filter("0123456789\(decimal)".contains)

            let newValue = Int(filteredValue) ?? 0
            guard newValue <= maximumNumber
            else {
                enteredTextValue = oldValue
                wasEdited = (enteredTextValue != textValue)
                return
            }

            if enteredTextValue.count != filteredValue.count {
                enteredTextValue = filteredValue
            }

            if enteredTextValue.count > characterLimit, oldValue.count <= characterLimit {
                enteredTextValue = oldValue
            }

            wasEdited = (enteredTextValue != textValue)
        }
    }

    init(limit: Int = 1, decimalAllowed: Bool = false, numberMax: Int = -1) {
        characterLimit = limit

        if decimalAllowed {
            decimal = "."
        } else {
            decimal = ""
        }
        maximumNumber = numberMax
    }

    func clear() {
        textValue = ""
    }

    func updateValue(val: Int16) {
        enteredTextValue = "\(val)"
    }

    func reload(int16: Int16) {
        reload(text: "\(int16)")
    }

    func reload(text: String) {
        textValue = text
        enteredTextValue = text
        wasEdited = false
    }
}
