//
//  ScrollStackViewController.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 21/09/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

class ScrollStackViewController: UIViewController {
	
	
	@IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
		
//		let insets = UIEdgeInsetsMake(20, 0, 0, 0)
//		
//		scrollView.contentInset = insets
//		scrollView.scrollIndicatorInsets = insets
		
		
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
