import UIKit

class CustomSearchBar: UISearchBar {
	
	private enum SubviewKey: String {
		case searchfield
		case clearButton
		case cancelButton
		case placeholderLabel
	}
	
	public var additionalDelegate: CustomSearchBarAdditionalDelegate?
	
	public var cancelButton: UIButton? {
		
		guard showsCancelButton else { return nil }
		
		let button = self.value(forKey: SubviewKey.cancelButton.rawValue) as? UIButton
		button?.addTarget(self, action: #selector(handleCancelButton), for: .touchDown)
		
		return button
	}

	override public func layoutSubviews() {
		super.layoutSubviews()
		
		self.cancelButton?.setTitleColor(.lightGray, for: .normal)
	}
	
	@objc func handleCancelButton() {
		self.additionalDelegate?.cancelButtonDidHighlited()
	}
}

extension CustomSearchBar {
	
	func setupAppearance() {
		
		let leadingMargin: CGFloat = 18
		let topMargin: CGFloat = 8
		let height: CGFloat = 60 - (topMargin * 2)
		
		backgroundColor = .darkGray
		backgroundImage = UIImage()
		showsCancelButton = false
		setSearchFieldBackgroundImage(UIImage.image(color: .lightGray, size: CGSize(width: 1, height: height)), for: .normal)
		searchTextField.textColor = .white
		searchTextField.setCorner(9)
		searchTextField.returnKeyType = .search
		searchTextField.autocorrectionType = .no
		searchTextField.spellCheckingType = .no
		searchTextField.autocapitalizationType = .none
		tintColor = .white
		
		let margins = NSDirectionalEdgeInsets(top: 0, leading: leadingMargin, bottom: 0, trailing: leadingMargin)
		directionalLayoutMargins = margins
	}
}
