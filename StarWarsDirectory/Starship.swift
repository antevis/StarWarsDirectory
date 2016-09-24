//
//  Starship.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

struct Starship: SizeProvider, JSONDecodable {
	
	let name: String // The name of this starship. The common name, such as "Death Star".
	let model: String // The model or official name of this starship. Such as "T-65 X-wing" or "DS-1 Orbital Battle Station".
	let manufacturer: String // The manufacturer of this starship. Comma seperated if more than one.
	let cost_in_credits: DescriptiveDouble // The cost of this starship new, in galactic credits.
	
	// The length of this starship in meters.
	var length: DescriptiveDouble {
		
		didSet {
			
			if let doubleValue = length.doubleValue {
				
				length.description = "\(doubleValue) m"
			}
		}
	}
	
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
	
	let max_atmosphering_speed: DescriptiveDouble // The maximum speed of this starship in atmosphere. "N/A" if this starship is incapable of atmosphering flight.
	let crew: DescriptiveInt // The number of personnel needed to run or pilot this starship.
	let passengers: DescriptiveInt // The number of non-essential people this starship can transport.
	let cargo_capacity: DescriptiveDouble // The maximum number of kilograms that this starship can transport.
	let consumables: DescriptiveDouble //The maximum length of time that this starship can provide consumables for its entire crew without having to resupply.
	let hyperdrive_rating: String // The class of this starships hyperdrive.
	let MGLT: DescriptiveDouble // The Maximum number of Megalights this starship can travel in a standard hour. A "Megalight" is a standard unit of distance and has never been defined before within the Star Wars universe. This figure is only really useful for measuring the difference in speed of starships. We can assume it is similar to AU, the distance between our Sun (Sol) and Earth.
	let starship_class: String // The class of this starship, such as "Starfighter" or "Deep Space Mobile Battlestation"
	let pilots: [String] // An array of People URL Resources that this starship has been piloted by.
	let films: [String] // An array of Film URL Resources that this starship has appeared in.
	let url: String // the hypermedia URL of this resource.
	
	var starShipTableData: [(key: String, value: String, scale: ConversionScale?, convertible: Bool)] {
		
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
	
	//Optional
//	let created: NSDate? // the ISO 8601 date format of the time that this resource was created.
//	let edited: NSDate? // the ISO 8601 date format of the time that this resource was edited.
	
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
}

