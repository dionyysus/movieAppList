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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
