//
//  Planet.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

struct Planet: SWCategoryType, AssociatedUrlsProvider {
	
	
	let rotation_period: DescriptiveDouble
	let orbital_period: DescriptiveDouble
	
	// The diameter of this planet in kilometers.
	var diameter: DescriptiveDouble {
		
		didSet {
			
			if let doubleValue = diameter.doubleValue {
				
				diameter.description = "\(doubleValue) km"
			}
		}
	}
	let climate: String
	let gravity: DescriptiveDouble
	let terrain: String
	let surface_water: DescriptiveDouble
	let population: DescriptiveInt
	let residents: [String]
	let films: [String]
	let url: String

	
	//MARK: SWCategory conformance
	let categoryTitle: String = "Planets"
	let name: String // The name of this planet.
	var tableData: [(key: String, value: String, scale: ConversionScale?, convertible: Bool)] {
		
		get {
			
			var data = [(key: String, value: String, scale: ConversionScale?, convertible: Bool)]()
			
			data.append(("Terrain", terrain, nil, false))
			data.append(("Gravity", gravity.description, nil, false))
			data.append(("Climate", climate, nil, false))
			data.append(("Orbital Period", orbital_period.description, nil, false))
			data.append(("Rotation Period", rotation_period.description, nil, false))
			data.append(("Diameter", diameter.description, ConversionScale.kmToMiles, false))
			data.append(("Population", population.description, nil, false))
			data.append(("Surface Water", surface_water.description, nil, false))
			
			return data
		}
	}
	
	//SizeProvider (Part of SWCategoryType)
	var size: Double? {
		
		return diameter.doubleValue
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
	
	//JSONDecodable (Part of SWCategoryType)
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
	
	//MARK: AssociatedUrlsProvider
	var urlArraysDictionary: [RootResource : [String]] {
		
		return [
			RootResource(rootResource: .MovieCharacters): residents,
			RootResource(rootResource: .movies): films,
		]
	}
	
	
}

