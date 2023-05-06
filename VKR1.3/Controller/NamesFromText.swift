import Foundation


func namesFromText (s: String) -> (String, String) {
    
    var nameAndSurname : (String, String)
    
    copyToDocuments()
    copySurToDocuments()
    
//    guard let surFileURL = Bundle.main.url(forResource: "malesur", withExtension: "txt")  else {
//        fatalError("No fileURL")
//    }

//    guard let nameFileURL = Bundle.main.url(forResource: "malenam", withExtension: "txt")  else {
//        fatalError("No fileURL")
//    }
    
    //словарь для имен
    let nameFileName = "malenam.txt"
    guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        fatalError("Unable to access documents directory")
    }
    let nameFileURL = documentsDirectoryURL.appendingPathComponent(nameFileName)
    
    //словарь для фамилий
    let surFileName = "malesur.txt"
    guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        fatalError("Unable to access documents directory")
    }
    let surFileURL = documentsDirectoryURL.appendingPathComponent(surFileName)
   

    let surnameSet = try! String(contentsOf: surFileURL, encoding: .utf8)
        .components(separatedBy: .newlines)
        .filter { !$0.isEmpty }
        .reduce(into: Set<String>()) { $0.insert($1.lowercased()) }

    let nameSet = try! String(contentsOf: nameFileURL, encoding: .utf8)
        .components(separatedBy: .newlines)
        .filter { !$0.isEmpty }
        .reduce(into: Set<String>()) { $0.insert($1.lowercased()) }



    let words = s.components(separatedBy: .whitespacesAndNewlines)
    
    var resName = ""
    var resSurName = ""

    print(s)

    for word in words {
        let lowercaseWord = word.lowercased()
        
        switch lowercaseWord {
            
    
        case let name where nameSet.contains(name):
            print("Found name: \(word)")
            resName = word
    //        words.removeAll(where: { $0 == word })
            
        case let surname where surnameSet.contains(surname):
            print("Found surname: \(word)")
            resSurName = word
            
        
            
        default:
            break
        }
        
    }
    
   
    
    nameAndSurname = (resName, resSurName)

    return nameAndSurname
    
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


