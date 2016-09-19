//
//  PlanetViewController.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 18/09/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

class PlanetViewController: DetailViewController {
	
	var planets: [Planet]?
	var currentPlanet: Planet?
	
	let apiClient = SwapiClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
