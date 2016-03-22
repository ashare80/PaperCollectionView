//
//  ViewController.swift
//  PaperView
//
//  Created by Adam Share on 03/19/2016.
//  Copyright (c) 2016 Adam Share. All rights reserved.
//

import UIKit
import PaperCollectionView

let kReuseID = "Cell"

class ViewController: UIViewController, UICollectionViewDataSource, PaperViewDelegate {
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var paperView: PaperView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        paperView.collectionViewController.collectionView?.registerClass(CustomPaperCell.self, forCellWithReuseIdentifier: kReuseID)
        paperView.addShadow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func paperViewHeightDidChange(height: CGFloat, percentMaximized percent: CGFloat) {
        blackView.alpha = percent
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView .dequeueReusableCellWithReuseIdentifier(kReuseID, forIndexPath: indexPath) as! CustomPaperCell
        
        if cell.viewController == nil {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
            cell.delegate = vc
            paperView.collectionViewController.addChildViewController(vc)
            cell.scaledView = vc.view
            vc.didMoveToParentViewController(paperView.collectionViewController)
            cell.viewController = vc
            
            cell.layer.cornerRadius = 4
            cell.clipsToBounds = true
        }
        
        return cell
    }
}

