import Foundation

extension String {
	
	func removeNonNumeric() -> String {
		return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
	}
}

extension String {
	
	func containsNumbers() -> Bool {
		let numberRegEx  = ".*[0-9]+.*"
		let testCase     = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
		return testCase.evaluate(with: self)
	}
	
	func containsAlphaNumeric() -> Bool {
		let alphaNumericRegEx = ".*[^A-Za-z0-9].*"
		let predicateCase = NSPredicate(format:"SELF MATCHES %@", alphaNumericRegEx)
		return predicateCase.evaluate(with: self)
	}
	
	func contains(find: String) -> Bool{
		return self.range(of: find) != nil
	}
	func containsIgnoringCase(find: String) -> Bool{
		return self.range(of: find, options: .caseInsensitive) != nil
	}
}


extension String {
	
	var containEmoji: Bool {
		for scalar in unicodeScalars {
			switch scalar.value {
			case 0x1F600...0x1F64F, // Emoticons
				 0x1F300...0x1F5FF, // Misc Symbols and Pictographs
				 0x1F680...0x1F6FF, // Transport and Map
				 0x1F1E6...0x1F1FF, // Regional country flags
				 0x2600...0x26FF, // Misc symbols
				 0x2700...0x27BF, // Dingbats
				 0xE0020...0xE007F, // Tags
				 0xFE00...0xFE0F, // Variation Selectors
				 0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
				 127_000...127_600, // Various asian characters
				 65024...65039, // Variation selector
				 9100...9300, // Misc items
				 8400...8447: // Combining Diacritical Marks for Symbols
				return true
			default:
				continue
			}
		}
		return false
	}
	
	var isAlphabetic: Bool {
		let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
		let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
		return hasLetters && !hasNumbers
	}
}
