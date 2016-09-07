//
//  Species.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

typealias DescriptiveInt = (intValue: Int?, stringValue: String)
typealias DescriptiveDouble = (value: Double?, description: String)

struct Species {
	
	//Required
	let name: String // The name of this species.
	let height: DescriptiveInt // The average height of this species in centimeters.
	let hair_colors: String // A comma-seperated: String of common hair colors for this species, "none" if this species does not typically have hair.
	let skin_colors: String // A comma-seperated: String of common skin colors for this species, "none" if this species does not typically have skin.
	let eye_colors: String // A comma-seperated: String of common eye colors for this species, "none" if this species does not typically have eyes.
	let homeworld: Planet // The URL of a planet resource, a planet that this species originates from.
	let films: [Film] // An array of Film URL Resources that this species has appeared in.
	let url: String // the hypermedia URL of this resource.
	
	//Optional
	let classification: String? // The classification of this species, such as "mammal" or "reptile".
	let designation: String? // The designation of this species, such as "sentient".
	let average_lifespan: DescriptiveInt? // The average lifespan of this species in years.
	let language: String? // The language commonly spoken by this species.
	let people: [MovieCharacter]? // An array of People URL Resources that are a part of this species.
	let created: NSDate? // the ISO 8601 date format of the time that this resource was created.
	let edited: NSDate? // the ISO 8601 date format of the time that this resource was edited.
	
}

