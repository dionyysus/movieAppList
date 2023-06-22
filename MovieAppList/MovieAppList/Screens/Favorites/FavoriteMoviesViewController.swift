//
//  FavoriteMoviesViewController.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 10.05.2023.
//

import UIKit
import RealmSwift

private extension FavoriteMoviesViewController{
    enum Constant{
        static let heartFilled = "heart-filled"
        static let heart = "heart-movie"
    }
}
class FavoriteMoviesViewController: UIViewController {

    @IBOutlet weak var favoriteMoviesCollectionView: UICollectionView!
    
    private var viewModel: FavoriteViewModel?

    lazy var favoriteLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.center = self.view.center
        label.textAlignment = .center
        label.text = "There isn't anything here"
        label.backgroundColor = UIColor.lightGray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FavoriteViewModel()

        title = "Favorites"
         
        let nib = UINib(nibName: FavoritesCollectionViewCell.identifier, bundle: nil)
        favoriteMoviesCollectionView.register(nib, forCellWithReuseIdentifier: FavoritesCollectionViewCell.identifier)

        favoriteMoviesCollectionView.delegate = self
        favoriteMoviesCollectionView.dataSource = self
        addFavoriteLabel()
    }

    private func addFavoriteLabel() {
        self.view.addSubview(favoriteLabel)
    }

    override func viewWillAppear(_ animated: Bool) {
        favoriteMoviesCollectionView.reloadData()
        favoriteLabel.isHidden = RealmManager.shared.getAllMovies().count != 0
    }
    
    override func viewDidLayoutSubviews() {
        favoriteLabel.layer.cornerRadius = 15.0
        favoriteLabel.layer.borderWidth = 3.0
    }

}

extension FavoriteMoviesViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == favoriteMoviesCollectionView {
            
            let storyBoard = UIStoryboard(name: "Detail", bundle: nil)
            let gotoDetailController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            let movie = RealmManager.shared.getAllMovies()[indexPath.row]
            let firstGenre = movie.firstGenre
            
            gotoDetailController.movieId = indexPath.row
            gotoDetailController.prepare(movie: movie, firstGenre: firstGenre)
            print(viewModel?.firstGenre ?? 0)
            navigationController?.pushViewController(gotoDetailController, animated: true)
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RealmManager.shared.getAllMovies().count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favorites = RealmManager.shared.getAllMovies()[indexPath.row]
        //let categories = APIManager.shared.getCategoryMovies()[indexPath.row]
        guard let cell = favoriteMoviesCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCollectionViewCell", for: indexPath) as? FavoritesCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.favoriteMovieNameLabel.text = favorites.title
        cell.favoriteVoteLabel.text =  String(favorites.voteAverage ?? 0.0)
        
        let imgPosterPath = favorites.posterPath ?? ""
        let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")
        cell.favoriteMovieImageView.loadImg(url: imgFullPath!)
        cell.favoriteCategoryNameLabel.text = favorites.firstGenre?.name
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
}

extension FavoriteMoviesViewController: FavoritesCellDelegate{
    func imageViewClicked(indexPath: IndexPath) {
        let movie = RealmManager.shared.getAllMovies()[indexPath.row]
        RealmManager.shared.deleteMovie(movie)
        favoriteMoviesCollectionView.reloadData()
    }
}
extension FavoriteMoviesViewController: UICollectionViewDelegate{
    
}

