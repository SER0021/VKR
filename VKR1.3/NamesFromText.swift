import Foundation


func namesFromText (s: String) -> (String, String) {
    
    var nameAndSurname : (String, String)
    
    guard let surFileURL = Bundle.main.url(forResource: "malesur", withExtension: "txt")  else {
        fatalError("No fileURL")
    }

    guard let nameFileURL = Bundle.main.url(forResource: "malenam", withExtension: "txt")  else {
        fatalError("No fileURL")
    }

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


