//
//  DetailCell.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 23/09/2016.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

	@IBOutlet weak var keyLabel: UILabel!
	@IBOutlet weak var valueLabel: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
