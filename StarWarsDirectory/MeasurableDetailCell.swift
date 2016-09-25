//
//  DetailCell.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 23/09/2016.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

class MeasurableDetailCell: UITableViewCell {

	@IBOutlet weak var keyLabel: UILabel!
	@IBOutlet weak var valueLabel: UILabel!
	@IBOutlet weak var metricButton: UIButton!
	@IBOutlet weak var englishButton: UIButton!
	
	var conversionScale: ConversionScale?
	
	//var measureSystem: MeasureSystem?
	
	var metricValue: Double?
	
	//Initially explicitly set to default API measure system to bypass the init() requirement. Re-evaluated in viewDidLoad according to current locale
	var currentMeasureSystem = MeasureSystem.Metric {
		
		didSet {
			
			setValue()
		}
	}
	
	func localeMeasureSystemSetup() {
		
		if let isMetric = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as? Bool {
			
			currentMeasureSystem = isMetric ? .Metric : .Imperial
			
		} else /*It's extremely unlikely that above binding fails, but still we don't take chances..*/ {
			
			currentMeasureSystem = .Metric //Default API measure system
		}
	}
	
	func handleCurrentMeasureSystem(){
		
		switch currentMeasureSystem {
			
			case .Imperial: imperialSystemSet()
			case .Metric: metricSystemSet()
		}
	}
	
	func setValue() {
		
		if let metricValue = metricValue, scale = conversionScale {
		
			valueLabel.text = Aux.descriptionOfMetric(metricValue, forMeasure: currentMeasureSystem, with: scale)
		}
		
		handleCurrentMeasureSystem()
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
		
	func imperialSystemSet() {
		
		englishButton.enabled = false
		metricButton.enabled = true
	}
	
	func metricSystemSet() {
		
		englishButton.enabled = true
		metricButton.enabled = false
	}

	@IBAction func metricButtonHandler(sender: UIButton) {
		
		currentMeasureSystem = .Metric
	}

	@IBAction func englishButtonHandler(sender: UIButton) {
		
		currentMeasureSystem = .Imperial
	}

}
