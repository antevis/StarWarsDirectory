//
//  UniversalDetailViewController.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 18/09/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit


class UniversalDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MeasureSystemDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
	
	var endPoint: SWEndpoint?
	
	let apiClient = SwapiClient()
	
	@IBOutlet weak var detailsTableView: UITableView!
	@IBOutlet weak var picker: UIPickerView!
	@IBOutlet weak var titleLabel: UILabel!
	
	var i: Int = 0
	
	var starShips: [Starship]?
	
	var currentStarShip: Starship? {
		
		didSet {
			
//			
//			
//			print("\(i)")
//			
//			i += 1
//			
//			setStarshipDataFor(detailsTableView)
			
			titleLabel.text = currentStarShip?.name ?? "Starship"
			
			detailsTableView.reloadData()
		}
	}
	
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
		self.navigationController?.navigationBarHidden = false
		
		self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		
		guard let endPoint = endPoint else {
			
			return
		}
		
		//TODO: Check - probably not needed
		detailsTableView.delegate = self
		detailsTableView.dataSource = self
		
		self.measureSystemDelegate = self
		
		handle(currentMeasureSystem)
		
		picker.delegate = self
		
		
		switch endPoint {
			
			case .Starships(_):
				
				self.navigationController?.navigationBar.topItem?.title = "Starships"
			
				apiClient.fetchStarships() { result in
			
					switch result {
						
						case .Success(let starShips):
							
							self.starShips = starShips.sort { $0.name < $1.name }
							
							self.picker.reloadAllComponents()
							
							self.setCurrentItemFor(self.picker.selectedRowInComponent(0))
						
						case .Failure(let error as NSError):
							
							self.showAlert("Unable to retrieve starships.", message: error.localizedDescription)
							
						default: break
					
					}
				
				}
				
				
			default: break
		}
		
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
	
	//MARK: UITableView conformance
	//TODO: Check - Probably not needed
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if let endPoint = endPoint {
			
			switch endPoint {
				
				case .Starships( _):
					
					let rowCount = currentStarShip?.starShipTableData.count ?? 0
//					
					return max(rowCount - 1, 0)
					
					//return currentStarShip?.starShipTableData.count ?? 0
					
				default: return 0
			}
			
		} else {
			
			return 0
		}
		
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell: DetailCell? = detailsTableView.dequeueReusableCellWithIdentifier("detailCell") as? DetailCell
		
		if let cell = cell, starShip = currentStarShip {
			
			cell.keyLabel.text = starShip.starShipTableData[indexPath.row + 1].key
			cell.valueLabel.text = starShip.starShipTableData[indexPath.row + 1].value
			
//				cell.keyLabel.text = "To be defined"
//				cell.valueLabel.text = "later"
			
			
			return cell
		}
		
		return UITableViewCell()
	}
	
	//MARK: MeasureSystem delegate conformance
	func measureSystemSetTo(measureSystem: MeasureSystem) {
		
//		self.avgHeightLabel.text = currentSpecies?.sizeIn(measureSystem)
	}
	
	func imperialSystemSet() {
		
//		measureSystemControl.selectedSegmentIndex = 1
	}
	
	func metricSystemSet() {
		
//		measureSystemControl.selectedSegmentIndex = 0
	}
	
	//MARK: Picker conformance
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		if let endPoint = endPoint {
			
			switch endPoint {
				
				case .Starships(_):
					
					if let starShips = starShips {
						
						return starShips[row].name
						
					} else {
						
						return "Please wait."
					}
					
				default: return "Please wait."
			}
			
		} else { return "Please wait." }
		
		
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		if let endPoint = endPoint {
			
			switch endPoint {
				
			case .Starships(_):
				
				if let starShips = starShips {
					
					return starShips.count
					
				} else {
					
					return 0
				}
				
			default: return 0
			}
			
		} else { return 0 }
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		let currentIndex = picker.selectedRowInComponent(0)
		
		setCurrentItemFor(currentIndex)
		
	}
	
	func setCurrentItemFor(index: Int) {
		
		guard let endPoint = endPoint else {
			
			return
		}
		
		switch endPoint {
			case .Starships(_):
			
				self.currentStarShip = starShips?[index]
			
			default:
				return
		}
	}
	
//	func setStarshipDataFor(dataTable: UITableView) {
//		
//		guard let currentStarShip = currentStarShip else {
//			
//			return
//		}
//		
//		
//		
//		detailsTableView.reloadData()
//	}
	
		
	
}
