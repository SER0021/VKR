import SwiftUI
import ContactsUI
import Contacts

struct ContactEditorView: View {
    
    @State var firstName: String
    @State var lastName: String
    @State var phoneNumber: String
    @State var note: String
    @State var extraNumber: String?
    @State var showsAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    init(firstName: String = "", lastName: String = "", phoneNumber: String = "", note: String = "", extraNumber: String? = "") {
        self._firstName = State(initialValue: firstName.firstUppercased)
        self._lastName = State(initialValue: lastName.firstUppercased)
        self._phoneNumber = State(initialValue: phoneNumber)
        self._note = State(initialValue: note)
        self._extraNumber = State(initialValue: extraNumber)
        
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
                
                Section(header: Text("Дополнительный номер телефона")) {
                    TextField("Дополнительный номер телефона", text: Binding(
                        get: { extraNumber ?? "" },
                        set: { extraNumber = $0.isEmpty ? nil : $0 }
                    ))
                    .keyboardType(.phonePad)
                }
                
                
                
            }
            .navigationBarTitle("Редактировать")
            .navigationBarItems(
                leading: Button(action: cancel) { Text("Отмена") },
                trailing: Button("Сохранить") {
                    save()
                    showsAlert = true
                }
                    .alert(isPresented: $showsAlert) {
                        Alert(
                            title: Text("Контакт успешно сохранен"),
                            dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
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
        newContact.note = note
        
        if let extraNumber = extraNumber {
            if isMobileNumber(num: phoneNumber) {
                newContact.phoneNumbers = [CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: extraNumber)), CNLabeledValue(
                    label: CNLabelPhoneNumberMobile,
                    value: CNPhoneNumber(stringValue: phoneNumber)
                )]
            }else {
                newContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: extraNumber)), CNLabeledValue(
                    label: CNLabelWork,
                    value: CNPhoneNumber(stringValue: phoneNumber)
                )]
            }
            
        }else {
            newContact.phoneNumbers = [CNLabeledValue(
                label: CNLabelPhoneNumberMain,
                value: CNPhoneNumber(stringValue: phoneNumber)
            )]
        }
        
        
        
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(newContact, toContainerWithIdentifier: nil)
        try? store.execute(saveRequest)
        
        
        
        
        //        presentationMode.wrappedValue.dismiss()
        
    }
    
}

extension StringProtocol {
    var firstUppercased: String {
        guard let firstChar = self.first else {
            return ""
        }
        return firstChar.uppercased() + self.dropFirst().lowercased()
        
    }
}



struct Previews_ContactEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ContactEditorView()
    }
}
