import UIKit

class DataLoadingViewController: UIViewController, LoadingHandler {
	
	var datatype: DataLoadingType
	
	init(datatype: DataLoadingType) {
		self.datatype = datatype
		
		super.init(nibName: Constants.identifier.xib.dataLoader, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		 fatalError("init(coder:) has not been implemented")
	 }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupUI()
		self.setupAppearance()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.showLoading()
	}
}

extension DataLoadingViewController {
	
	func setupUI() {
	
	}
	
	func setupAppearance() {
		
		self.view.backgroundColor = .gray
	}
}
