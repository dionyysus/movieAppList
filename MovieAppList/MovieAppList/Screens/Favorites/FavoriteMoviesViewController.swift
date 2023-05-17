//
//  FavoriteMoviesViewController.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 10.05.2023.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {

    
    @IBOutlet weak var favoriteMoviesCollectionView: UICollectionView!
    
    let imgUrl = "http://image.tmdb.org/t/p/w500"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"

        let nib = UINib(nibName: FavoritesCollectionViewCell.identifier, bundle: nil)
        favoriteMoviesCollectionView.register(nib, forCellWithReuseIdentifier: FavoritesCollectionViewCell.identifier)
        
        favoriteMoviesCollectionView.delegate = self
        favoriteMoviesCollectionView.dataSource = self

    }
    override func viewWillAppear(_ animated: Bool) {
        favoriteMoviesCollectionView.reloadData()
    }
    
}

extension FavoriteMoviesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return APIManager.shared.getFavoriteMovies().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favorites = APIManager.shared.getFavoriteMovies()[indexPath.row]

        guard let cell = favoriteMoviesCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCollectionViewCell", for: indexPath) as? FavoritesCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.favoriteMovieNameLabel.text = favorites.title
        cell.favoriteVoteLabel.text =  String(favorites.voteAverage ?? 0.0)
        
        
        let imgPosterPath = favorites.posterPath ?? ""
        let imgFullPath = URL(string: "\(imgUrl + imgPosterPath)")
        cell.favoriteMovieImageView.loadImg(url: imgFullPath!)
        
        
        return cell
    }
}

extension FavoriteMoviesViewController: UICollectionViewDelegate{
    
}
