//
//  DocumentCollectionCell.swift
//  Kargo
//
//  Created by Nicat Guliyev on 9/15/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class DocumentCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var docImage: UIImageView!
    @IBOutlet weak var docNameLbl: UILabel!
    @IBOutlet weak var ImageHeight: NSLayoutConstraint!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
}
