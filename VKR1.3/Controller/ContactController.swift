//
//  ContactController.swift
//  VKR1.3
//
//  Created by Сергей Васильев on 29.04.2023.
//

import SwiftUI
import ContactsUI

class ContactController: ObservableObject {
    @Published var contact: Contact
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    func saveContact() throws {
        try contact.save()
    }
}

