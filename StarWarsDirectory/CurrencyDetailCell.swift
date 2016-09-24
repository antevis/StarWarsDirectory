//
//  CurrencyDetailCell.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 24/09/2016.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

class CurrencyDetailCell: UITableViewCell {

	@IBOutlet weak var keyLabel: UILabel!
	@IBOutlet weak var valueLabel: UILabel!
	@IBOutlet weak var creditsButton: UIButton!
	@IBOutlet weak var usdButton: UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
