//
//  Starship.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

struct Starship {
	
	let name: String // The name of this starship. The common name, such as "Death Star".
	let model: String // The model or official name of this starship. Such as "T-65 X-wing" or "DS-1 Orbital Battle Station".
	let manufacturer: String // The manufacturer of this starship. Comma seperated if more than one.
	let cost_in_credits: DescriptiveDouble // The cost of this starship new, in galactic credits.
	let length: DescriptiveDouble // The length of this starship in meters.
	let max_atmosphering_speed: DescriptiveDouble // The maximum speed of this starship in atmosphere. "N/A" if this starship is incapable of atmosphering flight.
	let crew: DescriptiveInt // The number of personnel needed to run or pilot this starship.
	let passengers: DescriptiveInt // The number of non-essential people this starship can transport.
	let cargo_capacity: DescriptiveDouble // The maximum number of kilograms that this starship can transport.
	let consumables: DescriptiveDouble //The maximum length of time that this starship can provide consumables for its entire crew without having to resupply.
	let hyperdrive_rating: String // The class of this starships hyperdrive.
	let MGLT: DescriptiveDouble // The Maximum number of Megalights this starship can travel in a standard hour. A "Megalight" is a standard unit of distance and has never been defined before within the Star Wars universe. This figure is only really useful for measuring the difference in speed of starships. We can assume it is similar to AU, the distance between our Sun (Sol) and Earth.
	let starship_class: String // The class of this starship, such as "Starfighter" or "Deep Space Mobile Battlestation"
	let pilots: [MovieCharacter] // An array of People URL Resources that this starship has been piloted by.
	let films: [Film] // An array of Film URL Resources that this starship has appeared in.
	let url: String // the hypermedia URL of this resource.
	
	//Optional
	let created: NSDate? // the ISO 8601 date format of the time that this resource was created.
	let edited: NSDate? // the ISO 8601 date format of the time that this resource was edited.
}

