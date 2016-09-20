//
//  SpeciesViewController.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 19/09/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

class SpeciesViewController: DetailViewController, MeasureSystemDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
	
	@IBOutlet weak var speciesNameLabel: UILabel!
	@IBOutlet weak var avgHeightLabel: UILabel!
	@IBOutlet weak var hairColorsLabel: UILabel!
	@IBOutlet weak var eyeColorsLabel: UILabel!
	@IBOutlet weak var skinColors: UILabel!
	@IBOutlet weak var avgLifespanLabel: UILabel!
	@IBOutlet weak var designationLabel: UILabel!
	@IBOutlet weak var languageLabel: UILabel!
	@IBOutlet weak var classificationLabel: UILabel!
	@IBOutlet weak var planetLabel: UILabel!
	@IBOutlet weak var smallestLabel: UILabel!
	@IBOutlet weak var biggestLabel: UILabel!
	
	@IBOutlet weak var speciesPicker: UIPickerView!
	@IBOutlet weak var measureSystemControl: UISegmentedControl!
	
	var species: [Species]?
	var currentSpecies: Species?
	
	let apiClient = SwapiClient()
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.measureSystemDelegate = self
		
		handle(currentMeasureSystem)
		
		speciesPicker.delegate = self
		
		apiClient.fetchSpecies() { result in
			
			switch result {
				
			case .Success(let species):
				
				self.species = species.sort { $0.name < $1.name }
				
				self.speciesPicker.reloadAllComponents()
				
				self.displaySpeciesDataFor(self.speciesPicker.selectedRowInComponent(0))
				
			case .Failure(let error as NSError):
				
				self.showAlert("Unable to retrieve species", message: error.localizedDescription)
				
			default: break
				
			}
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
		
		
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.navigationBarHidden = false
		self.navigationController?.navigationBar.topItem?.title = "Species"
	}
	
	//MARK: Species functions
	func displaySpeciesDataFor(index: Int) {
		
		guard let species = species else {
			
			return
		}
		
		self.currentSpecies = species[index]
		
		guard let currentSpecies = self.currentSpecies else {
			
			return
		}
		
		self.speciesNameLabel.text = currentSpecies.name
		
		self.avgHeightLabel.text = currentSpecies.sizeIn(currentMeasureSystem)
		
		self.hairColorsLabel.text = currentSpecies.hairColors
		self.eyeColorsLabel.text = currentSpecies.eyeColors
		self.skinColors.text = currentSpecies.skinColors
		self.avgLifespanLabel.text = currentSpecies.averageLifespan.description
		self.designationLabel.text = currentSpecies.designation
		self.languageLabel.text = currentSpecies.language
		self.classificationLabel.text = currentSpecies.classification
		
		//To avoid previously selected moviecharacter data being displayed before planet fetch completion handled.
		self.noHomePlanetData()
		
		if let planet = currentSpecies.homePlanet {
			
			//If planet has already been pulled before, use it instead of recurrent quering the API
			self.planetLabel.text = planet.name
			
		} else {
			
			apiClient.fetchPlanet(currentSpecies.homeWorldUrl) { result in
				
				switch result {
					
				case .Success(let planet):
					
					//Set planet data for future access instead of recurrent quering the API
					self.species?[index].homePlanet = planet
					
					self.planetLabel.text = planet.name
					
				case .Failure( _ as NSError):
					
					self.noHomePlanetData()
					
				default: break
				}
			}
		}
		
		if let shortestTallest = Aux.getExtremesWithin(species) {
			
			if let shortest = shortestTallest.min {
				
				smallestLabel.text = "\(shortest.name): \(shortest.avgHeight.description) cm"
			}
			
			if let highest = shortestTallest.max {
				
				biggestLabel.text = "\(highest.name): \(highest.avgHeight.description) cm"
			}
		}
	}
	
	func noHomePlanetData() {
		
		self.planetLabel.text = ""
	}
	
	//MARK: MeasureSystem delegate conformance
	func measureSystemSetTo(measureSystem: MeasureSystem) {
		
		self.avgHeightLabel.text = currentSpecies?.heightIn(measureSystem)
	}
	
	func imperialSystemSet() {
		
		measureSystemControl.selectedSegmentIndex = 1
	}
	
	func metricSystemSet() {
		
		measureSystemControl.selectedSegmentIndex = 0
	}
	
	//MARK: Picker conformance
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if let species = species {
			
			return species[row].name
			
		} else {
			
			return "Please wait."
		}
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		if let species = species {
			
			return species.count
			
		} else {
			
			return 0
		}
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		let currentIndex = speciesPicker.selectedRowInComponent(0)
		
		displaySpeciesDataFor(currentIndex)
		
	}
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	@IBAction func measureSystemChanged(sender: UISegmentedControl) {
		
		switch sender.selectedSegmentIndex {
			
		case 0:
			currentMeasureSystem = .Metric
			
			print("Metric")
			
		case 1:
			currentMeasureSystem = .Imperial
			
			print("Imperial")
			
		default:
			break
		}
	}

}
