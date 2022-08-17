import UIKit

extension UIViewController {

	func add(asChildViewController viewController: UIViewController) {
		
		addChild(viewController)
		view.insertSubview(viewController.view, at: 0)
		viewController.didMove(toParent: self)
	}
	
	func remove(asChildViewController viewController: UIViewController) {
		
		viewController.willMove(toParent: nil)
		viewController.view.removeFromSuperview()
		viewController.removeFromParent()
	}

	func addChild(viewController: UIViewController) {
		viewController.willMove(toParent: self)
		view.addSubview(viewController.view)
		viewController.view.frame = view.bounds
		viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addChild(viewController)
		viewController.didMove(toParent: self)
	}
	
	func removeChild(viewController: UIViewController) {
		viewController.willMove(toParent: nil)
		viewController.view.removeFromSuperview()
		viewController.removeFromParent()
		viewController.didMove(toParent: nil)
	}
	
	func removeAllChildViewControllers() {
		children.forEach({ removeChild(viewController: $0) })
	}
	
	func removePreviousChildAndAdd(viewController: UIViewController?) {
		
		guard let viewController = viewController else { return }
		
		removeAllChildViewControllers()
		addChild(viewController: viewController)
	}
}
