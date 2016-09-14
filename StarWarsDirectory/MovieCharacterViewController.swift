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
				
					//print("\(self.movieCharacters.count)")
				
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
		
		//zeroLabel.text = zeroLabelText
	}
	
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
