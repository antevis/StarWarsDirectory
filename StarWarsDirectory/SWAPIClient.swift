//
//  MovieCharacterAPIClient.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 11/09/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

protocol SWCategoryType: JSONDecodable, SizeProvider {
	
	var name: String { get }
	var categoryTitle: String { get }
	
	var tableData: [(key: String, value: String, scale: ConversionScale?, convertible: Bool)] { get }
}

protocol AssociatedUrlsProvider {
	
	var urlArraysDictionary: [RootResource: [String]] { get }
}

enum MeasureSystem {
	
	case Metric
	case Imperial
}

enum Currency: String {
	
	case Credits //Galacti credits
	case USD
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

typealias DescriptiveInt = (intValue: Int?, description: String)
typealias DescriptiveDouble = (doubleValue: Double?, description: String)
typealias Aux = Auxilliary

protocol MeasureSystemDelegate: class {
	
	func measureSystemSetTo<T: SizeProvider>(measureSystem: MeasureSystem, item: T)
	
	func imperialSystemSet()
	func metricSystemSet()
}

enum SWEndpoint: Endpoint {
	
	case Characters(Int)
	case Planets(Int)
	case Species(Int)
	case Starships(Int)
	case Vehicles(Int)
	case Films(Int)
	
	var baseURL: NSURL {
		
		return NSURL(string: "http://swapi.co/api/")!
	}
	
	var path: String {
		
		switch self {
			
			case .Characters(let page):
				
				return "people/?page=\(page)"
			
			case .Planets(let page):
				
				return "planets/?page=\(page)"
			
			case .Species(let page):
				
				return "species/?page=\(page)"
			
			case .Starships(let page):
				
				return "starships/?page=\(page)"
			
			case .Vehicles(let page):
				
				return "vehicles/?page=\(page)"
			
			case .Films(let page):
				
				return "films/?page=\(page)" //this is really so, yet there is only one page so far
			
		}
	}
	
	var request: NSURLRequest {
		
		let url = NSURL(string: path, relativeToURL: baseURL)!
		
		return NSURLRequest(URL: url)
	}
}

class SwapiClient: APIClient {
	
	//To be honest, the recursion approach has been borrowed.
	func fetchPaginatedResource<T: SWCategoryType>(endPoint: SWEndpoint, completion: APIResult<[T]> -> Void) {
		
		var resourceResultArray = [T]()
		
		var recursiveCompletion: (JSON -> [T]?)!
		
		let fetchCompletion = { (json: JSON) -> [T]? in
			
			if let resourceSupspects = json["results"] as? [AnyObject] {
				
				var currentPageResources = [T]()
				
				for resourceCandidate in resourceSupspects {
					
					if let mc = resourceCandidate as? [String: AnyObject], candidate = T(json: mc) {
						
						currentPageResources.append(candidate)
					}
				}
				
				resourceResultArray += currentPageResources
				
				if let nextPage = json["next"] as? String {
					
					let nextURL = NSURL(string: nextPage)
					let nextRequest = NSURLRequest(URL: nextURL!)
					
					self.fetch(nextRequest, parse: recursiveCompletion, completion: completion)
					
				}
				
				return resourceResultArray
				
			} else {
				
				return nil
			}
		}
		
		recursiveCompletion = fetchCompletion
		
		let request = endPoint.request
		
		fetch(request, parse: fetchCompletion, completion: completion)
	}
	
	func fetchSWCategoryArrayFrom<T: SWCategoryType>(urlArray: [String], completion: APIResult<[T]> -> Void) {
		
		var resourceResultArray = [T]()
		
		var recursiveCompletion: (JSON -> [T]?)!
		
		var i: Int = 0
		
		let fetchCompletion = { (json: JSON) -> [T]? in
			
			if let candidate = T(json: json) {
				
				resourceResultArray.append(candidate)
			}

			i += 1
			
			if i < urlArray.count {
			
				let nextRequest = NSURLRequest(URL: NSURL(string: urlArray[i])!)
				
				self.fetch(nextRequest, parse: recursiveCompletion, completion: completion)
				
			}
			
			return resourceResultArray
		}
		
		recursiveCompletion = fetchCompletion
		
		let request = NSURLRequest(URL: NSURL(string: urlArray[i])!)
		
		fetch(request, parse: fetchCompletion, completion: completion)
		
		
	}
	
	func fetchPlanet(url: String, completion: APIResult<Planet> -> Void) {
		
		let request = NSURLRequest(URL: NSURL(string: url)!)

		fetch(request, parse: { planetJson -> Planet? in
			
			return Planet(json: planetJson)
			
		}, completion: completion)
	}
}
