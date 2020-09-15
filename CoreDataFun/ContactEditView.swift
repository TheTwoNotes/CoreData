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
    @State var newAreaCode: String = ""
    @State var newPhone: String = ""

    @State var newStreet: String = ""
    @State var newCity: String = ""
    @State var newState: String = ""
    @State var newZipCode: String = ""

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
                    TextField("Area Code", text: $newAreaCode)
                    TextField("Phone Nbr", text: $newPhone)
                }

                Section(header: Text("Address")) {
                    TextField("Street", text: $newStreet)
                    TextField("City", text: $newCity)
                    TextField("State", text: $newState)
                    TextField("Zip Coce", text: $newZipCode)
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
        newAreaCode = contact.wrappedAreaCode
        newPhone = contact.wrappedPhone

        let address: Address = contact.address ?? Address(context: moc)
        newStreet = address.wrappedStreet
        newCity = address.wrappedCity
        newState = address.wrappedState
        newZipCode = address.wrappedZipCode
    }

    /*
     Update the modified Contact entity
     */
    func updateContact() {
        UIApplication.shared.endEditing()
        contact.firstName = newFirstName
        contact.lastName = newLastName
        contact.areaCode = newAreaCode
        contact.phone = newPhone

        let address: Address = contact.address ?? Address(context: moc)

        address.street = newStreet
        address.city = newCity
        address.state = newState
        address.zipCode = newZipCode

        contact.address = address

        if moc.hasChanges {
            moc.performAndWait {
                try? self.moc.save()
            }
        }
    }
}

// struct ContactEditView_Previews: PreviewProvider {
//    static var previews: some View {
//		ContactEditView(contact: <#Contact#>)
//    }
// }
