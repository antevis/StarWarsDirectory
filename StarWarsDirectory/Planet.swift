//
//  Planet.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

struct Planet {
		
	//Required
	let name: String // The name of this planet.
	let rotation_period: DescriptiveDouble // The number of standard hours it takes for this planet to complete a single rotation on its axis.
	let orbital_period: DescriptiveDouble // The number of standard days it takes for this planet to complete a single orbit of its local star.
	let diameter: DescriptiveDouble // The diameter of this planet in kilometers.
	let climate: String // The climate of this planet. Comma-seperated if diverse.
	let gravity: DescriptiveDouble // A number denoting the gravity of this planet, where "1" is normal or 1 standard G. "2" is twice or 2 standard Gs. "0.5" is half or 0.5 standard Gs.
	let terrain: String // The terrain of this planet. Comma-seperated if diverse.
	let surface_water: DescriptiveDouble // The percentage of the planet surface that is naturally occuring water or bodies of water.
	let population: DescriptiveInt // The average population of sentient beings inhabiting this planet.
	let residents: [String] // An array of People URL Resources that live on this planet.
	let films: [String] // An array of Film URL Resources that this planet has appeared in.
	let url: String // the hypermedia URL of this resource.
	
	//Optional (marked required for planets, though. But still)
	let created: NSDate? // the ISO 8601 date format of the time that this resource was created.
	let edited: NSDate? // the ISO 8601 date format of the time that this resource was edited.
}

