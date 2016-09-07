//
//  Film.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

struct Film {
	
	//Required
	let title: String
	let episode_id: Int
	let opening_crawl: String
	let director: String
	let producer: String
	let release_date: NSDate
	let characters: [MovieCharacter]
	let planets: [Planet]
	let starships: [Starship]
	let vehicles: [Vehicle]
	let species: [Species]
	let url: String
	
	//Optional
	let created: NSDate?
	let edited: NSDate?
}

