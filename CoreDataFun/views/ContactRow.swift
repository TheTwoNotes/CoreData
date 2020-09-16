//
//  ContactRow.swift
//  CoreDataFun
//
//  Created by Gil Estes on 9/16/20.
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

struct ContactRow_Previews: PreviewProvider {
    @State static var contact = Contact()
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
