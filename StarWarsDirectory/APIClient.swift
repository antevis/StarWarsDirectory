//
//  APIClient.swift
//  Stormy
//
//  Created by Ivan Kazakov on 10/09/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

public let ANTNetworkingErrorDomain = "lt.antevis.NetworkingError"
public let MissingHTTPResponseError: Int = 10
public let UnexpectedResponseError: Int = 20
public let AbnormalError: Int = 30

typealias JSON = [String: AnyObject]
typealias JSONTaskCompletion = (JSON?, NSHTTPURLResponse?, NSError?) -> Void

protocol JSONDecodable {
	
	init?(json: JSON)
}

protocol Endpoint {
	
	var baseURL: NSURL { get }
	var path: String { get }
	var request: NSURLRequest { get }
}

enum APIResult<T> {
	
	case Success(T)
	case Failure(ErrorType)
}

enum MeasureSystem {
	
	case Metric
	case Imperial
}

enum Currency: String {
	
	case GCR
	case USD
}

protocol SWCategory: JSONDecodable {
	
	var name: String { get }
	var categoryTitle: String { get }
	
	var tableData: [(key: String, value: String, scale: ConversionScale?, convertible: Bool)] { get }
}



class APIClient {
	
	func JSONTaskWith(request: NSURLRequest, completion: JSONTaskCompletion) -> NSURLSessionDataTask {
		
		let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
		let session: NSURLSession = NSURLSession(configuration: sessionConfig)
		
		let task = session.dataTaskWithRequest(request) { data, response, error in
			
			guard let httpResponse = response as? NSHTTPURLResponse else {
				
				let userInfo = [
					NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
				]
				
				let error = NSError(domain: ANTNetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
				
				//no data, no response, error occured
				completion(nil, nil, error)
				
				return
			}
			
			if let dataCandidate = data {
				
				switch httpResponse.statusCode {
					
				case 200:
					
					do {
						
						let json = try NSJSONSerialization.JSONObjectWithData(dataCandidate, options: []) as? [String: AnyObject]
						
						completion(json, httpResponse, error)
						
					} catch let err as NSError {
						
						completion(nil, httpResponse, err)
					}
					
				default: print("Received HTTP response: \(httpResponse.statusCode).")
				}
				
			} else {
				
				completion(nil, httpResponse, error)
			}
		}
		
		return task
	}
	
	func fetch<T>(request: NSURLRequest, parse: JSON -> T?, completion: APIResult<T> -> Void) {
		
		let task = JSONTaskWith(request) { json, response, error in
			
			dispatch_async(dispatch_get_main_queue()) {
				
				guard let json = json else {
					
					if let normalError = error {
						
						completion(.Failure(normalError))
						
					} else {
						
						let abnormalError = NSError(domain: ANTNetworkingErrorDomain, code: AbnormalError, userInfo: nil)
						
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


