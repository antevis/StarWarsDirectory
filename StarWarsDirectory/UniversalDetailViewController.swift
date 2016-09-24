//
//  UniversalDetailViewController.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 18/09/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit


class UniversalDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
	
	var endPoint: SWEndpoint?
	
	let apiClient = SwapiClient()
	
	@IBOutlet weak var detailsTableView: UITableView!
	@IBOutlet weak var picker: UIPickerView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var smallestLabel: UILabel!
	@IBOutlet weak var largestLabel: UILabel!
	
	var i: Int = 0
	
	var starShips: [Starship]?
	
	var currentStarShip: Starship? {
		
		didSet {
			
			titleLabel.text = currentStarShip?.name ?? "Starship"
			
			detailsTableView.reloadData()
		}
	}
	
	var crdUsd: Double?
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		//localeMeasureSystemSetup()
		
		// Status bar white font
		self.navigationController?.navigationBarHidden = false
		self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		
		guard let endPoint = endPoint else {
			
			return
		}
		
		detailsTableView.dataSource = self
		picker.delegate = self
		
		switch endPoint {
			
			case .Starships(_):
			
				fetchStarships()
			
			default: break
		}
		
	}
	
	func fetchStarships() {
		
		self.navigationController?.navigationBar.topItem?.title = "Starships"
		
		apiClient.fetchStarships() { result in
			
			switch result {
				
				case .Success(let starShips):
					
					self.starShips = starShips.sort { $0.name < $1.name }
					
					self.picker.reloadAllComponents()
					
					self.setCurrentItemFor(self.picker.selectedRowInComponent(0))
				
					self.setMinMax()
					
				case .Failure(let error as NSError):
					
					self.showAlert("Unable to retrieve starships.", message: error.localizedDescription)
					
				default: break
			}
			
		}
	}
	
	func setMinMax() {
		
		if let shortestLongest = Aux.getExtremesWithin(starShips) {
			
			if let shortest = shortestLongest.min {
				
				self.smallestLabel.text = "\(shortest.name): \(shortest.length.description) m"
			}
			
			if let longest = shortestLongest.max {
				
				self.largestLabel.text = "\(longest.name): \(longest.length.description) m"
			}
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
					
					return currentStarShip?.starShipTableData.count ?? 0
					
				default: return 0
			}
			
		} else {
			
			return 0
		}
		
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		guard let starShip = currentStarShip else {
			
			return UITableViewCell()
		}
		
		if starShip.starShipTableData[indexPath.row].convertible {
			
			let cell: CurrencyDetailCell? = detailsTableView.dequeueReusableCellWithIdentifier("currencyDetailCell") as? CurrencyDetailCell
			
			if let cell = cell {
				
				cell.keyLabel.text = starShip.starShipTableData[indexPath.row].key
				cell.valueLabel.text = starShip.starShipTableData[indexPath.row].value
				
				return cell
			}
		
		} else if let scale = starShip.starShipTableData[indexPath.row].scale {
			
			let cell: MeasurableDetailCell? = detailsTableView.dequeueReusableCellWithIdentifier("measureDetailCell") as? MeasurableDetailCell
			
			if let cell = cell {
				
				cell.keyLabel.text = starShip.starShipTableData[indexPath.row].key
				
				cell.conversionScale = scale
				
				let value = starShip.starShipTableData[indexPath.row].value
				
				let doubleValue: Double? = Double(value)
				
				if let doubleValue = doubleValue {
					
					cell.metricValue = doubleValue
					
				} else {
					
					cell.valueLabel.text = value
				}
				
				cell.englishButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
				cell.metricButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
				
				cell.localeMeasureSystemSetup()
				
				return cell
			}
		
		} else {
			
			let cell: DetailCell? = detailsTableView.dequeueReusableCellWithIdentifier("detailCell") as? DetailCell
			
			if let cell = cell {
				
				cell.keyLabel.text = starShip.starShipTableData[indexPath.row].key
				cell.valueLabel.text = starShip.starShipTableData[indexPath.row].value
				
				return cell
			}
		}
		
		return UITableViewCell()
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
	
}
