//
//  CategoryTableViewCell.swift
//  
//
//  Created by Luis Fernandez on 1/17/16.
//
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    var imageOverlay : UIView?
    
    var categoryTitle : UILabel?
    var categoryNumAvailable : UILabel?
    let staticTextEnd : String = " Services Available Nearby"
    var categoryImage : UIImageView?
    
    var cellData : CategoryCellModel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.redColor()
        
        // Load constratains
//        self.addConstraints()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func loadCellData(cData: CategoryCellModel) {
        
        self.cellData = cData
        
        categoryTitle = UILabel()
        categoryNumAvailable = UILabel()
        categoryImage = UIImageView()
        
        categoryTitle!.text = cellData?.categoryTitle
        categoryTitle!.font = .boldSystemFontOfSize(34)
        categoryTitle!.textColor = .whiteColor()
        categoryTitle?.textAlignment = .Center
        
        categoryNumAvailable!.text = (cellData?.categoryNumAvailable)! + staticTextEnd
        categoryNumAvailable!.font = categoryNumAvailable?.font.fontWithSize(12)
        categoryNumAvailable!.textColor = .whiteColor()
        categoryNumAvailable!.textAlignment = .Center
        
        categoryImage!.image = cellData?.categoryImage
        
        self.addConstraints()
        
    }
    
    private func addConstraints() {
        
        self.categoryNumAvailable!.translatesAutoresizingMaskIntoConstraints = false
        self.categoryImage!.translatesAutoresizingMaskIntoConstraints = false
        self.categoryTitle!.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.categoryImage!)
        self.contentView.addSubview(self.categoryTitle!)
        self.contentView.addSubview(self.categoryNumAvailable!)
        
        // Main image setup
        self.categoryImage?.clipsToBounds = true
        self.categoryImage!.contentMode = .ScaleAspectFill   // Image won't be streched.
        
        let views = [
            "ctImg" : self.categoryImage!,
            "ctTitle" : self.categoryTitle!,
            "ctNumAv" : self.categoryNumAvailable!
        ]
        
        // Image Constraints and Overlay:
        
        let ctImgHorzConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[ctImg]|", options: [], metrics: nil, views: views)
        
        let ctImgVerConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|[ctImg]|", options: [], metrics: nil, views: views)
        
        self.addConstraints(ctImgHorzConstraint)
        self.addConstraints(ctImgVerConstraint)
        
        imageOverlay = UIView(frame: self.frame)
        imageOverlay?.backgroundColor = UIColor.blackColor()
        imageOverlay?.alpha = 0.4
        
        self.categoryImage!.addSubview(self.imageOverlay!)
        
        // Main Title Constraints:
        
        
        let ctTitleCntrYConstraint = NSLayoutConstraint(item: self.categoryTitle!, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0)
        
        let ctTitleHrzConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[ctTitle]|", options: [], metrics: nil, views: views)
        
        self.addConstraint(ctTitleCntrYConstraint)
        self.addConstraints(ctTitleHrzConstraint)
        
        // NumberAvailable Constaints:
        
        let numAvilableBttmConstraint = NSLayoutConstraint(item: self.categoryNumAvailable!, attribute: .BottomMargin, relatedBy: .Equal, toItem: self, attribute: .BottomMargin, multiplier: 1.0, constant: -5)
        let numAvilableCntrXConstraint = NSLayoutConstraint(item: self.categoryNumAvailable!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0)
        self.addConstraints([numAvilableBttmConstraint, numAvilableCntrXConstraint])
        
    }
    
}


