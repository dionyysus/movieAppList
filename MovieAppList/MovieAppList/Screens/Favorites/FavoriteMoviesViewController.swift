//
//  FavoriteMoviesViewController.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 10.05.2023.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {

    
    @IBOutlet weak var favoriteMoviesCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"

        let nib = UINib(nibName: FavoritesCollectionViewCell.identifier, bundle: nil)
        favoriteMoviesCollectionView.register(nib, forCellWithReuseIdentifier: FavoritesCollectionViewCell.identifier)
        
        favoriteMoviesCollectionView.delegate = self
        favoriteMoviesCollectionView.dataSource = self

    }
    
}

extension FavoriteMoviesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = favoriteMoviesCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCollectionViewCell", for: indexPath) as? FavoritesCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.favoriteMovieNameLabel.text = "test"
        return cell
    }
    
    
}

extension FavoriteMoviesViewController: UICollectionViewDelegate{
    
}
