//
//  ContactAddView.swift
//  CoreDataFun
//
//  Created by Gil Estes on 9/15/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import SwiftUI

struct ContactAddView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject private var keyboardResponder = KeyboardResponder()

    @State var newFirstName: String = ""
    @State var newLastName: String = ""

    @ObservedObject var newAreaCode = NumericFieldViewModel(limit: 3, decimalAllowed: false, numberMax: 999)
    @ObservedObject var newPhone = NumericFieldViewModel(limit: 7, decimalAllowed: false, numberMax: 9_999_999)

    @State var newStreet: String = ""
    @State var newCity: String = ""
    @State var newState: String = ""
    @State var newZipCode: String = ""

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.insertNewContactCard()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Create Contact")
                }.disabled(!validToCreate())

                Spacer()

                Button(action: {
                    UIApplication.shared.endEditing()
                }) {
                    Text("Close Keyboard")
                        .font(.headline)
                }
            }

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
                    TextField("Zip Code", text: $newZipCode)
                        .keyboardType(.decimalPad)
                }
            }
        }
        .navigationBarTitle(Text("Contact List"), displayMode: .inline)
        .padding()
        .padding(.bottom, keyboardResponder.currentHeight)
        .animation(.easeOut(duration: 0.16))
    }

    /*
     Minor validation to ensure every field has some content. There is no actual
     content validation is being done as this is only an example of using CoreData
     within a SwiftUI application.
     */
    func validToCreate() -> Bool {
        return newAreaCode.count > 0 && newPhone.count > 0 && newFirstName.count > 0 && newLastName.count > 0
    }

    /*
     Create a new Contact entity from the input provided. No data validation is
     being done as this is only an example of using CoreData withing a SwiftUI app.
     */
    func insertNewContactCard() {
        let contact = Contact(context: moc)
        contact.firstName = newFirstName
        contact.lastName = newLastName
        contact.areaCode = newAreaCode.enteredTextValue
        contact.phone = newPhone.enteredTextValue

        let address = Address(context: moc)
        address.street = newStreet
        address.city = newCity
        address.state = newState
        address.zipCode = newZipCode

        contact.address = address

        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                // handle the Core Data error...
            }
        }
    }
}

struct ContactAddView_Previews: PreviewProvider {
    static var previews: some View {
        ContactAddView()
    }
}
