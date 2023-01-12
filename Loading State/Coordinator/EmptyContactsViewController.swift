import UIKit

class EmptyContactsViewController: UIViewController {
	
	init() {
		super .init(nibName: Constants.identifier.xib.emptyContactsviewController, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
}

