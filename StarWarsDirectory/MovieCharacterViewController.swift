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
	
	var movieCharacters = [MovieCharacter]()
	
	let characterAPIClient = MovieCharacterAPIClient()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		characterPicker.delegate = self

        // Do any additional setup after loading the view.
		
		// Status bar white font
		self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		
		characterAPIClient.fetchMovieCharacters() { result in
			
			switch result {
				
				case .Success(let characters):
					
					self.movieCharacters = characters
					
					self.characterPicker.reloadAllComponents()
				
					self.displayCharacterData()
				
				case .Failure(let error as NSError):
					
					self.showAlert("Unable to retrieve movie characters", message: error.localizedDescription)
				
				default: break
			}
			
			
			
		}
		
//		let lukePlanet = Planet(name: "Tatooine", rotation_period: "23".descriptiveDouble, orbital_period: "34".descriptiveDouble, diameter: "10465".descriptiveDouble, climate: "arid", gravity: "1".descriptiveDouble, terrain: "desert", surface_water: "1".descriptiveDouble, population: "200000".descriptiveInt, residents: [
//			"http://swapi.co/api/people/1/",
//			"http://swapi.co/api/people/2/",
//			"http://swapi.co/api/people/4/",
//			"http://swapi.co/api/people/6/",
//			"http://swapi.co/api/people/7/",
//			"http://swapi.co/api/people/8/",
//			"http://swapi.co/api/people/9/",
//			"http://swapi.co/api/people/11/",
//			"http://swapi.co/api/people/43/",
//			"http://swapi.co/api/people/62/"], films: [
//				"http://swapi.co/api/films/5/",
//				"http://swapi.co/api/films/4/",
//				"http://swapi.co/api/films/6/",
//				"http://swapi.co/api/films/3/",
//				"http://swapi.co/api/films/1/"], url: "http://swapi.co/api/planets/1/", created: nil, edited: nil)
		
//		let luke = MovieCharacter(name: "Luke Skywalker", height: "172".descriptiveInt, mass: "77".descriptiveInt, hair_color: "Blond", skin_color: "Caucasian", eye_color: "Blue", birth_year: "19 BBY", gender: "Male", homeworld: lukePlanet, films: [
//			"http://swapi.co/api/films/1/",
//			"http://swapi.co/api/films/2/",
//			"http://swapi.co/api/films/3/"], species: ["http://swapi.co/api/species/1/"], vehicles: [
//				"http://swapi.co/api/vehicles/14/",
//				"http://swapi.co/api/vehicles/30/"], starships: [
//					"http://swapi.co/api/starships/12/",
//					"http://swapi.co/api/starships/22/"], url: "http://swapi.co/api/people/1/", created: nil, edited: nil)
//		
//		let c3po = MovieCharacter(name: "C-3PO", height: "167".descriptiveInt, mass: "75".descriptiveInt, hair_color: "n/a", skin_color: "gold", eye_color: "yellow", birth_year: "112BBY", gender: "n/a", homeworld: lukePlanet, films: [
//			"http://swapi.co/api/films/5/",
//			"http://swapi.co/api/films/4/",
//			"http://swapi.co/api/films/6/",
//			"http://swapi.co/api/films/3/",
//			"http://swapi.co/api/films/2/",
//			"http://swapi.co/api/films/1/"], species: ["http://swapi.co/api/species/2/"], vehicles: [], starships: [], url: "http://swapi.co/api/people/2/", created: nil, edited: nil)
//		
//		movieCharacters += [luke, c3po]
		
		//displayCharacterData()
		

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.navigationBarHidden = false
		self.navigationController?.navigationBar.topItem?.title = "Characters"
		
		//zeroLabel.text = zeroLabelText
	}
	
	// MARK: Picker conformance
	//MARK: picker conformance
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		return movieCharacters[row].name
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		return movieCharacters.count
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		displayCharacterData()
	}
	
	func displayCharacterData() {
		
		let currentCharacter = movieCharacters[characterPicker.selectedRowInComponent(0)]
		
		self.nameLabel.text = currentCharacter.name
		self.dobLabel.text = currentCharacter.birth_year
		self.homePlanetLabel.text = currentCharacter.homeworld
		self.heightLabel.text = currentCharacter.height.description
		self.hairColorLabel.text = currentCharacter.hair_color
		self.eyeColorLabel.text = currentCharacter.eye_color
	}
	
	func showAlert(title: String, message: String?, style: UIAlertControllerStyle = .Alert) {
		
		let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
		
		let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		
		alertController.addAction(dismissAction)
		
		presentViewController(alertController, animated: true, completion: nil)
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
