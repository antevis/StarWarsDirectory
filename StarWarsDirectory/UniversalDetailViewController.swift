//
//  UniversalDetailViewController.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 18/09/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

protocol CurrencyRateUpdatedDelegate: class {
	
	func rateUpdatedTo(value: Double)
}


class UniversalDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UsdRatePrompterDelegate {
	
	weak var currencyRateUpdatedDelegate: CurrencyRateUpdatedDelegate?
	
	var endPoint: SWEndpoint?
	
	let apiClient = SwapiClient()
	

	
	
	@IBOutlet weak var detailsTableView: UITableView!
	@IBOutlet weak var picker: UIPickerView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var smallestLabel: UILabel!
	@IBOutlet weak var largestLabel: UILabel!
	
	var i: Int = 0
	
	var items: [SWCategory]?
	var currentItem: SWCategory?
	
	var starShips: [Starship]?
	var vehicles: [Vehicle]?
	
	var currentStarShip: Starship? {
		
		didSet {
			
			titleLabel.text = currentStarShip?.name ?? "Starship"
			
			detailsTableView.reloadData()
		}
	}
	
	
	
	var currentVehicle: Vehicle? {
		
		didSet {
			
			titleLabel.text = currentVehicle?.name ?? "Vehicle"
			
			detailsTableView.reloadData()
		}
	}
	
	//Credits / USD exchange rate
	var crdUsd: Double?
	var currentCurrency: Currency = Currency.GCR
	
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
			
				//apiClient.fetchStarships(endPoint, completion: starShipFetchCompletion)
			
				apiClient.fetchPaginatedResource(endPoint, completion: starShipFetchCompletion)
			
			case .Vehicles(_):
				
				fetchVehicles()
			
			
			default: break
		}
	}
	
	func rateRequired(sender: CurrencyRateUpdatedDelegate) {
		
		promptForCrdUsdRate(sender)
	}
	
	func currencyChangedTo(currency: Currency) {
		
		currentCurrency = currency
	}
	
	func commonTasks<T: SWCategory>(items: [T]) {
		
		self.picker.reloadAllComponents()
		
		self.setCurrentItemFor(self.picker.selectedRowInComponent(0))
		
		self.setMinMaxLabels(items)
	}
	
	func starShipFetchCompletion(result: APIResult<[Starship]>) -> Void {
		
		self.navigationController?.navigationBar.topItem?.title = "Starships"
		
		switch result {
			
			case .Success(let starShips):
				
				
				//TODO: convert to items
				self.starShips = starShips.sort { $0.name < $1.name }
				
				commonTasks(starShips)
				
			case .Failure(let error as NSError):
				
				self.showAlert("Unable to retrieve starships.", message: error.localizedDescription)
				
			default: break
		}
	}
	
//	func fetchStarships() {
//		
//		apiClient.fetchStarships(starShipFetchCompletion)
//
//	}
	
	func fetchVehicles() {
		
		self.navigationController?.navigationBar.topItem?.title = "Vehicles"
		
		apiClient.fetchVehicles() { result in
			
			switch result {
				
			case .Success(let vehicles):
				
				self.vehicles = vehicles.sort { $0.name < $1.name }
				
				self.picker.reloadAllComponents()
				
				self.setCurrentItemFor(self.picker.selectedRowInComponent(0))
				
				//self.setMinMax()
				self.setMinMaxLabels(vehicles)
				
			case .Failure(let error as NSError):
				
				self.showAlert("Unable to retrieve vehicles.", message: error.localizedDescription)
				
			default: break
			}
		}
	}
	
//	func setMinMax() {
//		
//		if let shortestLongest = Aux.getExtremesWithin(starShips) {
//			
//			if let shortest = shortestLongest.min {
//				
//				self.smallestLabel.text = "\(shortest.name): \(shortest.length.description) m"
//			}
//			
//			if let longest = shortestLongest.max {
//				
//				self.largestLabel.text = "\(longest.name): \(longest.length.description) m"
//			}
//		}
//	}
	
	//	func hourly<T: HourlyEmployee>() -> T? {
	//
	//		var entrant: T?
	//
	//		if let employeeData = getEmployeeRelevantData() {
	//
	//			do {
	//
	//				try entrant = T(
	//					fullName: employeeData.dobNameAddress.fullName,
	//					address: employeeData.dobNameAddress.address,
	//					ssn: employeeData.ssn,
	//					birthDate: employeeData.dobNameAddress.birthDate)
	//
	//			} catch EntrantError.FirstNameMissing(let message) {
	//
	//				displayAlert(title: "Error", message: message)
	//
	//			} catch EntrantError.LastNameMissing(let message) {
	//
	//				displayAlert(title: "Error", message: message)
	//
	//			} catch {
	//
	//				fatalError()
	//			}
	//		}
	//
	//		return entrant
	//	}
	
	func setMinMaxLabels<T: SWCategory>(items: [T]?) {
		
		if let shortestLongest = Aux.getExtremesWithin(items) {
			
			if let shortest = shortestLongest.min, size = shortest.size {
				
				self.smallestLabel.text = "\(shortest.name): \(size) m"
			}
			
			if let longest = shortestLongest.max, size = longest.size {
				
				self.largestLabel.text = "\(longest.name): \(size) m"
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
	
	func promptForCrdUsdRate(sender: CurrencyRateUpdatedDelegate) {
		
		let prompt = UIAlertController(title: "X USD per 1 CRD", message: "Please enter the exchange rate:", preferredStyle: .Alert)
		
		let dismissAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
		
		prompt.addAction(dismissAction)
		
		let okAction = UIAlertAction(title: "OK", style: .Default) { _ in
			
			if let textField = prompt.textFields?.first, text = textField.text {
				
				if let crdUsd = Double(text) {
					
					self.crdUsd = crdUsd
					
					self.currencyRateUpdatedDelegate = sender
					
					self.currencyRateUpdatedDelegate?.rateUpdatedTo(crdUsd)
					
					print("\(self.crdUsd)")
					
					self.dismissViewControllerAnimated(true, completion: nil)
				
				} else {
					
					self.showAlert("Error", message: "Exchange rate couldn't be recognized.")
				}
			}
		}
		
		prompt.addTextFieldWithConfigurationHandler { textField in
		
			textField.placeholder = "X USD per 1 CRD"
		}
		
		prompt.addAction(okAction)
		
		presentViewController(prompt, animated: true, completion: nil)
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
					
					return currentStarShip?.tableData.count ?? 0
				
				case .Vehicles(_):
					
					return currentVehicle?.tableData.count ?? 0
				
				default: return 0
			}
			
		} else {
			
			return 0
		}
		
	}
	
//	func hourly<T: HourlyEmployee>() -> T? {
//		
//		var entrant: T?
//		
//		if let employeeData = getEmployeeRelevantData() {
//			
//			do {
//				
//				try entrant = T(
//					fullName: employeeData.dobNameAddress.fullName,
//					address: employeeData.dobNameAddress.address,
//					ssn: employeeData.ssn,
//					birthDate: employeeData.dobNameAddress.birthDate)
//				
//			} catch EntrantError.FirstNameMissing(let message) {
//				
//				displayAlert(title: "Error", message: message)
//				
//			} catch EntrantError.LastNameMissing(let message) {
//				
//				displayAlert(title: "Error", message: message)
//				
//			} catch {
//				
//				fatalError()
//			}
//		}
//		
//		return entrant
//	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		
		guard let starShip = currentStarShip else {
			
			return UITableViewCell()
		}
		
		if starShip.tableData[indexPath.row].convertible {
			
			let cell: CurrencyDetailCell? = detailsTableView.dequeueReusableCellWithIdentifier("currencyDetailCell") as? CurrencyDetailCell
			
			if let cell = cell {
				
				cell.usdRateDelegate = self
				
				cell.crdUsd = self.crdUsd
				
				let stringValue = starShip.tableData[indexPath.row].value
				
				if let value = Double(stringValue) {
					
					cell.costInCrd = value
					
					
				} else {
					
					cell.valueLabel.text = stringValue
				}
				
				cell.keyLabel.text = starShip.tableData[indexPath.row].key
				
				cell.usdButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
				cell.creditsButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
				
				cell.currentCurrency = self.currentCurrency//Currency.GCR //Set default currency to galactic credits
				
				return cell
			}
		
		} else if let scale = starShip.tableData[indexPath.row].scale {
			
			let cell: MeasurableDetailCell? = detailsTableView.dequeueReusableCellWithIdentifier("measureDetailCell") as? MeasurableDetailCell
			
			if let cell = cell {
				
				cell.keyLabel.text = starShip.tableData[indexPath.row].key
				
				cell.conversionScale = scale
				
				let value = starShip.tableData[indexPath.row].value
				
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
				
				cell.keyLabel.text = starShip.tableData[indexPath.row].key
				cell.valueLabel.text = starShip.tableData[indexPath.row].value
				
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
					
					//TODO: Convert to items
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
				
				//TODO: Convert to items
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
			
				//TODO: Convert to items
				self.currentStarShip = starShips?[index]
			
			default:
				return
		}
	}

	
}
