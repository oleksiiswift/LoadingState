import RealmSwift

extension List {
	
	func convertable<T>(_ type: T.Type) -> [T] {
		return compactMap { $0 as? T}
	}
}

extension Results {
	
	func convertable<T>(_ type: T.Type) -> [T] {
		return compactMap { $0 as? T}
	}
}
