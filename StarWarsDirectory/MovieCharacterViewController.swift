//
//  MovieCharacterViewController.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 07/09/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

class MovieCharacterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	
	@IBOutlet weak var characterPicker: UIPickerView!
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var dobLabel: UILabel!
	@IBOutlet weak var homePlanetLabel: UILabel!
	@IBOutlet weak var heightLabel: UILabel!
	@IBOutlet weak var eyeColorLabel: UILabel!
	@IBOutlet weak var hairColorLabel: UILabel!
	
	@IBOutlet weak var shortestLabel: UILabel!
	@IBOutlet weak var highestLabel: UILabel!
	
	@IBOutlet weak var imperialButton: UIButton!
	@IBOutlet weak var metricButton: UIButton!
	
	//Initially explicitly set to default API measure system to bypass the init() requirement. Re-evaluated in viewDidLoad according to current locale
	var currentMeasureSystem = MeasureSystem.Metric {
		
		didSet {
			
			switch currentMeasureSystem {
				
				case .Imperial:
					imperialButton.enabled = false
					metricButton.enabled = true
				
				case .Metric:
					imperialButton.enabled = true
					metricButton.enabled = false
			}
			
			self.heightLabel.text = currentCharacter?.heightIn(currentMeasureSystem)
		}
	}
	
	var movieCharacters: [MovieCharacter]?
	
	var currentCharacter: MovieCharacter?
	
	var isMetric: Bool?
	
	let apiClient = SwapiClient()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		characterPicker.delegate = self
		
		imperialButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
		metricButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
		
		isMetric = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as? Bool
		
		if let isMetric = isMetric {
			
			currentMeasureSystem = isMetric ? .Metric : .Imperial
		
		} else /*Highly unprobable, but still..*/ {
			
			
			currentMeasureSystem = .Metric //Default API measure system
		}
		
        // Do any additional setup after loading the view.
		
		// Status bar white font
		self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		
		apiClient.fetchMovieCharacters() { result in
			
			switch result {
				
				case .Success(let characters):
					
					self.movieCharacters = characters.sort { $0.name < $1.name }
					
					self.characterPicker.reloadAllComponents()
					
					self.displayCharacterData()
					
				case .Failure(let error as NSError):
					
					self.showAlert("Unable to retrieve movie characters", message: error.localizedDescription)
					
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
		self.navigationController?.navigationBar.topItem?.title = "Characters"
	}
	
	
	//MARK: picker conformance
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		if let movieCharacters = movieCharacters{
		
		return movieCharacters[row].name
		} else {
			return "Please wait."
		}
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		if let movieCharacters = movieCharacters{
		
		return movieCharacters.count
		} else {
			return 0
		}
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		displayCharacterData()
	}
	
	func displayCharacterData() {
		
		let currentCharacterIndex = characterPicker.selectedRowInComponent(0)
		
		guard let movieCharacters = movieCharacters else {
			
			return
		}
		
		self.currentCharacter = movieCharacters[currentCharacterIndex]
		
		guard let currentCharacter = currentCharacter else {
			
			return
		}
		
		self.nameLabel.text = currentCharacter.name
		self.dobLabel.text = currentCharacter.birth_year
		
		//To avoid previously selected moviecharacter data being displayed before planet fetch completion handled.
		self.noHomePlanetData()
		
		self.heightLabel.text = currentCharacter.heightIn(currentMeasureSystem)
		
		self.hairColorLabel.text = currentCharacter.hair_color
		self.eyeColorLabel.text = currentCharacter.eye_color
		
		if let planet = currentCharacter.homePlanet {
			
			//If planet has already been pulled before, use it instead of recurrent quering the API
			self.homePlanetLabel.text = planet.name
			
		} else {
			
			apiClient.fetchPlanet(currentCharacter.homeWorldUrl) { result in
				
				switch result {
					
					case .Success(let planet):
						
						//Set planet data for future access instead of recurrent quering the API
						self.movieCharacters?[currentCharacterIndex].homePlanet = planet
						
						self.homePlanetLabel.text = planet.name
						
					case .Failure( _ as NSError):
						
						self.noHomePlanetData()
						
					default: break
				}
			}
		}
		
		if let shortestTallest = getShortestTallestWithin(movieCharacters) {
			
			if let shortest = shortestTallest.min {
				
				shortestLabel.text = "\(shortest.name): \(shortest.height.description) cm"
			}
			
			if let highest = shortestTallest.max {
				
				highestLabel.text = "\(highest.name): \(highest.height.description) cm"
			}
		}
	}
	
	func noHomePlanetData() {
		
		self.homePlanetLabel.text = "unknown"
	}
	
	func showAlert(title: String, message: String?, style: UIAlertControllerStyle = .Alert) {
		
		let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
		
		let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		
		alertController.addAction(dismissAction)
		
		presentViewController(alertController, animated: true, completion: nil)
	}
	
	func getShortestTallestWithin(movieCharacters: [MovieCharacter]?) -> (min: MovieCharacter?, max: MovieCharacter?)? {
		
		guard let movieCharacters = movieCharacters where movieCharacters.count > 0 else { return nil }
		
		var minHeight: Int?
		var maxHeight: Int?
		
		var shortestCharacter: MovieCharacter? {
			
			didSet { minHeight = shortestCharacter?.height.intValue }
		}
		
		var highestCharacter: MovieCharacter? {
			
			didSet { maxHeight = highestCharacter?.height.intValue }
		}
		
		for characacter in movieCharacters {
			
			if let characterHeight = characacter.height.intValue {
				
				if let minHeight = minHeight {
					
					if characterHeight < minHeight {
					
						shortestCharacter = characacter
					}
					
				} else {
					
					shortestCharacter = characacter
				}
				
				if let maxHeight = maxHeight {
					
					if characterHeight > maxHeight {
						
						highestCharacter = characacter
					}
					
				} else {
					
					highestCharacter = characacter
				}
			}
		}
		
		return (shortestCharacter, highestCharacter)
	}
	
	@IBAction func metricButtonHandler(sender: UIButton) {
		
		currentMeasureSystem = .Metric
	}

	@IBAction func imperialButtonHandler(sender: UIButton) {
		
		currentMeasureSystem = .Imperial
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
