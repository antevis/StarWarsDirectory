//
//  DetailViewController.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 18/09/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

protocol MeasureSystemDelegate: class {
	
	func measureSystemSetTo(measureSystem: MeasureSystem)
	
	func imperialSystemSet()
	func metricSystemSet()
}


class DetailViewController: UIViewController {
	
	weak var measureSystemDelegate: MeasureSystemDelegate?
	
	//Initially explicitly set to default API measure system to bypass the init() requirement. Re-evaluated in viewDidLoad according to current locale
	var currentMeasureSystem = MeasureSystem.Metric {
		
		didSet {
			
			measureSystemDelegate?.measureSystemSetTo(currentMeasureSystem)
			
			handle(currentMeasureSystem)
		}
	}
	
	func handle(measureSystem: MeasureSystem){
		
		switch measureSystem {
			
			case .Imperial: measureSystemDelegate?.imperialSystemSet()
			case .Metric: measureSystemDelegate?.metricSystemSet()
		}
	}
	
	
	func localeMeasureSystemSetup() {
		
		if let isMetric = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as? Bool {
			
			currentMeasureSystem = isMetric ? .Metric : .Imperial
			
		} else /*It's extremely unlikely that above binding fails, but still we don't take chances..*/ {
			
			currentMeasureSystem = .Metric //Default API measure system
		}
	}

    override func viewDidLoad() {
		
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		localeMeasureSystemSetup()
		
		// Status bar white font
		self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
