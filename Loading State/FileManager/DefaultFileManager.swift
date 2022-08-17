import Foundation
import UIKit

enum ApplicationDirectories: String {
	case temp = "Temp"
	case interlalFolders = "InternalFolders"
	case contacts
}

enum FileFormat {

	case png
	case jpeg
	
	var rawValue: String {
		switch self {
			case .png:
				return "png"
			case .jpeg:
				return "jpg"
		}
	}
}

class DefaultFileManager {
	
	private let fileManager: FileManager
	
	init() {
		self.fileManager = FileManager.default
	}
}


// `contacts`
extension DefaultFileManager {
	
	
	public func getContactsDirectory() -> URL {
		self.getURL(of: .contacts)
	}
	
	public func saveContactImage(data: Data, id: String, quality: CompressionQuality.CompressValue = .medium) {
		
		let imageDir = self.getContactsDirectory()
		
		let filePath = imageDir.appendingPathComponent(id).appendingPathExtension(FileFormat.jpeg.rawValue)
	
		if quality == .original {
			do {
				try data.write(to: filePath)
			} catch {
				debugPrint(error.localizedDescription)
			}
		} else {
			if let image = UIImage(data: data), let compressed = image.compressJpeg(quality) {
				do {
					try compressed.write(to: filePath)
				} catch {
					debugPrint(error.localizedDescription)
				}
			}
		}
	}
	
	public func getContactImageURL(_ id: String) -> URL? {
		
		let path = self.getContactsDirectory().path
		let url = URL(fileURLWithPath: path).appendingPathComponent(id).appendingPathExtension(FileFormat.jpeg.rawValue)
		return url
	}
	
	public func loadContactImage(from id: String) -> UIImage? {
		
		guard let fileURL = self.getContactImageURL(id) else { return nil }
		
		if isFileExist(at: fileURL) {
			do {
				let image = try Data(contentsOf: fileURL)
				return UIImage(data: image)
			} catch {
				debugPrint(error.localizedDescription)
				return nil
			}
		} else {
			return nil
		}
	}
	
	public func isContactImageExist(_ id: String) -> Bool {
		guard let imgURL = self.getContactImageURL(id) else { return false}
		return isFileExist(at: imgURL)
	}
}


extension DefaultFileManager {
	
	public func getCacheDirectory() -> URL {
		let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
		var isDirectory: ObjCBool = true
		
		if !fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
			do {
				try fileManager.createDirectory(at: url, withIntermediateDirectories: false)
			} catch {
				debugPrint(error.localizedDescription)
			}
		}
		return url
	}
	
	func createDirectory(_ directory: ApplicationDirectories) {
		
		let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
		let directoryPath = path.appendingPathComponent(directory.rawValue).path
		
		var isDirectory: ObjCBool = true
		
		if !fileManager.fileExists(atPath: directoryPath, isDirectory: &isDirectory) {
			do {
				try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: false, attributes: nil)
			} catch {
				debugPrint(error.localizedDescription)
			}
		}
	}
	
	func deleteAllFiles(at directory: ApplicationDirectories, completion: @escaping () -> Void) {
		
		let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
		let folderPath = path.appendingPathComponent(directory.rawValue).path
		
		do {
			let folderContent = try fileManager.contentsOfDirectory(atPath: folderPath)
			folderContent.forEach { urlStringPath in
				if let url = URL(string: urlStringPath) {
					try? self.fileManager.removeItem(at: url)
				}
			}
			completion()
		} catch {
			debugPrint(error.localizedDescription)
		}
	}
	
	func getURL(of directory: ApplicationDirectories) -> URL {
		
		let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
		let internalDirectory = path.appendingPathComponent(directory.rawValue)
		
		var isDirectory: ObjCBool = true
		
		if !fileManager.fileExists(atPath: internalDirectory.path, isDirectory: &isDirectory) {
			do {
				try fileManager.createDirectory(atPath: internalDirectory.path, withIntermediateDirectories: false, attributes: nil)
				return internalDirectory
			} catch {
				debugPrint(error.localizedDescription)
			}
		}
		
		return internalDirectory
	}
}

extension DefaultFileManager {
	
	func moveItem(from source: URL, to destination: URL) {
		do {
			if isFileExist(at: destination) {
				try self.fileManager.removeItem(at: destination)
			}
			
			try fileManager.moveItem(at: source, to: destination)
		} catch {
			debugPrint(error.localizedDescription)
		}
	}
	
	func isFileExist(at url: URL) -> Bool {
		return fileManager.fileExists(atPath: url.path)
	}
}
