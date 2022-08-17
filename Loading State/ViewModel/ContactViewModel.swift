import RealmSwift
import UIKit

struct ContactModel {
	let contact: Contact
}

class ContactsListViewModel {
		
	public var contactsModel: [ContactModel]
	public var contactsFiltered: [ContactModel] = []
	
	public var searchContact = Dynamic<String>("")
	public var searchEnabled = Dynamic<Bool>(false)
	
	public var contactsDisplayArray: [ContactModel] {
		return searchEnabled.value ? contactsFiltered : contactsModel
	}
	
	public var data: [String : [ContactModel]] = [:]
	public var sections: [String] = []
	
	private var notificationToken: NotificationToken?
	
	init(contactsModel: [ContactModel]) {
		self.contactsModel = contactsModel
		reloadSectionsData(contactsModel)
	}
}

extension ContactsListViewModel {
	
	public func numberRowsInSection(_ section: Int) -> Int {
		let key = sections[section]
		return data[key]?.count ?? 0
	}
	
	public func titleForHeader(in section: Int) -> String? {
		return sections[section]
	}
	
	public func contact(at indexPath: IndexPath) -> ContactModel? {
		let key = sections[indexPath.section]
		let sorted = self.getSortedData(in: key)
		return sorted?[indexPath.row]
	}
	
	public func getSortedData(in section: String) -> [ContactModel]? {
		let sorted = data[section]?.sorted(by: { (a, b) in
			return a.contact.displayedFullName.localizedCaseInsensitiveCompare(b.contact.displayedFullName) == .orderedAscending
		})
		return sorted
	}
	
	public func getSortedData(_ data: [String : [ContactModel]]) -> [String] {
		
		var sections = Array(data.keys)
		
		sections = sections.sorted { (a, b) -> Bool in
			if a.isEmpty || b == " " {
				return false
			} else if b.isEmpty || b == " " {
				return true
			} else {
				return a.localizedCaseInsensitiveCompare(b) == .orderedAscending
			}
		}
		
		sections.forEach { key in
			if key.containsNumbers() {
				sections.sendToBack(item: key)
			}
		}
		
		sections.forEach { key in
			if key == "+" {
				sections.sendToBack(item: key)
			}
		}
		
		sections.forEach { key in
			if key == "-" {
				sections.sendToBack(item: key)
			}
		}
		
		sections.forEach { key in
			if !key.isEmpty || key != whiteSpace {
				if !key.isAlphabetic, !key.isNumeric {
					sections.sendToBack(item: key)
				}
			}
		}
		
		sections.forEach { key in
			if key.containEmoji {
				sections.sendToBack(item: key)
			}
		}
		
		sections.forEach { key in
			if key.isEmpty || key == whiteSpace {
				sections.sendToBack(item: key)
			}
		}
		
		return sections
	}
	
	private func getKeyFrom(_ contact: Contact) -> String {
		return String(contact.displayedFullName.uppercased().prefix(1))
	}
	
	public func updatesIndexPaths(from contacts: [Contact]) -> [IndexPath] {
	
		var indexPaths: [IndexPath] = []
		
		for contact in contacts {
			let key = self.getKeyFrom(contact)
			
			if let section = sections.firstIndex(of: key), let sectionData = self.data[key], let row = sectionData.firstIndex(where: {$0.contact.identifier == contact.identifier}) {
				indexPaths.append(IndexPath(row: row, section: section))
			}
		}
		return indexPaths
	}

	private func reloadSectionsData(_ model: [ContactModel]) {
		
		self.data =  Dictionary(grouping: model, by: {String($0.contact.displayedFullName.uppercased().prefix(1))})
		let sections = self.getSortedData(data)
		self.sections = sections
	}
	
	public func updateSearchState() {
		
		if searchContact.value.isEmpty {
			reloadSectionsData(contactsModel)
			searchEnabled.value = false
		} else {
			let contactList = contactsModel.filter {
				return $0.contact.displayedFullName.lowercased().contains(searchContact.value.lowercased()) || $0.contact.phoneNumbers.contains(where: {$0.number.contains(searchContact.value.removeNonNumeric())})
			}
			
			self.contactsFiltered = contactList
			reloadSectionsData(self.contactsDisplayArray)
			searchEnabled.value = true
		}
	}
}
