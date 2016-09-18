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
	
	var baseURL: NSURL {
		
		return NSURL(string: "http://swapi.co/api/")!
	}
	
	var path: String {
		
		switch self {
			
			case .Characters(let page):
				
				return "people/?page=\(page)"
		}
	}
	
	var request: NSURLRequest {
		
		let url = NSURL(string: path, relativeToURL: baseURL)!
		
		return NSURLRequest(URL: url)
	}
}

class SwapiClient: APIClient {
	
	//To be honest, the recursion approach has been borrowed.
	func fetchMovieCharacters(completion: APIResult<[MovieCharacter]> -> Void) {
		
		var movieCharacters = [MovieCharacter]()
		
		var recursiveCompletion: (JSON -> [MovieCharacter]?)!
		
		let fetchCompletion = { (json: JSON) -> [MovieCharacter]? in
			
			if let characterSupspects = json["results"] as? [AnyObject] {
				
				var currentPageCharacters = [MovieCharacter]()
				
				for characterCandidate in characterSupspects {
					
					if let mc = characterCandidate as? [String: AnyObject], candidate = MovieCharacter(json: mc) {
						
						currentPageCharacters.append(candidate)
					}
				}
				
				movieCharacters += currentPageCharacters
				
				if let nextPage = json["next"] as? String {
					
					let nextURL = NSURL(string: nextPage)
					let nextRequest = NSURLRequest(URL: nextURL!)
					
					
					
					self.fetch(nextRequest, parse: recursiveCompletion, completion: completion)
					
				}
				
				return movieCharacters
				
			} else {
				
				return nil
			}
		}
		
		recursiveCompletion = fetchCompletion
		
		let request = SWEndpoint.Characters(7).request
		
		fetch(request, parse: fetchCompletion, completion: completion)
	}
	
	func fetchPlanet(url: String, completion: APIResult<Planet> -> Void) {
		
		let request = NSURLRequest(URL: NSURL(string: url)!)

		fetch(request, parse: { planetJson -> Planet? in
			
			return Planet(json: planetJson)
			
		}, completion: completion)
	}
}
