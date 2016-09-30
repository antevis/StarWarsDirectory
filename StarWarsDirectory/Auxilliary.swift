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

protocol MeasureSystemDelegate: class {
	
	func measureSystemSetTo<T: SizeProvider>(measureSystem: MeasureSystem, item: T)
	
	func imperialSystemSet()
	func metricSystemSet()
}


class Auxilliary {
	
	class func stringFrom(date: NSDate?, format: String) -> String {
		
		guard let date = date else {
			
			return "Not defined"
		}
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = format
		
		return dateFormatter.stringFromDate(date)
	}
	
	class func dateFrom(text: String, format: String) -> NSDate? {
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = format
		
		return dateFormatter.dateFromString(text)
	}
	
	
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
				return "\(round(10 * source * milesPerKm) / 10) mi"
			
			case .metersToYards:
				
				let yardsPerMeter: Double = 1.09361
				return "\(round(10 * source * yardsPerMeter) / 10) yd"
			
			case .kgToPounds:
				
				let poundsPerKg: Double = 2.20462
				return "\(round(10 * source * poundsPerKg) / 10) lb"
			
		}
		
		
	}
	
	class func descriptionOfMetric(value: Double, forMeasure measure: MeasureSystem, with scale: ConversionScale) -> String {
		
		switch measure {
			
			case .Imperial:
				
				return Aux.convertToImperial(from: value, scale: scale)
				
			case .Metric:
				
				return "\(value) \(scale.rawValue)"
			
		}
	}
	
	class func currentLocaleDescriptionOfMetric(value: Double, with scale: ConversionScale?) -> String {
		
		if let scale = scale {
			
			return Aux.descriptionOfMetric(value, forMeasure: Aux.localeMeasureSystem(), with: scale)
			
		} else {
			
			return "\(value)"
		}
	}
	
	class func descriptionOfCredits(value: Double, forCurrency currency: Currency, with rate: Double) -> String {
		
		switch currency {
			
			case .USD:
				
				return "\(round(100 * value * rate) / 100) \(currency.rawValue)"
				
			case .GCR:
				
				return "\(value) \(currency.rawValue)"
			
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
	
	class func localeMeasureSystem() -> MeasureSystem {
		
		if let isMetric = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as? Bool {
			
			return isMetric ? .Metric : .Imperial
			
		} else /*It's extremely unlikely that above binding fails, but still we don't take chances..*/ {
			
			return .Metric //Default API measure system
		}
	}
}

protocol SizeProvider {
	
	var size: Double? { get }
	
	func sizeIn(measure: MeasureSystem, with scale: ConversionScale) -> String
}

enum ConversionScale: String {
	
	case cmToFeetInches = "cm"
	case kmToMiles = "km"
	case metersToYards = "m"
	case kgToPounds = "kg"
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
	
	var isNumber: Bool {
		
		return isInteger || isDouble
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