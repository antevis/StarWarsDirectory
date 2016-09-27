//
//  MovieCharacter.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

//People

import Foundation



class MovieCharacter: SWCategory, SizeProvider {
	
	let categoryTitle: String = "People"
	
	//Required
	let name: String
	
	//height in centimeters
	var height: DescriptiveInt {
		
		didSet {
			
			if let invValue = height.intValue {
				
				height.description = "\(invValue) cm"
			}
		}
	}
	
	//Query api for planet data only when property accessed.
	lazy var homePlanet: Planet? = Planet(url: self.homeWorldUrl)
	
	var size: Double? {
		
		if let intValue = height.intValue {
			
			return Double(intValue)
		
		} else {
			
			return nil
		}
	}
	
//	let mass: DescriptiveInt // The mass of the person in kilograms.
	
	let hair_color: String // The hair color of this person. Will be "unknown" if not known or "n/a" if the person does not have hair.
//	let skin_color: String // The skin color of this person.
	let eye_color: String // The eye color of this person. Will be "unknown" if not known or "n/a" if the person does not have an eye.
	let birth_year: String // The birth year of the person, using the in-universe standard of BBY or ABY - Before the Battle of Yavin or After the Battle of Yavin. The Battle of Yavin is a battle that occurs at the end of Star Wars episode IV: A New Hope.
//	let gender: String // The gender of this person. Either "Male", "Female" or "unknown", "n/a" if the person does not have a gender.
	
	let homeWorldUrl: String // The URL of a planet resource, a planet that this person was born on or inhabits.
	
	//let homeworld: Planet // The URL of a planet resource, a planet that this person was born on or inhabits.
//	let films: [String] // An array of film resource URLs that this person has been in.
//	let species: [String] // An array of species resource URLs that this person belonds to.
//	let vehicles: [String] // An array of vehicle resource URLs that this person has piloted.
//	let starships: [String] // An array of starship resource URLs that this person has piloted.
//	let url: String// the hypermedia URL of this resource.
	
	//Optional
//	let created: NSDate? // the ISO 8601 date format of the time that this resource was created.
//	let edited: NSDate?
	
	func sizeIn(measure: MeasureSystem, with scale: ConversionScale) -> String {
		
		guard let intValue = height.intValue else {
			
			return height.description
		}
		
		switch measure {
			
			case .Imperial:
				
				return Aux.convertToImperial(from: Double(intValue), scale: scale)
			
			case .Metric:
				
				return "\(intValue) \(scale.rawValue)"
		
		}
	}
	
	var tableData: [(key: String, value: String, scale: ConversionScale?, convertible: Bool)] {
		
		get {
			
			let data = [(key: String, value: String, scale: ConversionScale?, convertible: Bool)]()
			
//			data.append(("Model", model, nil, false))
//			data.append(("Manufacturer", manufacturer, nil, false))
//			data.append(("Cost", cost_in_credits.description, nil, true))
//			data.append(("Length", length.description, .metersToYards, false))
//			data.append(("Max.Atm.Spd", max_atmosphering_speed.description, nil, false))
//			data.append(("Crew", crew.description, nil, false))
//			data.append(("Passengers", passengers.description, nil, false))
//			data.append(("Cargo", cargo_capacity.description, .kgToPounds, false))
//			data.append(("Consumables", consumables.description, nil, false))
//			data.append(("HyperDrive", hyperdrive_rating, nil, false))
//			data.append(("MGLT", MGLT.description, nil, false))
//			data.append(("Class", starship_class, nil, false))
			
			return data
		}
	}
	
	required init?(json: JSON) {
		
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
		self.homeWorldUrl = planet
		
		
	}
}




