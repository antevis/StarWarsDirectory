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
	
	
	var movieCharacters: [MovieCharacter]?
	
	let apiClient = SwapiClient()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		characterPicker.delegate = self

        // Do any additional setup after loading the view.
		
		// Status bar white font
		self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		
//		apiClient.fetchMovieCharacters() { result in
//			
//			self.activityIndicator.stopAnimating()
//			
//			switch result {
//				
//				case .Success(let characters):
//					
//					self.movieCharacters = characters
//					
//					self.characterPicker.reloadAllComponents()
//				
//					self.displayCharacterData()
//				
//					//print("\(self.movieCharacters.count)")
//				
//				case .Failure(let error as NSError):
//					
//					self.showAlert("Unable to retrieve movie characters", message: error.localizedDescription)
//				
//				default: break
//			}
//		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.navigationBarHidden = false
		self.navigationController?.navigationBar.topItem?.title = "Characters"
		
		if movieCharacters == nil {
			
			apiClient.fetchMovieCharacters() { result in
				
				switch result {
					
					case .Success(let characters):
						
						
						
						self.movieCharacters = characters
						
						//let sorted = self.movieCharacters!.sort { $0.name > $1.name }
						
						self.characterPicker.reloadAllComponents()
						
						self.displayCharacterData()
						
						//print("\(self.movieCharacters.count)")
						
					case .Failure(let error as NSError):
						
						self.showAlert("Unable to retrieve movie characters", message: error.localizedDescription)
						
					default: break
				}
			}
		}
		
		//zeroLabel.text = zeroLabelText
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
		
		guard let movieCharacters = movieCharacters else {
			
			return
		}
		
		let currentCharacter = movieCharacters[characterPicker.selectedRowInComponent(0)]
		
		self.nameLabel.text = currentCharacter.name
		self.dobLabel.text = currentCharacter.birth_year
		self.homePlanetLabel.text = currentCharacter.homeworld
		self.heightLabel.text = currentCharacter.height.description
		self.hairColorLabel.text = currentCharacter.hair_color
		self.eyeColorLabel.text = currentCharacter.eye_color
		
		if let shortestTallest = getShortestTallestWithin(movieCharacters) {
			
			if let shortest = shortestTallest.min {
				
				shortestLabel.text = "\(shortest.name): \(shortest.height.description) cm"
			}
			
			if let highest = shortestTallest.max {
				
				highestLabel.text = "\(highest.name): \(highest.height.description) cm"
			}
		}
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
		
		guard let movieCharacters = movieCharacters else {
			
			return
		}
		
		for character in movieCharacters {
			
			print(character.height.description)
		}
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
