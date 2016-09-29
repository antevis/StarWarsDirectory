//
//  Film.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation

struct Film: SWCategoryType {
	
	//Required
	//let title: String
	let episode_id: Int
	let opening_crawl: String
	let director: String
	let producer: String
	let release_date: NSDate?
	let characters: [String]
	let planets: [String]
	let starships: [String]
	let vehicles: [String]
	let species: [String]
	let url: String
	
	//MARK: SWCategory conformance
	let categoryTitle: String = "Films"
	let name: String
	
	var tableData: [(key: String, value: String, scale: ConversionScale?, convertible: Bool)] {
		
		get {
			
			var data = [(key: String, value: String, scale: ConversionScale?, convertible: Bool)]()
			
			data.append(("Episode ID", "\(episode_id)", nil, false))
			data.append(("Director", director, nil, false))
			data.append(("Producer", producer, nil, false))
			data.append(("Release", Aux.stringFrom(release_date, format: "yyyy-MM-dd"), nil, false))
			
			return data
		}
	}
	
	//JSONDecodable
	init?(json: JSON) {
		
		guard let
			
			vehicles = json["vehicles"] as? [String],
			planets = json["planets"] as? [String],
			producer = json["producer"] as? String,
			title = json["title"] as? String,
			species = json["species"] as? [String],
			release_date = json["release_date"] as? String,
			characters = json["characters"] as? [String],
			url = json["url"] as? String,
			opening_crawl = json["opening_crawl"] as? String,
			starships = json["starships"] as? [String],
			episode_id = json["episode_id"] as? Int,
			director = json["director"] as? String else {
				
				return nil
		}
		
		self.episode_id = episode_id
		self.opening_crawl = opening_crawl
		self.director = director
		self.producer = producer
		self.release_date = Aux.dateFrom(release_date, format: "yyyy-MM-dd")
		self.characters = characters
		self.planets = planets
		self.starships = starships
		self.vehicles = vehicles
		self.species = species
		self.url = url
		self.name = title
		
	}
	
	//SizeProvider
	var size: Double? {
		
		return nil
	}
	
	func sizeIn(measure: MeasureSystem, with scale: ConversionScale) -> String {
		
		return ""
	}
	
}

