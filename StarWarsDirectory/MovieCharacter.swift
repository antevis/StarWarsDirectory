//
//  MovieCharacter.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

//People

import Foundation



struct MovieCharacter: SWCategoryType, AssociatedUrlsProvider {
	
	let eye_color: String // The eye color of this person. Will be "unknown" if not known or "n/a" if the person does not have an eye.
	let vehicles: [String] // An array of vehicle resource URLs that this person has piloted.
	let gender: String // The gender of this person. Either "Male", "Female" or "unknown", "n/a" if the person does not have a gender.
	let hair_color: String // The hair color of this person. Will be "unknown" if not known or "n/a" if the person does not have hair.
	
	//height in centimeters
	var height: DescriptiveInt {
		
		didSet {
			
			if let invValue = height.intValue {
				
				height.description = "\(invValue) cm"
			}
		}
	}
	
	let species: [String] // An array of species resource URLs that this person belonds to.
	let films: [String] // An array of film resource URLs that this person has been in.
	let birth_year: String // The birth year of the person, using the in-universe standard of BBY or ABY - Before the Battle of Yavin or After the Battle of Yavin. The Battle of Yavin is a battle that occurs at the end of Star Wars episode IV: A New Hope.
	let mass: DescriptiveInt // The mass of the person in kilograms.
	let skin_color: String // The skin color of this person.
	let url: String// the hypermedia URL of this resource.
	let homeWorldUrl: String // The URL of a planet resource, a planet that this person was born on or inhabits.
	let starships: [String] // An array of starship resource URLs that this person has piloted.
	
	//Query api for planet data only when property accessed.
	lazy var homePlanet: Planet? = nil// Planet(url: self.homeWorldUrl)
	
	//MARK: SWCategory conformance
	let categoryTitle: String = "People"
	let name: String
	
	var tableData: [(key: String, value: String, scale: ConversionScale?, convertible: Bool)] {
		
		get {
			
			var data = [(key: String, value: String, scale: ConversionScale?, convertible: Bool)]()
			
			data.append(("Born", birth_year, nil, false))
			data.append(("Home", "", nil, false))
			data.append(("Height", height.description, ConversionScale.cmToFeetInches, false))
			data.append(("Eyes", eye_color, nil, false))
			data.append(("Hair", hair_color, nil, false))
			data.append(("Gender", gender, nil, false))
			data.append(("Mass", mass.description, ConversionScale.kgToPounds, false))
			data.append(("Skin", skin_color, nil, false))
			
			return data
		}
	}
	
	//SizeProvider (Part of SWCategoryType)
	var size: Double? {
		
		if let intValue = height.intValue {
			
			return Double(intValue)
			
		} else {
			
			return nil
		}
	}
	
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
	
	//JSONDecodable (Part of SWCategoryType)
	init?(json: JSON) {
		
		guard let
			name = json["name"] as? String,
			height = json["height"] as? String,
			mass = json["mass"] as? String,
			hairColor = json["hair_color"] as? String,
			skinColor = json["skin_color"] as? String,
			eyeColor = json["eye_color"] as? String,
			birthYear = json["birth_year"] as? String,
			vehicles = json["vehicles"] as? [String],
			gender = json["gender"] as? String,
			species = json["species"] as? [String],
			films = json["films"] as? [String],
			url = json["url"] as? String,
			starships = json["starships"] as? [String],
			planet = json["homeworld"] as? String else {
				
				return nil
		}
		
		self.name = name
		self.height = height.descriptiveInt
		self.hair_color = hairColor
		self.eye_color = eyeColor
		self.birth_year = birthYear
		self.homeWorldUrl = planet
		self.mass = mass.descriptiveInt
		self.skin_color = skinColor
		self.vehicles = vehicles
		self.gender = gender
		self.species = species
		self.films = films
		self.url = url
		self.starships = starships
		
	}
	
	//MARK: AssociatedUrlsProvider
	var urlArraysDictionary: [RootResource : [String]] {
		
		return [
			RootResource(rootResource: .movies): films,
			RootResource(rootResource: .starships): starships,
			RootResource(rootResource: .vehicles): vehicles,
			RootResource(rootResource: .species): species
		]
	}
}




