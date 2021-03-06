//
//  RootCollectionViewController.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 25/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

private let reuseIdentifier = "RootDataCell"

private let sideMargin: CGFloat = 32
private let edgeInset: CGFloat = 8
private let itemsPerRow: Int = 2

class RootCollectionViewController: UICollectionViewController {
	
	var rootItems = [RootResource]()

	@IBOutlet var cellCollectionView: UICollectionView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		rootItems = getRootItems()
		
		setupCollectionViewCellsFor(cellCollectionView, itemsPerRow: itemsPerRow, verticalEdgeInset: edgeInset, sideMargin: sideMargin)

    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.navigationBarHidden = true
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return rootItems.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RootDataCollectionViewCell
		
		cell.rootItem = rootItems[indexPath.row]
		cell.rootCellButton.tag = indexPath.row
		
		cell.tag = indexPath.row
    
        return cell
    }

	
	// MARK: Aux
	func getRootItems() -> [RootResource] {
		
		var items = [RootResource]()
		
		items.append(RootResource(rootResource: .movies))
		items.append(RootResource(rootResource: .MovieCharacters))
		items.append(RootResource(rootResource: .species))
		items.append(RootResource(rootResource: .starships))
		items.append(RootResource(rootResource: .vehicles))
		items.append(RootResource(rootResource: .planets))
		
		return items
	}
	
	func setupCollectionViewCellsFor(collectionView: UICollectionView, itemsPerRow: Int, verticalEdgeInset: CGFloat, sideMargin: CGFloat) {
		
		let screenWidth = UIScreen.mainScreen().bounds.width
		
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: verticalEdgeInset, left: sideMargin, bottom: verticalEdgeInset, right: sideMargin)
		
		let padding = sideMargin
		
		let width = ((screenWidth - sideMargin * 2 - padding * (CGFloat(itemsPerRow) - 1)) / CGFloat(itemsPerRow))
		
		layout.itemSize = CGSize(width: width, height: width + 48)
		layout.minimumInteritemSpacing = sideMargin
		layout.minimumLineSpacing = sideMargin
		
		collectionView.collectionViewLayout = layout
	}
	
	// MARK: Event Handlers
	@IBAction func rootCellButtonTapped(sender: UIButton) {
		
		let childController = storyboard?.instantiateViewControllerWithIdentifier("UniversalDetailViewController") as? UniversalDetailViewController
		
		switch sender.tag {
			
			case 0:
				
				childController?.endPoint = SWEndpoint.Films(1)

			case 1:
			
				childController?.endPoint = SWEndpoint.Characters(1)
				childController?.scale = ConversionScale.cmToFeetInches
			
			case 2:
			
				childController?.endPoint = SWEndpoint.Species(1)
				childController?.scale = ConversionScale.cmToFeetInches
			
			case 3:
				
				childController?.endPoint = SWEndpoint.Starships(1)
				childController?.scale = ConversionScale.metersToYards

			case 4:
			
				childController?.endPoint = SWEndpoint.Vehicles(1)
				childController?.scale = ConversionScale.metersToYards
			
			case 5:
			
				childController?.endPoint = SWEndpoint.Planets(1)
				childController?.scale = ConversionScale.kmToMiles

			default:
				
				let defaultController = DefaultViewController(nibName: "DefaultViewController", bundle: nil)
			
				defaultController.zeroLabelText = rootItems[sender.tag].resourceUrlString
			
				navigationController?.pushViewController(defaultController, animated: true)
		}
		
		if let controller = childController {
			
			self.navigationController?.pushViewController(controller, animated: true)
			
		} else {
			
			let defaultController = DefaultViewController(nibName: "DefaultViewController", bundle: nil)
			
			defaultController.zeroLabelText = rootItems[sender.tag].resourceUrlString
			
			navigationController?.pushViewController(defaultController, animated: true)
		}
		
	}
	

}
