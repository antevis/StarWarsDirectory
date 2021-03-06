//
//  CurrencyDetailCell.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 24/09/2016.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

protocol UsdRatePrompterDelegate: class {
	
	func rateRequired(sender: CurrencyRateUpdatedDelegate)
	func currencyChangedTo(currency: Currency)
}


class CurrencyDetailCell: UITableViewCell, CurrencyRateUpdatedDelegate {

	@IBOutlet weak var keyLabel: UILabel!
	@IBOutlet weak var valueLabel: UILabel!
	@IBOutlet weak var creditsButton: UIButton!
	@IBOutlet weak var usdButton: UIButton!
	
	weak var usdRateDelegate: UsdRatePrompterDelegate?
	
	var crdUsd: Double?
	
	var costInCrd: Double?
	
	var changeToUsdRequested: Bool = false
	
	var currentCurrency = Currency.Credits {
		
		didSet {
			
			setValue()
			
			usdRateDelegate?.currencyChangedTo(currentCurrency)
		}
	}
	
	func rateUpdatedTo(value: Double) {
		
		crdUsd = value
		
		if changeToUsdRequested {
			
			currentCurrency = .USD
			
			changeToUsdRequested = false
		}
	}
	
	func setValue() {
		
		if let costInCrd = costInCrd {
			
			switch currentCurrency {
				
				case .Credits:
				
					valueLabel.text = Aux.descriptionOfCredits(costInCrd, forCurrency: currentCurrency, with: 1)
				
				case .USD:
				
					if let crdUsdRate = crdUsd {
						
						valueLabel.text = Aux.descriptionOfCredits(costInCrd, forCurrency: currentCurrency, with: crdUsdRate)
					
					} else {
						
						//Rate missing
						usdRateDelegate?.rateRequired(self)
					}
			}
		}
		
		handleCurrentCurrency()
	}
	
	func handleCurrentCurrency() {
		
		switch currentCurrency {
			
			case .Credits:
				galacticCreditsSet()
			
			default:
				usDollarsSet()
		}
	}
	
	func galacticCreditsSet() {
		
		creditsButton.enabled = false
		usdButton.enabled = true
	}
	
	func usDollarsSet() {
		
		creditsButton.enabled = true
		usdButton.enabled = false
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setCurrencyRateTo(rate: Double) {
		
		self.crdUsd = rate
	}
	
	@IBAction func convertToCrd(sender: UIButton) {
		
		currentCurrency = Currency.Credits
		
		
	}
	
	@IBAction func convertToUsd(sender: UIButton) {
		
		if crdUsd != nil {
		
			currentCurrency = Currency.USD
			
			
		
		} else {
			
			//rate missing
			
			changeToUsdRequested = true
			
			usdRateDelegate?.rateRequired(self)
		}
		
		
	}
	
	
}
