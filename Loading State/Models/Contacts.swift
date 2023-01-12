import RealmSwift

class Contact: Object {
	
	@Persisted(primaryKey: true) var identifier: String
	
	@Persisted var displayedFullName: String
	@Persisted var givenName: String
	@Persisted var middleName: String
	@Persisted var familyName: String
	@Persisted var nameSuffix: String
	@Persisted var nickname: String
	@Persisted var phoneNumbers = List<ContactPhoneNumber>()
	@Persisted var emailAddresses = List<ContactEmail>()
	@Persisted var urlAddresses = List<ContactURL>()

	@Persisted var imageDataAvailible: Bool
	
	convenience init(identifier: String,
					 displayedFullName: String,
					 givenName: String,
					 middleName: String,
					 familyName: String,
					 nameSuffix: String,
					 nickname: String,
					 phoneNumbers: [ContactPhoneNumber],
					 emailAddresses: [ContactEmail],
					 urlAddresses: [ContactURL]) {
		
		self.init()
		
		self.identifier = identifier.replacingOccurrences(of: Constants.serviceValues.contacts.contactReplaceIdentifier, with: emptyString)
		self.displayedFullName = displayedFullName
		self.givenName = givenName
		self.middleName = middleName
		self.familyName = familyName
		self.nameSuffix = nameSuffix
		self.nickname = nickname
		
		let numbers = List<ContactPhoneNumber>()
		numbers.append(objectsIn: phoneNumbers)
		self.phoneNumbers = numbers
		
		let emails = List<ContactEmail>()
		emails.append(objectsIn: emailAddresses)
		
		self.emailAddresses = emails
		
		let urls = List<ContactURL>()
		
		urls.append(objectsIn: urlAddresses)
		
		self.urlAddresses = urls
	
		self.imageDataAvailible = DefaultFileManager().isContactImageExist(self.identifier)
	}
}

class ContactPhoneNumber: EmbeddedObject {
	
	@Persisted var number: String
	
	convenience init(number: String) {
		
		self.init()
		
		self.number = number
	}
}

class ContactEmail: EmbeddedObject {
	
	@Persisted var email: String
	
	convenience init(email: String) {
		
		self.init()
		
		self.email = email
	}
}

class ContactURL: EmbeddedObject {
	
	@Persisted var url: String
	
	convenience init(url: String) {
		
		self.init()
		
		self.url = url
	}
}
