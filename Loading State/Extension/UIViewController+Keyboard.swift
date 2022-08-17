import UIKit

extension UIViewController {
	
	func forceHideKeyboard() {
		let tapGesture = UITapGestureRecognizer(target: self,
												action: #selector(self.keyboardDidHide))
		view.addGestureRecognizer(tapGesture)
	}

	@objc func keyboardDidHide() {
		view.endEditing(true)
	}
}
