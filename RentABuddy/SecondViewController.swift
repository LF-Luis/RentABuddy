//
//  SecondViewController.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 12/29/15.
//  Copyright © 2015 Luis Fernandez. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout().self
        
        flowLayout.itemSize = self.view.frame.size
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        
        collectionView.alwaysBounceVertical = true
        
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.dataSource = self
        
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 250)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }

}



extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
    
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    /**
     For one or multiple views, set translatesAutoresizingMaskIntoConstraints to false.
     
     -Author:
     Luis Fernandez
     
     -Returns:
     Your view with translatesAutoresizingMaskIntoConstraints set to false.
     
     -Parameters:
     One or multiple views.
     */
    
    func setTranslatesAutoresizingMaskIntoConstraintsFalse(views: UIView...) {
        for viewI in views {
            viewI.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func addMultipleSubviews(views: UIView...) {
        for viewI in views {
            addSubview(viewI)
        }
    }
    
}

class FeedCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var profileImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TestPhoto")
        
        // Add Frame to pic, with rounded corners
        imageView.layer.cornerRadius =  10.0 //profilePic.frame.size.width / 2  // Circular pic
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Luis F.", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(18)])
        label.attributedText = attributedText
        return label
    }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.text = "$25 / hr"
        label.font = label.font.fontWithSize(18)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Mechanical Engineering", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(28)])
        label.attributedText = attributedText
        label.textAlignment = .Center
        return label
    }()
    
    let serviceImg: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blueColor()
        imageView.image = UIImage(named: "TestPhoto")
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    let imageOverlay: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blackColor()
//        imageView.alpha = 0.4
        imageView.image = UIImage(named: "TestPhoto")
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.frame.size.height = 100
        view.backgroundColor = UIColor.blackColor()
        //        view.backgroundColor = UIColor.rgb(226, green: 228, blue: 232)
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .Center
        label.text = "A mechanical engineering is the discipline that applies the principles of engineering, physics, and materials science for the design, analysis, manufacturing, and maintenance of mechanical systems. It is the branch of engineering that involves the design, production, and operation of machinery. It is one of the oldest and broadest of the engineering disciplines."
        return label
    }()
    
    func setUpViews() {
        
        backgroundColor = .whiteColor()
        
        let profPicSize = currentScreenWidth * (0.2)
        
        setTranslatesAutoresizingMaskIntoConstraintsFalse(serviceImg, imageOverlay, userNameLabel, profileImg, costLabel, titleLabel, dividerLineView, descriptionLabel)
        
        contentView.addMultipleSubviews(serviceImg, imageOverlay, userNameLabel, profileImg, costLabel,titleLabel, dividerLineView, descriptionLabel)

        let uPS = 50
        let rPS = uPS / 4
     
        addConstraintsWithFormat("H:|[v0]|", views: serviceImg)
        addConstraintsWithFormat("H:|[v0]|", views: imageOverlay)
        addConstraintsWithFormat("H:|-10-[v0(\(profPicSize))]-10-[v1]", views: profileImg, userNameLabel)
        addConstraintsWithFormat("H:|-10-[v0]", views: costLabel)
        addConstraintsWithFormat("H:|[v0]|", views: titleLabel)
        addConstraintsWithFormat("H:|[v0]|", views: dividerLineView)
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: descriptionLabel)
        
        addConstraintsWithFormat("V:|-10-[v0]-10-[v1]-20-|", views: userNameLabel, serviceImg)
        addConstraintsWithFormat("V:|-10-[v0(\(profPicSize))]", views: profileImg)
        addConstraintsWithFormat("V:[v0]-10-|", views: costLabel)
        
//        NSLayoutAttribute.
        
        let overlayTop = NSLayoutConstraint(item: imageOverlay, attribute: .Top, relatedBy: .Equal, toItem: serviceImg, attribute: .Top, multiplier: 1.0, constant: 0)
        let OverlayBottom = NSLayoutConstraint(item: imageOverlay, attribute: .Bottom, relatedBy: .Equal, toItem: serviceImg, attribute: .Bottom, multiplier: 1.0, constant: 0)
        addConstraints([overlayTop, OverlayBottom])
        
    }
    
}