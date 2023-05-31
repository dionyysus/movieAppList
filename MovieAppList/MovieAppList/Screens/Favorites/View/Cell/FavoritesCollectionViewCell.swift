//
//  FavoritesCollectionViewCell.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 10.05.2023.
//

import UIKit

protocol FavoritesCellDelegate: AnyObject {
    func imageViewClicked(indexPath: IndexPath)
}

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FavoritesCollectionViewCell"
    weak var delegate: FavoritesCellDelegate?
    var indexPath: IndexPath?
    
    @IBOutlet weak var favoriteMovieImageView: UIImageView!
    @IBOutlet weak var favoriteMovieNameLabel: UILabel!
    @IBOutlet weak var favoriteCategoryNameLabel: UILabel!
    @IBOutlet weak var favoriteVoteLabel: UILabel!
    @IBOutlet weak var movieRemoveFavoritesImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClicked(tapGestureRecognizer:)))
        movieRemoveFavoritesImageView.isUserInteractionEnabled = true
        movieRemoveFavoritesImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageViewClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.imageViewClicked(indexPath: indexPath)
    }
}
