//
//  RootDataCollectionViewCell.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 25/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

class RootDataCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var rootCellButton: UIButton!
	@IBOutlet weak var rootCellLabel: UILabel!
	
	var rootItem: RootResource? {
		
		didSet {
			
			rootCellLabel.text = rootItem?.resourceTitle
			rootCellButton.setImage(rootItem?.icon, forState: .Normal)
			
			let insets = rootCellButton.imageEdgeInsets
			
			print("top:\(insets.top), right: \(insets.right), bottom: \(insets.bottom), left: \(insets.left)")
		}
	}
    
}
