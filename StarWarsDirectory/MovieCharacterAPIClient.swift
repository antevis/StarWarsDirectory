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

final class MovieCharacterAPIClient: APIClient {
	
	let configuration: NSURLSessionConfiguration
	lazy var session: NSURLSession = {
		
		return NSURLSession(configuration: self.configuration)
	}()
	
	
	
	init(config: NSURLSessionConfiguration) {
		
		self.configuration = config
	}
	
	convenience init() {
		
		self.init(config: NSURLSessionConfiguration.defaultSessionConfiguration())
	}
	
	func fetchMovieCharacters(completion: APIResult<[MovieCharacter]> -> Void) {
		
		var movieCharacters = [MovieCharacter]()
		
		//Basic working code for 9 pages
//		for i in 1...9 {
//
//			let request = Endpoints.Characters(i).request
//			
//			print(request.URL)
//
//			fetch(request, parse: { json -> [MovieCharacter]? in
//
//				if let characterSupspects = json["results"] as? [AnyObject] {
//	
//					for characterCandidate in characterSupspects {
//	
//						if let mc = characterCandidate as? [String: AnyObject], candidate = MovieCharacter(json: mc) {
//	
//							movieCharacters.append(candidate)
//						}
//					}
//	
//					return movieCharacters
//
//				} else {
//
//					return nil
//				}
//				
//			}, completion: completion)
//		}
		//End of basic working code
		
		let request = SWEndpoint.Characters(1).request
		
		fetch(request, parse: { json -> [MovieCharacter]? in
			
			if let characterSupspects = json["results"] as? [AnyObject] {
				
				for characterCandidate in characterSupspects {
					
					if let mc = characterCandidate as? [String: AnyObject], candidate = MovieCharacter(json: mc) {
						
						movieCharacters.append(candidate)
					}
				}
				
				return movieCharacters
			
			} else {
				
				return nil
			}
			
		}, completion: completion)
	}
	
//	func fetchMovieCharactersPaginated(completion: APIResult<[MovieCharacter]> -> Void) {
//		
//		var movieCharacters = [MovieCharacter]()
//		
//		var recursiveCompletion: APIResult<[MovieCharacter]> -> Void
//		
//		let fetchCompletion = { (result: APIResult<[MovieCharacter]>) -> Void in
//			
//			switch result {
//				
//			case .Success(let newCharacters):
//				
//				movieCharacters += newCharacters
//				
//				if let next = res
//			}
//		}
//	}
	
	func appendJson(dict: [String: AnyObject], toPrevious movieCharacters: [MovieCharacter]) -> [MovieCharacter] {
		
		var newMovieCharacters = [MovieCharacter]()
		
		if let characterSuspects = dict["results"] as? [AnyObject] {
			
			for characterCandidate in characterSuspects {
				
				if let mc = characterCandidate as? [String: AnyObject], candidate = MovieCharacter(json: mc) {
					
					newMovieCharacters.append(candidate)
				}
			}
		}
		
		return movieCharacters + newMovieCharacters
	}
}
