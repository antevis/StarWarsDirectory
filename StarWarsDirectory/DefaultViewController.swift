//
//  DefaultViewController.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 25/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

class DefaultViewController: UIViewController {

	@IBOutlet weak var zeroLabel: UILabel!
	
	var zeroLabelText: String?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.navigationBarHidden = false
		
		zeroLabel.text = zeroLabelText
	}

	

}
