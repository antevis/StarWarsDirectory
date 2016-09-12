//
//  MovieCharacterAPIClient.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 11/09/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

enum MovieCharacters: Endpoint {
	
	case Characters
	
	var baseURL: NSURL {
		
		return NSURL(string: "http://swapi.co/api")!
	}
	
	var path: String {
		return "/people/"
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
		
		let request = MovieCharacters.Characters.request
		
		fetch(request, parse: { json -> [MovieCharacter]? in
			
			if let characters = json["results"] as? [AnyObject] {
				
				var movieCharacters = [MovieCharacter]()
				
				for character in characters {
					
					if let mc = character as? [String: AnyObject] {
						
						if let candidate = MovieCharacter(json: mc) {
							
							movieCharacters.append(candidate)
						}
					}
				}
				
				return movieCharacters
				
			} else {
				
				return nil
			}
			
		}, completion: completion)
	}
}
