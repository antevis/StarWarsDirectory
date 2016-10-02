//
//  Species.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation



class Species: SWCategoryType, AssociatedUrlsProvider {
	
	
	
	// The average height of this species in centimeters.
	var avgHeight: DescriptiveInt {
		
		didSet {
			
			if let doubleValue = avgHeight.intValue {
				
				avgHeight.description = "\(doubleValue) cm"
			}
		}
	}
	
	//MARK: AssociatedUrlsProvider
	var urlArraysDictionary: [RootResource : [String]] {
		
		return [
			RootResource(rootResource: .movies): films,
			RootResource(rootResource: .MovieCharacters): people,
		]
	}
	
	//Query api for planet data only when property accessed.
	lazy var homePlanet: Planet? = nil //Planet(url: self.homeWorldUrl)
	
	
	
	let hairColors: String // A comma-seperated: String of common hair colors for this species, "none" if this species does not typically have hair.
	let skinColors: String // A comma-seperated: String of common skin colors for this species, "none" if this species does not typically have skin.
	let eyeColors: String // A comma-seperated: String of common eye colors for this species, "none" if this species does not typically have eyes.
	let homeWorldUrl: String // The URL of a planet resource, a planet that this species originates from.
	let films: [String] // An array of Film URL Resources that this species has appeared in.
	let url: String // the hypermedia URL of this resource.
	
	let classification: String // The classification of this species, such as "mammal" or "reptile".
	let designation: String // The designation of this species, such as "sentient".
	let averageLifespan: DescriptiveInt // The average lifespan of this species in years.
	let language: String // The language commonly spoken by this species.
	let people: [String] // An array of People URL Resources that are a part of this species.
	//let created: NSDate? // the ISO 8601 date format of the time that this resource was created.
	//let edited: NSDate? // the ISO 8601 date format of the time that this resource was edited.
	
	//MARK: SWCategory conformance
	let categoryTitle: String = "Species"
	let name: String // The name of this species.
	var tableData: [(key: String, value: String, scale: ConversionScale?, convertible: Bool)] {
		
		get {
			
			var data = [(key: String, value: String, scale: ConversionScale?, convertible: Bool)]()
			
			data.append(("Designation", designation, nil, false))
			data.append(("Avg. Lifespan", averageLifespan.description, nil, false))
			data.append(("Avg. Height", avgHeight.description, ConversionScale.cmToFeetInches, false))
			data.append(("Language", language, nil, false))
			data.append(("Classification", classification, nil, false))
			data.append(("Eye Colors", eyeColors, nil, false))
			data.append(("Hair Colors", hairColors, nil, false))
			data.append(("Skin Colors", skinColors, nil, false))
			data.append(("Home", "", nil, false))
			
			return data
		}
	}
	
	//SizeProvider (part of SWCategory
	var size: Double? {
		
		if let intValue = avgHeight.intValue {
			
			return Double(intValue)
			
		} else {
			
			return nil
		}
	}
	
	func sizeIn(measure: MeasureSystem, with scale: ConversionScale) -> String {
		
		guard let intValue = avgHeight.intValue else {
			
			return avgHeight.description
		}
		
		switch measure {
			
		case .Imperial:
			
			return Aux.convertToImperial(from: Double(intValue), scale: scale)
			
		case .Metric:
			
			return "\(intValue) cm"
			
		}
	}
	
	//JSONDecodable (Part of SWCategory)
	required init?(json: JSON) {
		
		guard let
			
			name = json["name"] as? String,
			avgHeight = json["average_height"] as? String,
			hairColors = json["hair_colors"] as? String,
			lang = json["language"] as? String,
			url = json["url"] as? String,
			films = json["films"] as? [String],
			classification = json["classification"] as? String,
			avgLifeSpan = json["average_lifespan"] as? String,
			people = json["people"] as? [String],
			designation = json["designation"] as? String,
			eyeColors = json["eye_colors"] as? String,
			homeWorld = json["homeworld"] as? String,
			skinColors = json["skin_colors"] as? String else {
				
				return nil
		}
		
		self.name = name
		self.avgHeight = avgHeight.descriptiveInt
		self.hairColors = hairColors
		self.language = lang
		self.url = url
		self.films = films
		self.classification = classification
		self.averageLifespan = avgLifeSpan.descriptiveInt
		self.people = people
		self.designation = designation
		self.eyeColors = eyeColors
		self.homeWorldUrl = homeWorld
		self.skinColors = skinColors
		
		
	}
	
}

