import UIKit
import Realm
import RealmSwift

class ContactsViewController: UIViewController, StateChanger {
	
	private let stateProvider: StateProvider
	private var currentState: LoadingState?
	
	private var database = DataBaseManager.shared
	
	init(stateProvider: StateProvider) {
		
		self.stateProvider = stateProvider
		super.init(nibName: Constants.identifier.xib.contactsController, bundle: nil)
		
		self.stateProvider.stateChanger = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		setupAppearance()
		
		self.change(to: .loading)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.setupContactsDataSource()
	}
}

extension ContactsViewController {

	func change(to state: LoadingState, results: Results<Object>?) {
		
		guard self.currentState != state else { return }
		
		self.currentState = state
		
		switch state {
			case .content:
				if let results = results {
					removePreviousChildAndAdd(viewController: stateProvider.contentViewController(results))
				} else {
					removePreviousChildAndAdd(viewController: stateProvider.errorViewController())
				}
			case .loading:
				removePreviousChildAndAdd(viewController: stateProvider.dataLoadingViewControoller(.contacts))
			case .empty:
				removePreviousChildAndAdd(viewController: stateProvider.emptyViewController())
			case .error:
				removePreviousChildAndAdd(viewController: stateProvider.errorViewController())
		}
	}
}

extension ContactsViewController {
	
	private func setupContactsDataSource() {
		
		self.database.getCollectionObjects(object: Contact.self) { results in
			
			if !results.isEmpty {
				self.change(to: .content, results: results)
			} else {
				self.change(to: .empty)
			}
		}
	}
}


extension ContactsViewController {
	
	func setupUI() {}
	
	func setupAppearance() {
		
		self.view.backgroundColor = .clear
	}
}


