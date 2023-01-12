import UIKit
import RealmSwift

enum DataLoadingType {
	case contacts
}

protocol StateProvider: AnyObject {
	
	var initialState: LoadingState { get }
	var title: String? { get }
	var stateChanger: StateChanger? { get set }
	
	func contentViewController(_ results: Results<Object>) -> UIViewController?
	func contentViewController() -> UIViewController?
	func dataLoadingViewControoller(_ loadingType: DataLoadingType) -> UIViewController?
	func errorViewController() -> UIViewController?
	func emptyViewController() -> UIViewController?
}
