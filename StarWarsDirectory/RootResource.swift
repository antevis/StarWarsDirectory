//
//  RootResource.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 20/08/16.
//  Copyright © 2016 Antevis. All rights reserved.
//

import Foundation
import UIKit

struct RootResource {
	
	let resourceName: String
	let resourceUrlString: String
	
	var icon: UIImage? {
		
		if let icon = UIImage(named: resourceName) {
			
			return icon
		
		} else if let defaultImage = UIImage(named: "default") { //I nerver 100% sure of anything.
			
			return defaultImage
		
		} else {
			
			return nil
		}
	}
	
	var resourceTitle: String {
		
		return resourceName.capitalizedString
	}
}