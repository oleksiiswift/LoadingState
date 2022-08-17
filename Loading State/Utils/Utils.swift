import Foundation

var emptyString = ""
var whiteSpace = " "

struct Utils {
	
}

extension Utilites {
	
	static func viewByClassName(view: UIView, className: String) -> UIView? {
		let name = NSStringFromClass(type(of: view))
		if name == className {
			return view
		}
		else {
			for subview in view.subviews {
				if let view = viewByClassName(view: subview, className: className) {
					return view
				}
			}
		}
		return nil
	}
	
	static func buttonByClassName(view: UIView, className: String) -> UIButton? {
		let name = NSStringFromClass(type(of: view))
		if name == className {
			return view as? UIButton
		}
		else {
			for subview in view.subviews {
				if let view = viewByClassName(view: subview, className: className) {
					return view as? UIButton
				}
			}
		}
		return nil
	}
}

