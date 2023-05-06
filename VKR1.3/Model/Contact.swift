import Contacts

struct Contact {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var note: String
    var extraNumber: String?
    
    init(firstName: String = "", lastName: String = "", phoneNumber: String = "", note: String = "", extraNumber: String? = nil) {
        self.firstName = firstName.firstUppercased
        self.lastName = lastName.firstUppercased
        self.phoneNumber = phoneNumber
        self.note = note
        self.extraNumber = extraNumber
    }
    
    func save() throws {
        let newContact = CNMutableContact()
        newContact.givenName = firstName
        newContact.familyName = lastName
        
        //добавляем недостающие имена и фамилии в словарь
        addNameToFile(name: firstName)
        addSurToFile(surname: lastName)
        
//        readNamesFromFile()
//        readSurFromFile()
        
        newContact.note = note
        
        if let extraNumber = extraNumber {
            if isMobileNumber(num: phoneNumber) {
                newContact.phoneNumbers = [CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: extraNumber)), CNLabeledValue(
                    label: CNLabelPhoneNumberMobile,
                    value: CNPhoneNumber(stringValue: phoneNumber)
                )]
            } else {
                newContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: extraNumber)), CNLabeledValue(
                    label: CNLabelWork,
                    value: CNPhoneNumber(stringValue: phoneNumber)
                )]
            }
        } else {
            newContact.phoneNumbers = [CNLabeledValue(
                label: CNLabelPhoneNumberMain,
                value: CNPhoneNumber(stringValue: phoneNumber)
            )]
        }
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(newContact, toContainerWithIdentifier: nil)
        try store.execute(saveRequest)
    }
    
    
    func addNameToFile(name: String) {
        let fileName = "malenam.txt"
        
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access documents directory")
        }
        
        let fileURL = documentsDirectoryURL.appendingPathComponent(fileName)
        
        do {
            // Read the contents of the file
            var fileContent = try String(contentsOf: fileURL)
            
            
            if !fileContent.contains(name) {
                // Add the new name to the file content
                fileContent.append("\n\(name)")
            }
            // Write the updated file content back to the file
            try fileContent.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
            print("Error writing to file: \(error)")
        }
    }
    
    func addSurToFile(surname: String) {
        let fileName = "malesur.txt"
        
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access documents directory")
        }
        
        let fileURL = documentsDirectoryURL.appendingPathComponent(fileName)
        
        do {
            // Read the contents of the file
            var fileContent = try String(contentsOf: fileURL)
            
            if !fileContent.contains(surname) {
                // Add the new name to the file content
                fileContent.append("\n\(surname)")
            }
            
            
            // Write the updated file content back to the file
            try fileContent.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
            print("Error writing to file: \(error)")
        }
    }
    
    func copyToDocuments () {
        guard let sourceURL = Bundle.main.url(forResource: "malenam", withExtension: "txt"),
              let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access file or documents directory")
        }

        let destinationURL = documentsDirectoryURL.appendingPathComponent("malenam.txt")

        do {
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
        } catch {
            print("Error copying file: \(error)")
        }

    }
    
    func copySurToDocuments () {
        guard let sourceURL = Bundle.main.url(forResource: "malesur", withExtension: "txt"),
              let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access file or documents directory")
        }
        
        let destinationURL = documentsDirectoryURL.appendingPathComponent("malesur.txt")
        
        do {
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
        } catch {
            print("Error copying file: \(error)")
        }
        
    }
    
    
    func readNamesFromFile() -> [String] {
        let fileName = "malenam.txt"

        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access documents directory")
        }

        let fileURL = documentsDirectoryURL.appendingPathComponent(fileName)

        do {
            // Read the contents of the file
            let fileContent = try String(contentsOf: fileURL)

            // Split the file content into an array of strings
            let names = fileContent.components(separatedBy: .newlines).filter { !$0.isEmpty }

            print(names)
            return names
        } catch {
            print("Error reading file: \(error)")
            return []
        }

    }
    
    func readSurFromFile() -> [String] {
        let fileName = "malesur.txt"
        
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access documents directory")
        }
        
        let fileURL = documentsDirectoryURL.appendingPathComponent(fileName)
        
        do {
            // Read the contents of the file
            let fileContent = try String(contentsOf: fileURL)
            
            // Split the file content into an array of strings
            let sur = fileContent.components(separatedBy: .newlines).filter { !$0.isEmpty }
            
            print(sur)
            return sur
        } catch {
            print("Error reading file: \(error)")
            return []
        }
        
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
