import UIKit

struct CompressionQuality {
	
	var value: CompressValue = .original
	var quality: CompressQality = .original
	
	init() {}
	
	init(by quality: String) {
		
		guard let quality = CompressQality(rawValue: quality) else { return }
		
		self.quality = quality
		
		switch quality {
		case .original:
			value = .original
		case .hight:
			value = .high
		case .medium:
			value = .medium
		case .low:
			value = .low
		}
	}
	
	public mutating func setByValue(_ value: CompressionQuality.CompressValue) {
		self.value = value
		
		switch value {
		case .original:
			quality = .original
		case .high:
			quality = .hight
		case .medium:
			quality = .medium
		case .low:
			quality = .low
		}
	}
}

extension CompressionQuality {
	
	enum CompressValue: CGFloat {
		case original = 1
		case low = 0.8
		case medium = 0.5
		case high = 0.0
	}
	
	enum CompressQality: String {
		case original = "Original"
		case low = "Low"
		case medium = "Medium"
		case hight = "high"
	}
}

