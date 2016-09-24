//
//  Planet.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

struct Planet: JSONDecodable, SizeProvider {
		
	//Required
	let name: String // The name of this planet.
	let rotation_period: DescriptiveDouble // The number of standard hours it takes for this planet to complete a single rotation on its axis.
	let orbital_period: DescriptiveDouble // The number of standard days it takes for this planet to complete a single orbit of its local star.
	
	// The diameter of this planet in kilometers.
	var diameter: DescriptiveDouble {
		
		didSet {
			
			if let doubleValue = diameter.doubleValue {
				
				diameter.description = "\(doubleValue) km"
			}
		}
	}
	
	var size: Double? {
		
		//if let doubleValue = diameter.doubleValue {
			
		return diameter.doubleValue
			
//		} else {
//			
//			return nil
//		}
	}
	
	func sizeIn(measure: MeasureSystem, with scale: ConversionScale) -> String {
		
		guard let doubleValue = diameter.doubleValue else {
			
			return diameter.description
		}
		
		switch measure {
			
			case .Imperial:
				
				return Aux.convertToImperial(from: Double(doubleValue), scale: scale)
				
			case .Metric:
				
				return "\(doubleValue) km"
		}
	}
	
	let climate: String // The climate of this planet. Comma-seperated if diverse.
	let gravity: DescriptiveDouble // A number denoting the gravity of this planet, where "1" is normal or 1 standard G. "2" is twice or 2 standard Gs. "0.5" is half or 0.5 standard Gs.
	let terrain: String // The terrain of this planet. Comma-seperated if diverse.
	let surface_water: DescriptiveDouble // The percentage of the planet surface that is naturally occuring water or bodies of water.
	let population: DescriptiveInt // The average population of sentient beings inhabiting this planet.
	let residents: [String] // An array of People URL Resources that live on this planet.
	let films: [String] // An array of Film URL Resources that this planet has appeared in.
	let url: String // the hypermedia URL of this resource.
//	
//	//Optional (marked required for planets, though. But still)
	//let created: NSDate?// the ISO 8601 date format of the time that this resource was created.
	//let edited: NSDate? // the ISO 8601 date format of the time that this resource was edited.
	
	init?(json: [String: AnyObject]) {
		
		guard let
			name = json["name"] as? String,
			rotationPeriod = json["rotation_period"] as? String,
			orbitalPeriod = json["orbital_period"] as? String,
			diameter = json["diameter"] as? String,
			climate = json["climate"] as? String,
			gravity = json["gravity"] as? String,
			terrain = json["terrain"] as? String,
			surfaceWater = json["surface_water"] as? String,
			population = json["population"] as? String,
			residents = json["residents"] as? [String],
			films = json["films"] as? [String],
			url = json["url"] as? String else {
		
				return nil
		}
		
		self.name = name
		self.rotation_period = rotationPeriod.descriptiveDouble
		self.orbital_period = orbitalPeriod.descriptiveDouble
		self.diameter = diameter.descriptiveDouble
		self.climate = climate
		self.gravity = gravity.descriptiveDouble
		self.terrain = terrain
		self.surface_water = surfaceWater.descriptiveDouble
		self.population = population.descriptiveInt
		self.residents = residents
		self.films = films
		self.url = url
		
	}
	
	init?(url: String) {
		
		return nil
	}
}

