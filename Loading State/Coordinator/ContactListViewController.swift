import UIKit
import RealmSwift
import Realm

class ContactsListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	lazy var searchBar = CustomSearchBar()
	
	private var contactsResult: Results<Object>
	private var contactViewModel: ContactsListViewModel!
	private var contactDataSource: ContactListDataSource!
	
	var notificationToken: NotificationToken?
	
	init(_ results: Results<Object>) {
		self.contactsResult = results
		super.init(nibName: Constants.identifier.xib.contactsListController, bundle: nil)
	}
   
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.setupTableview()
		self.setupDataSource()
		self.setupSearchController()
		self.setupHeaderFooterView()
		self.setupUI()
		self.setupAppearance()
	}
		
	private func setupDataSource() {
		
		self.notificationToken = contactsResult.observe( { [weak self] (changes: RealmCollectionChange) in
			guard let self = self else { return }
			switch changes {
				case .initial(let initialContacts):
					let contacts = initialContacts.convertable(Contact.self)
					self.setupViewModel(contacts)
					self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
				case .update(let results, deletions: let deletions, insertions: let insertions, modifications: let modifications):
					let contacts = results.convertable(Contact.self)
					let updatedPaths = self.contactViewModel.updatesIndexPaths(from: modifications.map({contacts[$0]}))
					let deletedPaths = self.contactViewModel.updatesIndexPaths(from: deletions.map({contacts[$0]}))
					
					if !insertions.isEmpty {
						self.setupViewModel(contacts)
					}
					
					self.tableView.beginUpdates()
					self.tableView.reloadRows(at: updatedPaths, with: .automatic)
					self.tableView.deleteRows(at: deletedPaths, with: .automatic)
					self.tableView.endUpdates()
				case .error(let error):
					debugPrint(error.localizedDescription)
			}
		
			self.tableView.applyChanges(changes: changes)
		})
	}
	
	private func setupViewModel(_ contacts: [Contact]) {
		
		let contacts = contacts.map({ ContactModel(contact: $0)})
		self.contactViewModel = ContactsListViewModel(contactsModel: contacts)
		self.contactDataSource = ContactListDataSource(contactListViewModel: self.contactViewModel)
		
		self.tableView.delegate = self.contactDataSource
		self.tableView.dataSource = self.contactDataSource
		
		self.contactViewModel.searchEnabled.bindAndFire { (_) in
			_ = self.contactViewModel.contactsModel
			self.tableView.reloadData()
		}
		
		self.contactDataSource.didSelectDialContact = { contact in
//            #warning("TODO") /// handle select phone numbers from action sheet
			if let number = contact.phoneNumbers.first {
				CallServiceCoordinator.shared.dial(contact, with: number.number)
			}
		}
		
		self.contactDataSource.didSelectViewContactsRecords = { contact in
			
			guard !contact.callResults.isEmpty else { return }
			
			self.showRecords(of: contact)
		}
	}
}

extension ContactsListViewController: ContactDataSourceDelegate {
	
	func dial(phoneNumber: ContactPhoneNumber, with contact: Contact) {
		CallServiceCoordinator.shared.dial(contact, with: phoneNumber.number)
	}
	
	func doNothingAction() {}
}

extension ContactsListViewController {
	
	private func showRecords(of contact: Contact) {

		let storyboard = UIStoryboard(name: Constants.identifier.storyboard.records, bundle: nil)
		let viewController = storyboard.instantiateViewController(withIdentifier: Constants.identifier.viewController.contactRecords) as! ContactRecordsViewController
		viewController.contact = contact
		viewController.hidesBottomBarWhenPushed = true
		self.navigationController?.pushViewController(viewController, animated: true)
	}
}

extension ContactsListViewController: AppearanceUpdatable {
	
	func setupUI() {
		
		let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
		self.view.addGestureRecognizer(gesture)
	}
	
	@objc func didTap(_ gesture: UITapGestureRecognizer) {
		
		searchBar.resignFirstResponder()
		let point = gesture.location(in: self.tableView)
		
		guard let indexPath = tableView.indexPathForRow(at: point) else { return }
		self.tableView.delegate?.tableView?(self.tableView, didSelectRowAt: indexPath)
	 }
	
	func setupHeaderFooterView() {
		
		let headerHeight: CGFloat = 68
		let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Utilites.screenWidth, height: headerHeight))
		headerView.backgroundColor = .clear
		searchBar.frame = CGRect(x: 0, y: 0, width: Utilites.screenWidth, height: 60)
		headerView.addSubview(searchBar)
		tableView.contentOffset = CGPoint(x: 0, y: headerHeight)
		tableView.tableHeaderView = headerView
	}
	
	private func setupTableview() {
		
		self.tableView.register(UINib(nibName: Constants.identifier.xib.contactCell, bundle: nil), forCellReuseIdentifier: Constants.identifier.cell.contact)
		self.tableView.separatorStyle = .none
		self.tableView.keyboardDismissMode = .onDrag
	}
	
	private func setupSearchController() {
		
		searchBar.delegate = self
		searchBar.setupAppearance()
	}
	
	func setupAppearance() {
		self.view.backgroundColor = .clear
	}
}

extension ContactsListViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		self.contactViewModel.searchContact.value = searchText
		self.contactViewModel.updateSearchState()
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.text = nil
		self.contactViewModel.searchContact.value = emptyString
		self.contactViewModel.updateSearchState()
		searchBar.setShowsCancelButton(false, animated: true)
		searchBar.resignFirstResponder()
		self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
		self.keyboardDidHide()
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {}
	
	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
		searchBar.setShowsCancelButton(true, animated: true)
		return true
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}
