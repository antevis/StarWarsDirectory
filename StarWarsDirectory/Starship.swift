//
//  Starship.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

struct Starship: SWCategoryType, AssociatedUrlsProvider {
	
	//MARK: Starship-specific properties (OK, not ONLY starship-specific eventually)
	let model: String
	let manufacturer: String
	let cost_in_credits: DescriptiveDouble
	
	var length: DescriptiveDouble {
		
		didSet {
			
			if let doubleValue = length.doubleValue {
				
				length.description = "\(doubleValue) m"
			}
		}
	}
	
	let max_atmosphering_speed: DescriptiveDouble
	let crew: DescriptiveInt
	let passengers: DescriptiveInt
	let cargo_capacity: DescriptiveDouble
	let consumables: DescriptiveDouble
	let hyperdrive_rating: String
	let MGLT: DescriptiveDouble
	let starship_class: String
	let pilots: [String]
	let films: [String]
	let url: String
	
	//MARK: SWCategory conformance
	let categoryTitle: String = "Starships"
	let name: String // The name of this starship. The common name, such as "Death Star".
	var tableData: [(key: String, value: String, scale: ConversionScale?, convertible: Bool)] {
		
		get {
			
			var data = [(key: String, value: String, scale: ConversionScale?, convertible: Bool)]()
			
			data.append(("Model", model, nil, false))
			data.append(("Manufacturer", manufacturer, nil, false))
			data.append(("Cost", cost_in_credits.description, nil, true))
			data.append(("Length", length.description, .metersToYards, false))
			data.append(("Max.Atm.Spd", max_atmosphering_speed.description, nil, false))
			data.append(("Crew", crew.description, nil, false))
			data.append(("Passengers", passengers.description, nil, false))
			data.append(("Cargo", cargo_capacity.description, .kgToPounds, false))
			data.append(("Consumables", consumables.description, nil, false))
			data.append(("HyperDrive", hyperdrive_rating, nil, false))
			data.append(("MGLT", MGLT.description, nil, false))
			data.append(("Class", starship_class, nil, false))
			
			return data
		}
	}
	
	//JSONDecodable (Part of SWCategoryType)
	init?(json: JSON) {
		
		guard let
		
			crew = json["crew"] as? String,
			starshipClass = json["starship_class"] as? String,
			consumables = json["consumables"] as? String,
			model = json["model"] as? String,
			passengers = json["passengers"] as? String,
			url = json["url"] as? String,
			maxAtmoSpeed = json["max_atmosphering_speed"] as? String,
			name = json["name"] as? String,
			cost = json["cost_in_credits"] as? String,
			manufacturer = json["manufacturer"] as? String,
			pilots = json["pilots"] as? [String],
			mglt = json["MGLT"] as? String,
			hyperdriveRating = json["hyperdrive_rating"] as? String,
			length = json["length"] as? String,
			cargoCapacity = json["cargo_capacity"] as? String,
			films = json["films"] as? [String] else {
				
				return nil
		}
		
		self.crew = crew.descriptiveInt
		self.starship_class = starshipClass
		self.consumables = consumables.descriptiveDouble
		self.model = model
		self.passengers = passengers.descriptiveInt
		self.url = url
		self.max_atmosphering_speed = maxAtmoSpeed.descriptiveDouble
		self.name = name
		self.cost_in_credits = cost.descriptiveDouble
		self.manufacturer = manufacturer
		self.pilots = pilots
		self.MGLT = mglt.descriptiveDouble
		self.hyperdrive_rating = hyperdriveRating
		self.length = length.descriptiveDouble
		self.cargo_capacity = cargoCapacity.descriptiveDouble
		self.films = films
	}
	
	//SizeProvider (part of SWCategoryType)
	var size: Double? {
		
		return length.doubleValue
	}
	
	func sizeIn(measure: MeasureSystem, with scale: ConversionScale) -> String {
		
		guard let doubleValue = length.doubleValue else {
			
			return length.description
		}
		
		switch measure {
			
		case .Imperial:
			
			return Aux.convertToImperial(from: doubleValue, scale: scale)
			
		case .Metric:
			
			return "\(doubleValue) \(scale.rawValue)"
		}
	}
	
	//MARK: AssociatedUrlsProvider
	var urlArraysDictionary: [RootResource : [String]] {
		
		return [
			RootResource(rootResource: .MovieCharacters): pilots,
			RootResource(rootResource: .movies): films,
		]
	}
}

