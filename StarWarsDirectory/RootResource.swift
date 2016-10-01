//
//  RootResource.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 20/08/16.
//  Copyright © 2016 Antevis. All rights reserved.
//

import Foundation
import UIKit

enum Root: String {
	
	case movies
	case MovieCharacters = "people"
	case species
	case starships
	case vehicles
	case planets
	
	var url: String {
		
		get {
			
			let baseUrl = "http://swapi.co/api/"
			
			return "\(baseUrl)\(self.rawValue)/"
		}
	}
}

struct RootResource {
	
	let rootResource: Root
	
	var resourceName: String {
		
		get {
			return rootResource.rawValue
		}
	}
	
	var resourceUrlString: String {
		
		get {
			
			return rootResource.url
		}
	}
	
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
