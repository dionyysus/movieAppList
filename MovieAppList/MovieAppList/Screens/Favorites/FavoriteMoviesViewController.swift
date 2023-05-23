//
//  FavoriteMoviesViewController.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 10.05.2023.
//

import UIKit

private extension FavoriteMoviesViewController{
    enum Constant{
        static let heartFilled = "heart-filled"
        static let heart = "heart-movie"
    }
}
class FavoriteMoviesViewController: UIViewController {

    
    @IBOutlet weak var favoriteMoviesCollectionView: UICollectionView!
    
    var movie: Movie?

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
        let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")
        cell.favoriteMovieImageView.loadImg(url: imgFullPath!)
       
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
}

extension FavoriteMoviesViewController: FavoritesCellDelegate{
    func imageViewClicked(indexPath: IndexPath) {
    
        let movie = APIManager.shared.getFavoriteMovies()[indexPath.row]
        APIManager.shared.setFavoriteMovie(movie: movie)
        
        favoriteMoviesCollectionView.reloadData()
        print("ggwp delegate çalışıo \(indexPath.row)")
    }
}

extension FavoriteMoviesViewController: UICollectionViewDelegate{
}
