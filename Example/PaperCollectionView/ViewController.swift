//
//  ViewController.swift
//  PaperView
//
//  Created by Adam Share on 03/19/2016.
//  Copyright (c) 2016 Adam Share. All rights reserved.
//

import UIKit
import PaperCollectionView

class ViewController: UIViewController, UICollectionViewDataSource, PaperCellChangeDelegate {
    
    @IBOutlet weak var paperView: PaperView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        Available as IBOutlet
//        paperView.delegate = self
//        paperView.datasource = self
        
        paperView.collectionViewController.collectionView?.registerClass(CustomPaperCell.self, forCellWithReuseIdentifier: "Cell")
        paperView.addShadow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView .dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomPaperCell
        
        if cell.viewController == nil {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
            paperView.collectionViewController.addChildViewController(vc)
            cell.scaledView = vc.view
            vc.didMoveToParentViewController(paperView.collectionViewController)
            cell.viewController = vc
        }
        
        return cell
    }
}

