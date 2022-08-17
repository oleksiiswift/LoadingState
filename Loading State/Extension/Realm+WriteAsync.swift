import RealmSwift
import Foundation

extension Realm {
	
	func writeAsync<T: ThreadConfined>(_ passedObject: T, errorHandler: @escaping ((_ error: Swift.Error) -> Void) = { _ in return }, block: @escaping ((Realm, T?) -> Void)) {
		let objectReference = ThreadSafeReference(to: passedObject)
		let configuration = self.configuration
		DispatchQueue.global(qos: .background).async  {
			autoreleasepool {
				do {
					let realm = try Realm(configuration: configuration)
					try realm.write {
						let object = realm.resolve(objectReference)
						block(realm, object)
					}
				} catch {
					errorHandler(error)
				}
			}
		}
	}
	
	func asyncRemoveSequence<T: Object>(_ objects: [T]) {
		for object in objects {
			self.writeAsync(object) { realm, object in
				guard let object = object else { return }
				realm.delete(object)
			}
		}
	}
	
	func asyncSaveSequence<T: Object>(objects: [T]) {
		
		for object in objects {
			self.writeAsync(object) { realm, object in
				guard let object = object else { return }
				self.add(object)
			}
		}
	}
}
