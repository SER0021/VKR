

import SwiftUI
import ContactsUI
import Contacts

struct TestView: View {
    
    @State private var showScannerSheet = true
    @State private var texts:[ScanData] = []
    
    @State var firstName: String
    @State var lastName: String
    @State var phoneNumber: String
    @State var note: String
    @State var extraNumber: String?
    @State var showsAlert = false
    

    
    @Environment(\.presentationMode) var presentationMode
    
    init(firstName: String = "", lastName: String = "", phoneNumber: String = "", note: String = "", extraNumber: String? = "") {
            self._firstName = State(initialValue: firstName)
            self._lastName = State(initialValue: lastName)
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
            .navigationBarTitle("Редактировать контакт")
            .navigationBarItems(
                leading: Button(action: cancel) { Text("Отмена") },
                trailing: Button("Сохранить") {
                    save()
                    showsAlert = true
                }
                    .alert(isPresented: $showsAlert) {
                        Alert(
                            title: Text("Контакт сохранен"),
                            dismissButton: .default(Text("OK")) {
                                                       presentationMode.wrappedValue.dismiss()
                                                   }
                        )
                    }
            )
        }.sheet(isPresented: $showScannerSheet, content: {
            self.makeScannerView()
        })
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
        
        
    }
    private func makeScannerView()-> ScannerView {
        ScannerView(completion: {
            textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines){
                let newScanData = ScanData(content: outputText)
                self.texts.append(newScanData)
            }
            self.showScannerSheet = false
        })
    }

}


