import UIKit

private let indicatorTag = 3394993

protocol LoadingHandler where Self: UIViewController {
	func showLoading()
	func hideLoading()
}

extension LoadingHandler {
	
	func showLoading() {
		
		let indicatorView = self.activityIndicator()
		self.view.addSubview(indicatorView)
		
		indicatorView.translatesAutoresizingMaskIntoConstraints = false
		indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
	}
	
	func hideLoading() {
		
		guard let indicatorView = view.viewWithTag(indicatorTag) else { return }
		indicatorView.removeFromSuperview()
	}
	
	func activityIndicator() -> UIActivityIndicatorView {
		
		if let indicator = view.viewWithTag(indicatorTag) as? UIActivityIndicatorView {
			return indicator
		}
		
		let indicatorView = UIActivityIndicatorView(style: .medium)
		indicatorView.color = .white
		indicatorView.tag = indicatorTag
		indicatorView.startAnimating()
		return indicatorView
	}
}

