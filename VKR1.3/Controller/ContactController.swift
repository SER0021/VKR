
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

