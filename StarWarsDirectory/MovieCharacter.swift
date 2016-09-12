//
//  MovieCharacter.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

//People

import Foundation

struct  MovieCharacter {
	
	//Required
	let name: String
	let height: DescriptiveInt
//	let mass: DescriptiveInt // The mass of the person in kilograms.
	
	let hair_color: String // The hair color of this person. Will be "unknown" if not known or "n/a" if the person does not have hair.
//	let skin_color: String // The skin color of this person.
	let eye_color: String // The eye color of this person. Will be "unknown" if not known or "n/a" if the person does not have an eye.
	let birth_year: String // The birth year of the person, using the in-universe standard of BBY or ABY - Before the Battle of Yavin or After the Battle of Yavin. The Battle of Yavin is a battle that occurs at the end of Star Wars episode IV: A New Hope.
//	let gender: String // The gender of this person. Either "Male", "Female" or "unknown", "n/a" if the person does not have a gender.
	
	let homeworld: String // The URL of a planet resource, a planet that this person was born on or inhabits.
	
	//TODO: change homeworld type to Planet
	//let homeworld: Planet // The URL of a planet resource, a planet that this person was born on or inhabits.
//	let films: [String] // An array of film resource URLs that this person has been in.
//	let species: [String] // An array of species resource URLs that this person belonds to.
//	let vehicles: [String] // An array of vehicle resource URLs that this person has piloted.
//	let starships: [String] // An array of starship resource URLs that this person has piloted.
//	let url: String// the hypermedia URL of this resource.
	
	//Optional
//	let created: NSDate? // the ISO 8601 date format of the time that this resource was created.
//	let edited: NSDate?
}

extension MovieCharacter {
	
	init?(json: [String: AnyObject]) {
		
		guard let
			name = json["name"] as? String,
			height = json["height"] as? String,
			//mass = json["mass"] as? String,
			hairColor = json["hair_color"] as? String,
			//skinColor = json["skin_color"] as? String,
			eyeColor = json["eye_color"] as? String,
			birthYear = json["birth_year"] as? String,
			planet = json["homeworld"] as? String else {
				
				return nil
		}
		
		self.name = name
		self.height = height.descriptiveInt
		self.hair_color = hairColor
		self.eye_color = eyeColor
		self.birth_year = birthYear
		self.homeworld = planet
		
//		guard let temperature = JSON["temperature"] as? Double,
//			humidity = JSON["humidity"] as? Double,
//			precipitationProbability = JSON["precipProbability"] as? Double,
//			summary = JSON["summary"] as? String else {
//				
//				return nil
//		}
//		
//		if let iconString = JSON["icon"] as? String {
//			
//			self.icon = WeatherIcon(rawValue: iconString)?.image
//		}
//		
//		self.temperature = temperature
//		self.humidity = humidity
//		self.precipitationProbability = precipitationProbability
//		self.summary = summary
	}
}


