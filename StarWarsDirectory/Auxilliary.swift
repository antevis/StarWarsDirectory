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