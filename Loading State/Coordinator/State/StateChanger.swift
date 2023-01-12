import Foundation
import RealmSwift


protocol StateChanger: AnyObject {
	func change(to state: LoadingState, results: Results<Object>?)
}

extension StateChanger {
	
	func change(to state: LoadingState) {
		change(to: state, results: nil)
	}
}
