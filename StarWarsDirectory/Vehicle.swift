//
//  Vehicle.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

struct Vehicle {
	
	let name: String // The name of this vehicle. The common name, such as "Sand Crawler" or "Speeder bike".
	let model: String // The model or official name of this vehicle. Such as "All-Terrain Attack Transport".
	let manufacturer: String // The manufacturer of this vehicle. Comma-seperated if more than one.
	let cost_in_credits: DescriptiveDouble // The cost of this vehicle new, in Galactic Credits.
	let length: DescriptiveDouble // The length of this vehicle in meters.
	let max_atmosphering_speed: DescriptiveDouble // The maximum speed of this vehicle in atmosphere.
	let crew: DescriptiveInt // The number of personnel needed to run or pilot this vehicle.
	let passengers: DescriptiveInt // The number of non-essential people this vehicle can transport.
	let cargo_capacity: DescriptiveDouble // The maximum number of kilograms that this vehicle can transport.
	let consumables: DescriptiveDouble //The maximum length of time that this vehicle can provide consumables for its entire crew without having to resupply. Presumably in days, buts still double for safety
	let vehicle_class: String // The class of this vehicle, such as "Wheeled" or "Repulsorcraft".
	let pilots: [MovieCharacter] // An array of People URL Resources that this vehicle has been piloted by.
	let films: [Film] // An array of Film URL Resources that this vehicle has appeared in.
	let url: String // the hypermedia URL of this resource.
	
	//Optional
	let created: NSDate? // the ISO 8601 date format of the time that this resource was created.
	let edited: NSDate? // the ISO 8601 date format of the time that this resource was edited.
}

