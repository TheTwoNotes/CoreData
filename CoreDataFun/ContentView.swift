//
//  ContentView.swift
//  CoreDataFun
//
//  Created by Gil Estes on 7/23/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import SwiftUI

struct ContactRow: View {
    @ObservedObject var contact: Contact

    var body: some View {
        Text(contact.fullBySurname)
            .padding()
            .navigationBarTitle(Text("Contact List"), displayMode: .inline)
    }
}

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
