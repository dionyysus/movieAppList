//
//  FavoritesCollectionViewCell.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 10.05.2023.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FavoritesCollectionViewCell"

    @IBOutlet weak var favoriteMovieImageView: UIImageView!
    @IBOutlet weak var favoriteMovieNameLabel: UILabel!
    @IBOutlet weak var favoriteCategoryNameLabel: UILabel!
    @IBOutlet weak var favoriteVoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
