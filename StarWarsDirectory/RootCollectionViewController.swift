//
//  RootCollectionViewController.swift
//  StarWarsDirectory
//
//  Created by Ivan Kazakov on 25/08/16.
//  Copyright © 2016 Antevis UAB. All rights reserved.
//

import UIKit

private let reuseIdentifier = "RootDataCell"

private let sideMargin: CGFloat = 8
private let edgeInset: CGFloat = 8
private let itemsPerRow: Int = 2

class RootCollectionViewController: UICollectionViewController {
	
	var rootItems = [RootResource]()

	@IBOutlet var cellCollectionView: UICollectionView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//self.navigationController?.navigationBarHidden = true
		
		rootItems = getRootItems()
		
		setupCollectionViewCellsFor(cellCollectionView, itemsPerRow: itemsPerRow, verticalEdgeInset: edgeInset, sideMargin: sideMargin)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.navigationBarHidden = true
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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
    
        // Configure the cell
		
		cell.rootItem = rootItems[indexPath.row]
		cell.rootCellButton.tag = indexPath.row
		
		cell.tag = indexPath.row
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
	
	// MARK: Aux
	func getRootItems() -> [RootResource] {
		
		
		var items = [RootResource]()
		
		items.append(RootResource(resourceName: "films", resourceUrlString: "http://swapi.co/api/films/"))
		items.append(RootResource(resourceName: "people", resourceUrlString: "http://swapi.co/api/people/"))
		items.append(RootResource(resourceName: "planets", resourceUrlString: "http://swapi.co/api/planets/"))
		items.append(RootResource(resourceName: "species", resourceUrlString: "http://swapi.co/api/species/"))
		items.append(RootResource(resourceName: "starships", resourceUrlString: "http://swapi.co/api/starships/"))
		items.append(RootResource(resourceName: "vehicles", resourceUrlString: "http://swapi.co/api/vehicles/"))
		
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
	
//	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//		if segue.identifier == "showDetail" {
////			if let indexPath = self.tableView.indexPathForSelectedRow {
////				//let object = objects[indexPath.row] as! NSDate
////				let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
////				//controller.detailItem = object
////				
////				let venue = venues[indexPath.row]
////				
////				controller.venue = venue
////				
////				controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
////				controller.navigationItem.leftItemsSupplementBackButton = true
////			}
//			
//			print(sender?.tag)
//			
//			guard let cell = sender else {
//				
//				return
//			}
//			
//			switch cell.tag {
//				
//				case 4:
//					
//					let controller = (segue.destinationViewController as! UINavigationController).topViewController as! UniversalDetailViewController
//					
//					controller.endPoint = SWEndpoint.Starships(1)
//					
//				default: return
//			}
//		}
//	}
	
	// MARK: Event Handlers
	
	@IBAction func rootCellButtonTapped(sender: UIButton) {
		
		//var childController: UIViewController?
		
		switch sender.tag {
			
			case 1:
				
				let characterController = MovieCharacterViewController(nibName: "MovieCharacterViewController", bundle: nil)
				//childController = characterController
			
				navigationController?.pushViewController(characterController, animated: true)
			
			
			case 2:
				
				let planetController = PlanetViewController(nibName: "PlanetViewController", bundle: nil)
				//childController = planetController
				navigationController?.pushViewController(planetController, animated: true)
			
			case 3:
				
				let speciesController = SpeciesViewController(nibName: "SpeciesViewController", bundle: nil)
				//childController = speciesController
			
				navigationController?.pushViewController(speciesController, animated: true)
			
			case 4:
				
				//childController = UniversalDetailViewController(nibName: "UniversalDetailViewController", bundle: nil) as UniversalDetailViewController
			
//				let starshipController: UniversalDetailViewController? = UniversalDetailViewController(nibName: "UniversalDetailViewController", bundle: nil) as UniversalDetailViewController
//			
//				starshipController?.endPoint = SWEndpoint.Starships(1)
//				
//				if let starshipController = starshipController {
//			
//					navigationController?.pushViewController(starshipController, animated: true)
			
			
//				}
			
				let starshipsController = storyboard?.instantiateViewControllerWithIdentifier("UniversalDetailViewController") as! UniversalDetailViewController
				
				starshipsController.endPoint = SWEndpoint.Starships(1)
				
				
				
				self.navigationController?.pushViewController(starshipsController, animated: true)
			
		
			default:
				let defaultController = DefaultViewController(nibName: "DefaultViewController", bundle: nil)
			
				defaultController.zeroLabelText = rootItems[sender.tag].resourceUrlString
				
				//childController = defaultController
			
				navigationController?.pushViewController(defaultController, animated: true)
			
		}
		
//		if let vc = childController {
//			
//			navigationController?.pushViewController(vc, animated: true)
//		}
	}
	

}
