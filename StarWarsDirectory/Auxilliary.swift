//
//  Auxilliary.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 07/09/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

typealias DescriptiveInt = (intValue: Int?, description: String)
typealias DescriptiveDouble = (doubleValue: Double?, description: String)
typealias Aux = Auxilliary

class Auxilliary {
	
//	class func getDescriptiveValue<T>(stringValue: String) -> (T?, String) {
//		
//		var result: (T?, String)
//		
//		if let tValue = stringValue as? T {
//			
//			result.0 = tValue
//		}
//		
//		result.1 = stringValue
//		
//		return result
//	}
	
	class func convertToImperial(from source: Double, scale: ConversionScale) -> String {
		
		switch scale {
			
			case .cmToFeetInches:
			
				let cmPerFoot: Double = 30.48
				let cmPerInch: Double = cmPerFoot / 12
				
				let feet = Int(source / cmPerFoot)
				
				let inches = Int((Double(source) % cmPerFoot) / cmPerInch)
				
				return "\(feet)' \(inches)''"
			
			case .kmToMiles:
				
				let milesPerKm: Double = 0.621371
				return "\(round(source * milesPerKm)) mi"
			
			case .metersToYards:
				
				let yardsPerMeter: Double = 1.09361
				return "\(source * yardsPerMeter) yd"
			
		}
		
		
	}
	
	class func getExtremesWithin<T: SizeProvider>(array: [T]?) -> (min: T?, max: T?)? {
		
		guard let array = array where array.count > 0 else { return nil }
		
		var minSize: Double?
		var maxSize: Double?
		
		var smallestMember: T? {
			
			didSet { minSize = smallestMember?.size }
		}
		
		var biggestMember: T? {
			
			didSet { maxSize = biggestMember?.size }
		}
		
		for item in array {
			
			if let itemSize = item.size {
				
				if let minSize = minSize {
					
					if itemSize < minSize {
						
						smallestMember = item
					}
					
				} else {
					
					smallestMember = item
				}
				
				if let maxSize = maxSize {
					
					if itemSize > maxSize {
						
						biggestMember = item
					}
					
				} else {
					
					biggestMember = item
				}
			}
		}
		
		return (smallestMember, biggestMember)
	}
}

protocol SizeProvider {
	
	var size: Double? { get }
	
	func sizeIn(measure: MeasureSystem) -> String
}

enum ConversionScale {
	
	case cmToFeetInches
	case kmToMiles
	case metersToYards
}



extension String {
	
	var doubleValue: Double? {
		
		if let digitalValue = Double(self) { return digitalValue }
		else { return nil }
	}
	
	var intValue: Int? {
		
		if let digitalValue = Int(self) { return digitalValue }
		else { return nil }
	}
	
	var isInteger: Bool {
		
		if let intVal = self.intValue, let doubleVal = self.doubleValue where Double(intVal) == doubleVal {
			
			return true
		
		} else {
			
			return false
		}
	}
	
	var isDouble: Bool {
		
		return self.doubleValue != nil
	}
	
	var descriptiveInt: (intValue: Int?, description: String) {
		
		var result: (Int?, String) = (nil, self)
		
		if self.isInteger {
			
			result.0 = self.intValue
		}
		
		return result
	}
	
	var descriptiveDouble: (doubleValue: Double?, description: String) {
		
		var result: (Double?, String) = (nil, self)
		
		if self.isDouble {
			
			result.0 = self.doubleValue
		}
		
		return result
	}
}