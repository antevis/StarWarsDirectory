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
	
	var itemCount: Int?
	var currentItem: SWCategoryType? {
		
		didSet {
			
			titleLabel.text = currentItem?.name ?? "Item"
			
			detailsTableView.reloadData()
		}
	}
	
	var starShips: [Starship]?
	var vehicles: [Vehicle]?
	var films: [Film]?
	var people: [MovieCharacter]?
	var planets: [Planet]?
	var species: [Species]?
	
	var scale: ConversionScale?
	
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
			
				apiClient.fetchPaginatedResource(endPoint, completion: starShipFetchCompletion)
			
			case .Vehicles(_):
				
				apiClient.fetchPaginatedResource(endPoint, completion: vehicleFetchCompletion)
			
			case .Films:
				
				apiClient.fetchPaginatedResource(endPoint, completion: filmsFetchCompletion)
			
			case .Characters(_):
				
				apiClient.fetchPaginatedResource(endPoint, completion: peopleFetchCompletion)
				
			case .Planets(_):
				
				apiClient.fetchPaginatedResource(endPoint, completion: planetFetchCompletion)
				
			case .Species(_):
				
				apiClient.fetchPaginatedResource(endPoint, completion: speciesFetchCompletion)
		}
	}
	
	func rateRequired(sender: CurrencyRateUpdatedDelegate) {
		
		promptForCrdUsdRate(sender)
	}
	
	func currencyChangedTo(currency: Currency) {
		
		currentCurrency = currency
	}
	
	func commonTasks<T: SWCategoryType>(items: [T]) {
		
		self.setCurrentItemFor(self.picker.selectedRowInComponent(0))
		
		self.setMinMaxLabels(items)
		
		self.itemCount = items.count
		
		self.picker.reloadAllComponents()
	}
	
	//MARK: 6 completion methods represent an ugly and embarassing redundancy which I've failed to avoid.
	func starShipFetchCompletion(result: APIResult<[Starship]>) -> Void {
		
		switch result {
			
			case .Success(let items):
				
				let categoryTtitle = items.first?.categoryTitle ?? ""
				
				self.navigationController?.navigationBar.topItem?.title = categoryTtitle
				
				self.starShips = items.sort { $0.name < $1.name }
				
				self.commonTasks(items)
				
			case .Failure(let error as NSError):
				
				self.showAlert("Unable to retrieve items.", message: error.localizedDescription)
				
			default: break
		}
	}
	
	func vehicleFetchCompletion(result: APIResult<[Vehicle]>) -> Void {
		
		switch result {
			
			case .Success(let items):
				
				let categoryTtitle = items.first?.categoryTitle ?? ""
				
				self.navigationController?.navigationBar.topItem?.title = categoryTtitle
				
				self.vehicles = items.sort { $0.name < $1.name }
				
				self.commonTasks(items)
				
			case .Failure(let error as NSError):
				
				self.showAlert("Unable to retrieve items.", message: error.localizedDescription)
				
			default: break
		}
	}
	
	func filmsFetchCompletion(result: APIResult<[Film]>) -> Void {
		
		switch result {
			
			case .Success(let items):
				
				let categoryTtitle = items.first?.categoryTitle ?? ""
				
				self.navigationController?.navigationBar.topItem?.title = categoryTtitle
				
				self.films = items.sort { $0.episode_id < $1.episode_id }
				
				self.commonTasks(items)
				
			case .Failure(let error as NSError):
				
				self.showAlert("Unable to retrieve items.", message: error.localizedDescription)
				
			default: break
		}
	}
	
	func peopleFetchCompletion(result: APIResult<[MovieCharacter]>) -> Void {
		
		switch result {
			
			case .Success(let items):
				
				let categoryTtitle = items.first?.categoryTitle ?? ""
				
				self.navigationController?.navigationBar.topItem?.title = categoryTtitle
				
				self.people = items.sort { $0.name < $1.name }
				
				self.commonTasks(items)
				
			case .Failure(let error as NSError):
				
				self.showAlert("Unable to retrieve items.", message: error.localizedDescription)
				
			default: break
		}
	}
	
	func planetFetchCompletion(result: APIResult<[Planet]>) -> Void {
		
		switch result {
			
			case .Success(let items):
				
				let categoryTtitle = items.first?.categoryTitle ?? ""
				
				self.navigationController?.navigationBar.topItem?.title = categoryTtitle
				
				self.planets = items.sort { $0.name < $1.name }
				
				self.commonTasks(items)
				
			case .Failure(let error as NSError):
				
				self.showAlert("Unable to retrieve items.", message: error.localizedDescription)
				
			default: break
		}
	}
	
	func speciesFetchCompletion(result: APIResult<[Species]>) -> Void {
		
		switch result {
			
			case .Success(let items):
				
				let categoryTtitle = items.first?.categoryTitle ?? ""
				
				self.navigationController?.navigationBar.topItem?.title = categoryTtitle
				
				self.species = items.sort { $0.name < $1.name }
				
				self.commonTasks(items)
				
			case .Failure(let error as NSError):
				
				self.showAlert("Unable to retrieve items.", message: error.localizedDescription)
				
			default: break
		}
	}
	
	
	
	func setMinMaxLabels<T: SWCategoryType>(items: [T]?) {
		
		if let shortestLongest = Aux.getExtremesWithin(items) {
			
			var sizeDescription: String
			
			if let shortest = shortestLongest.min, size = shortest.size {
				
				sizeDescription = Aux.currentLocaleDescriptionOfMetric(size, with: scale)
				
				self.smallestLabel.text = "\(shortest.name): \(sizeDescription)"
			}
			
			if let longest = shortestLongest.max, size = longest.size {
				
				sizeDescription = Aux.currentLocaleDescriptionOfMetric(size, with: scale)
				
				self.largestLabel.text = "\(longest.name): \(sizeDescription)"
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
		
		return currentItem?.tableData.count ?? 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		guard let currentItem = currentItem else {
			
			return UITableViewCell()
		}
		
		if currentItem.tableData[indexPath.row].convertible {
			
			let cell: CurrencyDetailCell? = detailsTableView.dequeueReusableCellWithIdentifier("currencyDetailCell") as? CurrencyDetailCell
			
			if let cell = cell {
				
				cell.usdRateDelegate = self
				
				cell.crdUsd = self.crdUsd
				
				let stringValue = currentItem.tableData[indexPath.row].value
				
				if let value = Double(stringValue) {
					
					cell.costInCrd = value
					
					
				} else {
					
					cell.valueLabel.text = stringValue
				}
				
				cell.keyLabel.text = currentItem.tableData[indexPath.row].key
				
				cell.usdButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
				cell.creditsButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
				
				cell.currentCurrency = self.currentCurrency//Currency.GCR //Set default currency to galactic credits
				
				return cell
			}
		
		} else if let scale = currentItem.tableData[indexPath.row].scale {
			
			let cell: MeasurableDetailCell? = detailsTableView.dequeueReusableCellWithIdentifier("measureDetailCell") as? MeasurableDetailCell
			
			if let cell = cell {
				
				cell.keyLabel.text = currentItem.tableData[indexPath.row].key
				
				cell.conversionScale = scale
				
				let value = currentItem.tableData[indexPath.row].value
				
				//let doubleValue: Double? = Double(value)
				
				if let doubleValue = Double(value) {
					
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
				
				cell.keyLabel.text = currentItem.tableData[indexPath.row].key
				
				guard let endPoint = self.endPoint else {
					
					return cell
				}
				
				switch endPoint {
					
					case .Characters(_):
						
						//A bit stringy, but ok for one particular case
						if cell.keyLabel.text == "Home" {
						
							cell.valueLabel.text = planetForCharacterAt(self.picker.selectedRowInComponent(0))
							
						} else {
							
							cell.valueLabel.text = currentItem.tableData[indexPath.row].value
						}
					
					default: cell.valueLabel.text = currentItem.tableData[indexPath.row].value
				}
				
				return cell
			}
		}
		
		return UITableViewCell()
	}
	
	//Method performs 2 tasks: sets planet instance for current MovieCharacter and returns planet name
	func planetForCharacterAt(index: Int) -> String? {
		
		if let planet = people?[index].homePlanet {
			
			//If planet has already been pulled before, use it instead of recurrent quering the API
			return planet.name
			
		} else {
			
			if let planetUrl = people?[index].homeWorldUrl {
				
				apiClient.fetchPlanet(planetUrl) { result in
					
					switch result {
						
						case .Success(let planet):
							
							self.people?[index].homePlanet = planet
							
							
							//If the same character is still selected upon completion
							if self.picker.selectedRowInComponent(0) == index {
								
								self.detailsTableView.reloadData()
							}
							
						default: break
					}
				}
				
			} else {
				
				return nil
			}
		}
		
		return nil
	}
	
	func setCurrentItemFor(index: Int) {
		
		guard let endPoint = endPoint else {
			
			return
		}
		
		//Echo of above-mentioned embarassment
		switch endPoint {
			
			case .Starships(_):
				
				self.currentItem = starShips?[index]
				
			case .Vehicles(_):
				
				self.currentItem = vehicles?[index]
				
			case .Films:
				
				self.currentItem = films?[index]
			
			case .Characters(_):
				
				self.currentItem = people?[index]
				
			case .Planets(_):
				
				self.currentItem = planets?[index]
				
			case .Species(_):
				
				self.currentItem = species?[index]
			
//			default:
//				return
		}
	}
	
	
	//MARK: Picker conformance
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		if let endPoint = endPoint {
			
			//Echo of abobe-mentioned embarassment, part 2
			switch endPoint {
				
				case .Starships(_):
					
					//if let starShips = starShips {
						
						return starShips?[row].name ?? "Please wait."
						
//					} else {
//						
//						return "Please wait."
//					}
				
				case .Vehicles(_):
					
//					if let vehicles	= vehicles {
					
						return vehicles?[row].name ?? "Please wait."
						
//					} else {
//						
//						return "Please wait."
//					}
				
				case .Films:
					
					//if let films = films {
						
						return films?[row].name ?? "Please wait."
						
//					} else {
//						
//						return "Please wait."
//				}
				
				case .Characters(_):
				
//					if let people = people {
					
						return people?[row].name ?? "Please wait."
				
//					} else {
//						
//						return "Please wait."
//					}
				
			case .Planets(_):
				
				return planets?[row].name ?? "Please wait."
				
			case .Species(_):
				
				return species?[row].name ?? "Please wait."
			
				
//				default: return "Please wait."
			}
			
		} else { return "Please wait." }
		
		
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		return self.itemCount ?? 0
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		let currentIndex = picker.selectedRowInComponent(0)
		
		setCurrentItemFor(currentIndex)
		
	}
	
	

	
}
