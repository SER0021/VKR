import SwiftUI
import ContactsUI
import Contacts

struct ContactEditorView: View {
    
    @State var firstName: String
    @State var lastName: String
    @State var phoneNumber: String
    
    @Environment(\.presentationMode) var presentationMode
    
    init(firstName: String = "", lastName: String = "", phoneNumber: String = "") {
            self._firstName = State(initialValue: firstName)
            self._lastName = State(initialValue: lastName)
            self._phoneNumber = State(initialValue: phoneNumber)
        }
    static let contactSavedNotification = Notification.Name("contactSaved")

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Имя")) {
                    TextField("Имя", text: $firstName)
                }
                
                Section(header: Text("Фамилия")) {
                    TextField("Фамилия", text: $lastName)
                }
                
                Section(header: Text("Номер телефона")) {
                    TextField("Номер телефона", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
            }
            .navigationBarTitle("Редактировать контакт")
            .navigationBarItems(
                leading: Button(action: cancel) { Text("Отмена") },
                trailing: Button(action: save) { Text("Сохранить") }
            )
        }
    }
    
    private func cancel() {
        // Отмена редактирования контакта
        presentationMode.wrappedValue.dismiss()
    }
    
    private func save() {
        let newContact = CNMutableContact()
        newContact.givenName = firstName
        newContact.familyName = lastName
        newContact.phoneNumbers = [CNLabeledValue(
            label: CNLabelPhoneNumberMain,
            value: CNPhoneNumber(stringValue: phoneNumber)
        )]
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(newContact, toContainerWithIdentifier: nil)
        try? store.execute(saveRequest)
        
        // Отправить уведомление о сохранении контакта
        presentationMode.wrappedValue.dismiss()
    }

}




struct Previews_ContactEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ContactEditorView()
    }
}
