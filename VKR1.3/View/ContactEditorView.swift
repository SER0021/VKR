import SwiftUI
import ContactsUI
import Contacts

struct ContactEditorView: View {
    
    @ObservedObject var controller: ContactController
    
    @State private var showsAlert = false
    
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Имя")) {
                    TextField("Имя", text: $controller.contact.firstName)
                }
                
                Section(header: Text("Фамилия")) {
                    TextField("Фамилия", text: $controller.contact.lastName)
                }
                
                Section(header: Text("Номер телефона")) {
                    TextField("Номер телефона", text: $controller.contact.phoneNumber)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Дополнительный номер телефона")) {
                    TextField("Дополнительный номер телефона", text: Binding(
                        get: { controller.contact.extraNumber ?? "" },
                        set: { controller.contact.extraNumber = $0.isEmpty ? nil : $0 }
                    ))
                    .keyboardType(.phonePad)
                }
                
                Section(header: Text("Заметки")) {
                    TextField("Заметки", text: $controller.contact.note, axis: .vertical)
                }
                
                
                
            }
            .navigationBarTitle("Редактировать")
            .navigationBarItems(
                leading: Button(action: cancel) { Text("Отмена") },
                trailing: Button("Сохранить") {
                    // TODO: нужно ли здесь try?
                   try? controller.saveContact()
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

}




struct Previews_ContactEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ContactEditorView(controller: ContactController(contact: Contact(firstName: "name", lastName: "surname", phoneNumber: "123", note: "texttexttexttexttexttexttexttexttexttdfdfdcdcdccdcdc \n \n ttexttext", extraNumber: "321")))
    }
}
