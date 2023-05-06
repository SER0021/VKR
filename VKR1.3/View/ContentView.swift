
import SwiftUI
import Contacts
import ContactsUI

struct ContentView: View {
    @State private var showScannerSheet = true
    @State private var texts:[ScanData] = []
    
    @State private var addContactTapped = false
    
    @State var showContactEditor = false
    
    var body: some View {
        NavigationView{
            VStack{
                if texts.count > 0{
//                if texts.count > -1{
                    
                    let text = texts.first?.content ?? "Scan error"
//                    let text = "Иван \n 89164266762"
                    
                    
                    Spacer()
                    
                    Text(text)
                        .font(.title2)
//                        .fixedSize(horizontal: false, vertical: false)
                        .multilineTextAlignment(.center)
                        .padding()
//                        .frame(width: 400, height: 300)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.teal))
                        
                        
                    
                    Spacer()
                    Group{
                        
                        
                        Button(action: {
                            self.showContactEditor = true
                        }) {
                            Text("Добавить в контакты")
                                .foregroundColor(.black)
                                .frame(width: 350, height: 70)
                                .multilineTextAlignment(.center)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.teal).shadow(radius: 3))
                        }
                        
                        .font(.largeTitle)
                        .sheet(isPresented: self.$showContactEditor) {
                            
                            let nameAndSurnames = namesFromText(s: text)
                            let name = nameAndSurnames.0
                            let surname = nameAndSurnames.1
                            let numbers = numbersFromText(s: text)
                            let number1 = numbers.0
                            let number2 = numbers.1
                            

                            ContactEditorView(controller: ContactController(contact: Contact(firstName: name, lastName: surname, phoneNumber: number1, note: text, extraNumber: number2)))


                        }
                        
                    }.frame(maxHeight: .infinity, alignment: .bottom)
                    
                    Spacer()
                    
                }
                else{
                    Text("Здесь будет ваш контакт").font(.title).opacity(0.5)
                }
            }
            
            .navigationTitle("Результат")
            .navigationBarItems(trailing: Button(action: {
                texts.removeAll()
                self.showScannerSheet = true
            }, label: {
                    Group{
                        HStack{
                            Text("Сканировать")
                            Image(systemName: "doc.text.viewfinder")
                                .font(.title)
                        }
                    }
                        .foregroundColor(.black)
                        .frame(width: 180, height: 50)
                        .multilineTextAlignment(.center)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.teal).shadow(radius: 3))
                
            })
                .sheet(isPresented: $showScannerSheet, content: {
                    self.makeScannerView()
                })
            )
        }
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






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
