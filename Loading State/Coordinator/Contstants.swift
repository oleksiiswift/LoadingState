import Foundation

struct Constants {
	
	struct identifier {
		
		struct navigation {}
		
		struct storyboard {
			static let main = "Main"
		}
		
		struct viewController {
			
			static let contacts = "ContactsViewController"
			static let contactsLoader = "ContactsLoadingViewController"
			static let contactsList = "ContactsListViewController"
			static let emptyContacts = "EmptyContactsViewController"
		}
		
		struct cell {
			static let contact = "ContactTableViewCell"
		}
		
		struct view {}
		
		struct xib {
			static let dataLoader = "DataLoadingViewController"
			
			static let contactsController = "ContactsViewController"
			static let contactsListController = "ContactsListViewController"
			static let emptyContactsviewController = "EmptyContactsViewController"
			
			static let contactCell = "ContactTableViewCell"
		}
	}
}
