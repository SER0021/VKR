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
    @State private var showScannerSheet = false
    @State private var texts:[ScanData] = []
    
    @State private var addContactTapped = false
    
    @State var showContactEditor = false
    
    var body: some View {
        NavigationView{
            VStack{
                if texts.count > 0{
                    
                    let text = texts.first?.content ?? "Scan error"
                    
                    Text(text)
                    
                    Button(action: {
                        self.showContactEditor = true
                    }) {
                        Text("Add")
                    }
                    .sheet(isPresented: self.$showContactEditor) {
                        
                        //var text = texts.first?.content ?? "Scan error"
                        let nameAndSurnames = namesFromText(s: text)
                        let name = nameAndSurnames.0
                        let surname = nameAndSurnames.1
                        
                        ContactEditorView(firstName: name, lastName: surname, phoneNumber: "111111")
//                        ContactEditorView(firstName: "who", lastName: "aboba", phoneNumber: "111111")
                    }
                    
                    
                    
//                    Text(texts.first?.content ?? "Scan error")
                    
                    Spacer()
   
                }
                else{
                    //                                        NavigationLink(destination: ContactEditorView(firstName: "who", lastName: "aboba", phoneNumber: "111111")) {
                    //                                            Text("Add")
                    //                                        }
                                    
                    Button(action: {
                        self.showContactEditor = true
                    }) {
                        Text("Add")
                    }
                    .sheet(isPresented: self.$showContactEditor) {
                        
                        var text = texts.first?.content ?? "Scan error"
                        var nameAndSurnames = namesFromText(s: text)
                        var name = nameAndSurnames.0
                        var surname = nameAndSurnames.1
                        
                        ContactEditorView(firstName: name, lastName: surname, phoneNumber: "111111")
//                        ContactEditorView(firstName: "who", lastName: "aboba", phoneNumber: "111111")
                    }
                    
                    
                    Text("No scan yet").font(.title)
                }
            }
            .navigationTitle("Scan OCR")
            .navigationBarItems(trailing: Button(action: {
                texts.removeAll()
                self.showScannerSheet = true
            }, label: {
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
