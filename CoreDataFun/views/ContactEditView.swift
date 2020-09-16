//
//  ContactEditView.swift
//  CoreDataFun
//
//  Created by Gil Estes on 9/15/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import SwiftUI

struct ContactEditView: View {
    @ObservedObject private var keyboardResponder = KeyboardResponder()

    @ObservedObject var contact: Contact

    @State var editing: Bool = false

    @State var editButtonText: String = "Edit"
    @State var newFirstName: String = ""
    @State var newLastName: String = ""
    @ObservedObject var newAreaCode = NumericFieldViewModel(limit: 3, decimalAllowed: false, numberMax: 999)
    @ObservedObject var newPhone = NumericFieldViewModel(limit: 7, decimalAllowed: false, numberMax: 9_999_999)

    @State var newStreet: String = ""
    @State var newCity: String = ""
    @State var newState: String = ""
    @ObservedObject var newZipCode = NumericFieldViewModel(limit: 5, decimalAllowed: false, numberMax: 99999)

    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            HStack {
                if editing {
                    Button(action: {
                        self.cancelEdit()
                    }) {
                        Text("Cancel Edit")
                    }
                }

                Spacer()

                Button(action: {
                    if self.editing {
                        self.updateContact()
                    }
                    self.editing.toggle()
                    if self.editing {
                        self.editButtonText = "Save"
                    } else {
                        self.editButtonText = "Edit"
                    }
                }) {
                    Text(self.editButtonText)
                }
            }
            .padding()

            Form {
                Section(header: Text("Contact Name")) {
                    TextField("First Name", text: $newFirstName)
                    TextField("Last Name", text: $newLastName)
                }

                Section(header: Text("Phone Number")) {
                    TextField("Area Code", text: $newAreaCode.enteredTextValue)
                        .keyboardType(.decimalPad)

                    TextField("Phone Nbr", text: $newPhone.enteredTextValue)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Address")) {
                    TextField("Street", text: $newStreet)
                    TextField("City", text: $newCity)
                    TextField("State", text: $newState)
                    TextField("Zip Coce", text: $newZipCode.enteredTextValue)
                        .keyboardType(.decimalPad)
                }
            }
            .background(Color.blue)
            .disabled(!editing)
            .onAppear {
                self.loadContactEntity()
            }
        }
        .navigationBarTitle(Text("Contact List"), displayMode: .inline)
        .padding()
        .padding(.bottom, keyboardResponder.currentHeight)
        .animation(.easeOut(duration: 0.16))
    }

    func cancelEdit() {
        UIApplication.shared.endEditing()
        loadContactEntity()
        editing.toggle()
        editButtonText = "Edit"
    }

    /*
     Load or re-load the original Contact entity
     */
    func loadContactEntity() {
        newFirstName = contact.wrappedFirstName
        newLastName = contact.wrappedLastName
        newAreaCode.enteredTextValue = contact.wrappedAreaCode
        newPhone.enteredTextValue = contact.wrappedPhone

        let address: Address = contact.address ?? Address(context: moc)
        newStreet = address.wrappedStreet
        newCity = address.wrappedCity
        newState = address.wrappedState
        newZipCode.enteredTextValue = address.wrappedZipCode
    }

    /*
     Update the modified Contact entity
     */
    func updateContact() {
        UIApplication.shared.endEditing()
        contact.firstName = newFirstName
        contact.lastName = newLastName
        contact.areaCode = newAreaCode.enteredTextValue
        contact.phone = newPhone.enteredTextValue

        let address: Address = contact.address ?? Address(context: moc)

        address.street = newStreet
        address.city = newCity
        address.state = newState
        address.zipCode = newZipCode.enteredTextValue

        contact.address = address

        if moc.hasChanges {
            moc.performAndWait {
                try? self.moc.save()
            }
        }
    }
}
