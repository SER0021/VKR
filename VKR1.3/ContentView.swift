//
//  ContentView.swift
//  vkr1.1
//
//  Created by MacBook Air on 25.11.2022.
//


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
                    
                    let text = texts.first?.content ?? "Scan error"
                    
                    Text(text)
                    
                    Spacer()
                    Group{
                        
                        
                        Button(action: {
                            self.showContactEditor = true
                        }) {
                            Text("Добавить в контакты")
                        }
                        
                        .font(.largeTitle)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .sheet(isPresented: self.$showContactEditor) {
                            
                            let nameAndSurnames = namesFromText(s: text)
                            let name = nameAndSurnames.0
                            let surname = nameAndSurnames.1
                            let numbers = numbersFromText(s: text)
                            let number1 = numbers.0
                            let number2 = numbers.1
                            
                            
                            ContactEditorView(firstName: name, lastName: surname, phoneNumber: number1, note: text, extraNumber: number2)
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
                Text("Сканировать")
                Image(systemName: "doc.text.viewfinder")
                    .font(.title)
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
