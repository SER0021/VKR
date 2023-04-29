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
}

extension StringProtocol {
    var firstUppercased: String {
        guard let firstChar = self.first else {
            return ""
        }
        return firstChar.uppercased() + self.dropFirst().lowercased()
    }
}
