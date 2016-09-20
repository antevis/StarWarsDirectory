//
//  PlanetViewController.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 18/09/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

class PlanetViewController: DetailViewController, UIPickerViewDelegate, UIPickerViewDataSource, MeasureSystemDelegate {
	
	@IBOutlet weak var planetNameLabel: UILabel!
	@IBOutlet weak var rotationPeriodLabel: UILabel!
	@IBOutlet weak var orbitalPeriodLabel: UILabel!
	@IBOutlet weak var diameterLabel: UILabel!
	@IBOutlet weak var climateLabel: UILabel!
	@IBOutlet weak var gravityLabel: UILabel!
	@IBOutlet weak var terrainLabel: UILabel!
	@IBOutlet weak var surfaceWaterLabel: UILabel!
	@IBOutlet weak var populationLabel: UILabel!
	@IBOutlet weak var biggestPlanetLabel: UILabel!
	@IBOutlet weak var smallestPlanetLabel: UILabel!
	
	@IBOutlet weak var planetPicker: UIPickerView!
	@IBOutlet weak var measureSystemControl: UISegmentedControl!
	
	var planets: [Planet]?
	var currentPlanet: Planet?
	
	let apiClient = SwapiClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.measureSystemDelegate = self
		
		handle(currentMeasureSystem)
		
		planetPicker.delegate = self
		
		apiClient.fetchPlanets() { result in
		
			switch result {
				
				case .Success(let planets):
					
					self.planets = planets.sort { $0.name < $1.name }
					
					self.planetPicker.reloadAllComponents()
				
				self.displayPlanetDataFor(self.planetPicker.selectedRowInComponent(0))
				
				case .Failure(let error as NSError):
					
					self.showAlert("Unable to retrieve planets", message: error.localizedDescription)
					
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
		self.navigationController?.navigationBar.topItem?.title = "Planets"
	}
	
	//MARK: planet functions
	func displayPlanetDataFor(index: Int) {
		
		guard let planets = planets else {
			
			return
		}
		
		self.currentPlanet = planets[index]
		
		guard let currentPlanet = currentPlanet else {
			
			return
		}
		
		self.planetNameLabel.text = currentPlanet.name
		self.rotationPeriodLabel.text = currentPlanet.rotation_period.description
		self.orbitalPeriodLabel.text = currentPlanet.orbital_period.description
		
		self.diameterLabel.text = currentPlanet.diameterIn(currentMeasureSystem)
		
		self.climateLabel.text = currentPlanet.climate
		self.gravityLabel.text = currentPlanet.gravity.description
		self.terrainLabel.text = currentPlanet.terrain
		self.surfaceWaterLabel.text = currentPlanet.surface_water.description
		self.populationLabel.text = currentPlanet.population.description
		
		if let smallestBiggest = Aux.getExtremesWithin(planets) {
			
			if let smallest = smallestBiggest.min {
				
				smallestPlanetLabel.text = "\(smallest.name): \(smallest.diameter.description) km"
			}
			
			if let biggest = smallestBiggest.max {
				
				biggestPlanetLabel.text = "\(biggest.name): \(biggest.diameter.description) km"
			}
		}
	}
	
	//MARK: Picker conformance
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if let planets = planets {
			
			return planets[row].name
		
		} else {
			
			return "Please wait."
		}
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		if let planets = planets {
			
			return planets.count
		
		} else {
			
			return 0
		}
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		let currentPlanetIndex = planetPicker.selectedRowInComponent(0)
		
		displayPlanetDataFor(currentPlanetIndex)
	}
	
	//MARK: MeasureSystem delegate conformance
	func measureSystemSetTo(measureSystem: MeasureSystem) {
		
		self.diameterLabel.text = currentPlanet?.diameterIn(measureSystem)
	}
	
	func imperialSystemSet() {
		
		measureSystemControl.selectedSegmentIndex = 1
		
//		imperialButton.enabled = false
//		metricButton.enabled = true
	}
	
	func metricSystemSet() {
		
		measureSystemControl.selectedSegmentIndex = 0
		
//		imperialButton.enabled = true
//		metricButton.enabled = false
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
