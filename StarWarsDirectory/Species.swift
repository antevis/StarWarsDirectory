//
//  Species.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 26/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import Foundation



class Species: SWCategoryType, AssociatedUrlsProvider {
	
	var avgHeight: DescriptiveInt {
		
		didSet {
			
			if let doubleValue = avgHeight.intValue {
				
				avgHeight.description = "\(doubleValue) cm"
			}
		}
	}

	//Will query API for planet data only when property accessed.
	lazy var homePlanet: Planet? = nil
	let hairColors: String
	let skinColors: String
	let eyeColors: String
	let homeWorldUrl: String
	let films: [String]
	let url: String
	let classification: String
	let designation: String
	let averageLifespan: DescriptiveInt
	let language: String
	let people: [String]
	
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
	
	//SizeProvider (part of SWCategoryType)
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
	
	//JSONDecodable (Part of SWCategoryType)
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
	
	//MARK: AssociatedUrlsProvider
	var urlArraysDictionary: [RootResource : [String]] {
		
		return [
			RootResource(rootResource: .movies): films,
			RootResource(rootResource: .MovieCharacters): people,
		]
	}
	
}

