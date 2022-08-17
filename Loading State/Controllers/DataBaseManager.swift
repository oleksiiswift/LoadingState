import Realm
import RealmSwift

class DataBaseManager {
	
	class var shared: DataBaseManager {
		struct Static {
			static let instance: DataBaseManager = DataBaseManager()
		}
		return Static.instance
	}
	
	private let realm = try! Realm()
	
	var instance: Realm {
		return realm
	}
	
	var thread = BeyondTheThread()
}
