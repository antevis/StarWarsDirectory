//
//  APIClient.swift
//  Stormy
//
//  Created by Ivan Kazakov on 09/06/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

public let ANTNetworkingErrorDomain = "lt.antevis.Stormy.NetworkingError"

public let MissingHTTPResponseError: Int = 10
public let UnexpectedResponseError: Int = 20
public let MissingErrorError: Int = 30

typealias JSON = [String: AnyObject]
typealias JSONTaskCompletion = (JSON?, NSHTTPURLResponse?, NSError?) -> Void
typealias JSONTask = NSURLSessionDataTask

enum APIResult<T> {
	
	case Success(T)
	case Failure(ErrorType)
}

protocol JSONDecodable {
	
	init?(JSON: [String: AnyObject])
}

protocol Endpoint {
	
	var url: String? { get }
	var path: String? { get }
	var params: [String: AnyObject]? { get }
}

extension Endpoint {
	
	var queryComponents: [NSURLQueryItem]? {
		
		var components = [NSURLQueryItem]()
		
		if let params = params {
			
			for (key, value) in params {
				
				let queryItem = NSURLQueryItem(name: key, value: "\(value)")
				
				components.append(queryItem)
			}
		}
		
		if components.count > 0 {
			
			return components
			
		} else {
			
			return nil
		}
	}
	
	var request: NSURLRequest? {
		
		guard let url = url, path = path else {
		
			return nil
		}
		
		let components = NSURLComponents(string: url)
		components?.path = path
		components?.queryItems = queryComponents
		
		if let fullUrl = components?.URL {
			
			return NSURLRequest(URL: fullUrl)
			
		} else {
			
			return nil
		}
	}
}

protocol APIClient {
	
	var configuration: NSURLSessionConfiguration { get }
	var session: NSURLSession { get }
	
	func jsonTaskWithRequest(request: NSURLRequest, completion: JSONTaskCompletion) -> JSONTask
	
	func fetch<T: JSONDecodable>(request: NSURLRequest, parse: JSON -> T?, completion: APIResult<T> -> Void)
}

extension APIClient {
	
	func jsonTaskWithRequest(request: NSURLRequest, completion: JSONTaskCompletion) -> JSONTask {
		
		let task = session.dataTaskWithRequest(request) { dataCandidate, responseCandidate, error in
			
			guard let hTTPresponse = responseCandidate as? NSHTTPURLResponse else {
				
				let userInfo = [
					NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
				]
				
				let error = NSError(domain: ANTNetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
				
				completion(nil, nil, error)
				
				return //returns from the current scope which in this case is the completion of session.dataTaskWithRequest
			}
			
			if let dataCandidate = dataCandidate {
				
				switch hTTPresponse.statusCode {
					
					case 200:
						
						do {
							
							let json = try NSJSONSerialization.JSONObjectWithData(dataCandidate, options: []) as? [String: AnyObject]
							
							completion(json, hTTPresponse, error)
							
						} catch let err as NSError {
							
							completion(nil, hTTPresponse, err)
						}
						
						default: print("Received HTTP response: \(hTTPresponse.statusCode).")
						
					}
				
				
			} else {
				
				completion(nil, hTTPresponse, error)
			}
			
		}
		
		return task
	}
	
	func fetch<T>(request: NSURLRequest, parse: JSON -> T?, completion: APIResult<T> -> Void) {
		
		let task = jsonTaskWithRequest(request) { json, response, error in
			
			dispatch_async(dispatch_get_main_queue()) {
				
				guard let json = json else {
					
					if let normalError = error {
						
						completion(.Failure(normalError))
						
					} else {
						
						let abnormalError = NSError(domain: ANTNetworkingErrorDomain, code: MissingErrorError, userInfo: nil)
						
						completion(.Failure(abnormalError))
					}
					
					return
				}
				
				if let value = parse(json) {
					
					completion(.Success(value))
					
				} else {
					
					let unexpectedError = NSError(domain: ANTNetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
					
					completion(.Failure(unexpectedError))
					
				}
			}
		}
		
		task.resume()
	}
	
	func fetch<T: JSONDecodable>(endpoint: Endpoint, parse: JSON -> [T]?, completion: APIResult<[T]> -> Void) {
		
		guard let request = endpoint.request else {
			
			return
		}
		
		let task = jsonTaskWithRequest(request) { json, response, error in
			
			dispatch_async(dispatch_get_main_queue()) {
				
				guard let json = json else {
					
					if let normalError = error {
						
						completion(.Failure(normalError))
						
					} else {
						
						let abnormalError = NSError(domain: ANTNetworkingErrorDomain, code: MissingErrorError, userInfo: nil)
						
						completion(.Failure(abnormalError))
					}
					
					return
				}
				
				if let value = parse(json) {
					
					completion(.Success(value))
					
				} else {
					
					let unexpectedError = NSError(domain: ANTNetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
					
					completion(.Failure(unexpectedError))
					
				}
			}
		}
		
		task.resume()
	}
}
