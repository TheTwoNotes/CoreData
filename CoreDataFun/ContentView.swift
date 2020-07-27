//
//  ContentView.swift
//  CoreDataFun
//
//  Created by Gil Estes on 7/23/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import SwiftUI

/*
    struct to handle view and edit detail of a Contact entity
 */
struct ContactEditView: View {
    @ObservedObject var contact: Contact;
    
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
    }
        
    func cancelEdit() {
        loadContactEntity()
        self.editing.toggle()
        self.editButtonText = "Edit"
    }

    /*
        Load or re-load the original Contact entity
     */
    func loadContactEntity() {
        self.newFirstName = self.contact.wrappedFirstName
        self.newLastName = self.contact.wrappedLastName
        self.newAreaCode = self.contact.wrappedAreaCode
        self.newPhone = self.contact.wrappedPhone
        
        let address: Address = self.contact.address ?? Address(context: self.moc)
        self.newStreet = address.wrappedStreet
        self.newCity = address.wrappedCity
        self.newState = address.wrappedState
        self.newZipCode = address.wrappedZipCode
    }
    
    /*
        Update the modified Contact entity
     */
    func updateContact() {
        contact.firstName = self.newFirstName
        contact.lastName = self.newLastName
        contact.areaCode = self.newAreaCode
        contact.phone = self.newPhone
        
        let address: Address = contact.address ?? Address(context: moc)
        
        address.street = self.newStreet
        address.city = self.newCity
        address.state = self.newState
        address.zipCode = self.newZipCode

        contact.address = address
        
        if self.moc.hasChanges {
            moc.performAndWait {
                try? self.moc.save()
            }
        }
    }
}

/*
    struct to handle adding a new Contact entity
 */
struct ContactAddView: View {
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
                Spacer()

                Button(action: {
                    self.insertNewContactCard()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Create Contact")
                }.disabled(!validToCreate())
            }.padding()

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
        }
        .navigationBarTitle(Text("Contact List"), displayMode: .inline)
    }
    
    /*
        Minor validation to ensure every field has some content. There is no actual
        content validation is being done as this is only an example of using CoreData
        within a SwiftUI application.
     */
    func validToCreate() -> Bool {
        return self.newAreaCode.count > 0 && newPhone.count > 0 && newFirstName.count > 0 && newLastName.count > 0
    }
    
    /*
        Create a new Contact entity from the input provided. No data validation is
        being done as this is only an example of using CoreData withing a SwiftUI app.
     */
    func insertNewContactCard() {
        let contact = Contact(context: self.moc)
        contact.firstName = self.newFirstName
        contact.lastName = self.newLastName
        contact.areaCode = self.newAreaCode
        contact.phone = self.newPhone

        let address = Address(context: moc)
        address.street = self.newStreet
        address.city = self.newCity
        address.state = self.newState
        address.zipCode = self.newZipCode
        
        contact.address = address
        
        if self.moc.hasChanges {
            do {
                try self.moc.save()
            } catch {
                // handle the Core Data error...
            }
        }
    }
}

/*
    struct to show the currently persisted Contact entities from CoreData.
 */
struct ContactRow: View {
    @ObservedObject var contact: Contact
    
    var body: some View {
        Text(contact.fullBySurname)
        .padding()
        .navigationBarTitle(Text("Contact List"), displayMode: .inline)
    }
}

/*
    struct making up the main view where all the currently persisted Contact
    enties from CoreData are displayed.
 */
struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
        entity: Contact.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Contact.lastName, ascending: true),
            NSSortDescriptor(keyPath: \Contact.firstName, ascending: true),
        ]
    ) var contacts: FetchedResults<Contact>
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ContactAddView()) {
                    HStack {
                        Text("Add Contact")
                        Image(systemName: "plus")
                    }
                }
                
                ForEach(contacts, id: \.self) { contact in
                    NavigationLink(destination: ContactEditView(contact: contact)) {
                        ContactRow(contact: contact)
                    }
                }.onDelete(perform: removeContact)
            }
            .navigationBarItems(trailing: EditButton().padding(0))
        }
    }
    
    /*
        Handle removal of a Contact entity from CoreData
     */
    func removeContact(at offsets: IndexSet) {
        for index in offsets {
            let contact = contacts[index]
            managedObjectContext.delete(contact)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
