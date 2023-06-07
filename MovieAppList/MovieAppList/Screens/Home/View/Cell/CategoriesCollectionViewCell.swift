//
//  CategoriesCollectionViewCell.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 8.05.2023.
//

import UIKit

protocol CategoriesCellDelegate: AnyObject {
    func labelClicked(indexPath: IndexPath)
}

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoriesCollectionViewCell"

    
    @IBOutlet weak var categoryNameLabel: UILabel!
   
    weak var delegate: CategoriesCellDelegate?
    var indexPath: IndexPath?
    var isSelectedMovie: Bool = false
    var isSelected2: Bool = false {
        didSet {
            categoryNameLabel.highlightedTextColor = isSelected2 ? UIColor.blue : UIColor.clear
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelClicked))
        categoryNameLabel.addGestureRecognizer(tapGesture)
        categoryNameLabel.isUserInteractionEnabled = true

    }
    
    @objc func labelClicked() {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.labelClicked(indexPath: indexPath)
        
    }
    
    func toggleIsSelected() {
        isSelected2.toggle()
    }
}
