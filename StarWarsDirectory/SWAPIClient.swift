//
//  MovieCharacterAPIClient.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 11/09/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

enum SWEndpoint: Endpoint {
	
	case Characters(Int)
	case Planets(Int)
	
	var baseURL: NSURL {
		
		return NSURL(string: "http://swapi.co/api/")!
	}
	
	var path: String {
		
		switch self {
			
			case .Characters(let page):
				
				return "people/?page=\(page)"
			
			case .Planets(let page):
				
				return "planets/?page=\(page)"
		}
	}
	
	var request: NSURLRequest {
		
		let url = NSURL(string: path, relativeToURL: baseURL)!
		
		return NSURLRequest(URL: url)
	}
}

class SwapiClient: APIClient {
	
	//To be honest, the recursion approach has been borrowed.
	func fetchPaginatedResource<T: JSONDecodable>(endPoint: SWEndpoint, completion: APIResult<[T]> -> Void) {
		
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
	
	func fetchMovieCharacters(completion: APIResult<[MovieCharacter]> -> Void) {
		
		let endpoint = SWEndpoint.Characters(1)
		
		fetchPaginatedResource(endpoint, completion: completion)
	}
	
	
	func fetchPlanet(url: String, completion: APIResult<Planet> -> Void) {
		
		let request = NSURLRequest(URL: NSURL(string: url)!)

		fetch(request, parse: { planetJson -> Planet? in
			
			return Planet(json: planetJson)
			
		}, completion: completion)
	}
}
