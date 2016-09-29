//
//  Vehicle.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

struct Vehicle: SizeProvider, SWCategoryType {
	
	let categoryTitle: String = "Vehicles"
	
	let name: String // The name of this vehicle. The common name, such as "Sand Crawler" or "Speeder bike".
	let model: String // The model or official name of this vehicle. Such as "All-Terrain Attack Transport".
	let manufacturer: String // The manufacturer of this vehicle. Comma-seperated if more than one.
	let cost_in_credits: DescriptiveDouble // The cost of this vehicle new, in Galactic Credits.
	
	// The length of this vehicle in meters.
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
	
	let max_atmosphering_speed: DescriptiveDouble // The maximum speed of this vehicle in atmosphere.
	let crew: DescriptiveInt // The number of personnel needed to run or pilot this vehicle.
	let passengers: DescriptiveInt // The number of non-essential people this vehicle can transport.
	let cargo_capacity: DescriptiveDouble // The maximum number of kilograms that this vehicle can transport.
	let consumables: DescriptiveDouble //The maximum length of time that this vehicle can provide consumables for its entire crew without having to resupply. Presumably in days, buts still double for safety
	let vehicle_class: String // The class of this vehicle, such as "Wheeled" or "Repulsorcraft".
	let pilots: [String] // An array of People URL Resources that this vehicle has been piloted by.
	let films: [String] // An array of Film URL Resources that this vehicle has appeared in.
	let url: String // the hypermedia URL of this resource.
	
	//Optional
//	let created: NSDate? // the ISO 8601 date format of the time that this resource was created.
//	let edited: NSDate? // the ISO 8601 date format of the time that this resource was edited.
	
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
			data.append(("Class", vehicle_class, nil, false))
			
			
			return data
		}
	}
	
	init?(json: JSON) {
		
		guard let
			
			crew = json["crew"] as? String,
			vehicleClass = json["vehicle_class"] as? String,
			consumables = json["consumables"] as? String,
			model = json["model"] as? String,
			passengers = json["passengers"] as? String,
			url = json["url"] as? String,
			maxAtmoSpeed = json["max_atmosphering_speed"] as? String,
			name = json["name"] as? String,
			cost = json["cost_in_credits"] as? String,
			manufacturer = json["manufacturer"] as? String,
			pilots = json["pilots"] as? [String],
			length = json["length"] as? String,
			cargoCapacity = json["cargo_capacity"] as? String,
			films = json["films"] as? [String] else {
				
				return nil
		}
		
		self.crew = crew.descriptiveInt
		self.vehicle_class = vehicleClass
		self.consumables = consumables.descriptiveDouble
		self.model = model
		self.passengers = passengers.descriptiveInt
		self.url = url
		self.max_atmosphering_speed = maxAtmoSpeed.descriptiveDouble
		self.name = name
		self.cost_in_credits = cost.descriptiveDouble
		self.manufacturer = manufacturer
		self.pilots = pilots
		self.length = length.descriptiveDouble
		self.cargo_capacity = cargoCapacity.descriptiveDouble
		self.films = films
	}
}

