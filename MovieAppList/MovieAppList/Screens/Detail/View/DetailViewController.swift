//
//  DetailViewController.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 28.04.2023.
//

import UIKit

private extension DetailViewController{
    enum Constant{
        static let heartFilled = "heart-filled"
        static let heart = "heart-movie"
    }
}

class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModel?
    
    var movieId: Int? = 0
    let favoriteMovies = RealmManager.shared.getAllMovies()
    
    @IBOutlet weak var movieDetailNameLabel: UILabel!
    @IBOutlet weak var movieDetailImageView: UIImageView!
    @IBOutlet weak var movieDetailCategoryLabel: UILabel!
    @IBOutlet weak var movieVoteLabel: UILabel!
    @IBOutlet weak var movieDetailDescriptionLabel: UILabel!
    @IBOutlet weak var movieFavoriteImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel?.movie?.title
        
        let tapFavorite = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.favoriteTappedImageView))
        
        movieFavoriteImageView.addGestureRecognizer(tapFavorite)
        movieFavoriteImageView.isUserInteractionEnabled = true
        
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        movieDetailNameLabel.text = viewModel?.movie?.title
        
        movieVoteLabel.text = String(viewModel?.movie?.voteAverage ?? 0.0)
        
        let imgPosterPath = viewModel?.movie?.posterPath ?? ""
        let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")
        movieDetailImageView.loadImg(url: imgFullPath!)
        
        movieDetailDescriptionLabel.text = viewModel?.movie?.overview
        movieDetailCategoryLabel.text = viewModel?.firstGenre?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        RealmManager.shared.updateMovieProperty(movie: (viewModel?.movie)!, newValue: viewModel?.firstGenre)
        //viewModel?.movie?.firstGenre = viewModel?.firstGenre
        movieFavoriteImageView.image = isFavorite() ? UIImage(named: Constant.heartFilled) :
        UIImage(named: Constant.heart)
        
    }
    
    @objc private func favoriteTappedImageView() {
        let _ = RealmManager.shared
        let favoriteMovies = RealmManager.shared.getAllMovies()
        if favoriteMovies.contains(where: { $0.id == viewModel?.movie?.id }) {
            RealmManager.shared.deleteMovie((viewModel?.movie)!)
            movieFavoriteImageView.image = UIImage(named: Constant.heart)
        } else {
            RealmManager.shared.saveMovie((viewModel?.movie)!)
            movieFavoriteImageView.image = UIImage(named: Constant.heartFilled)
        }
    }
    
    func prepare(movie: Movie, firstGenre: Genre?) {
        viewModel = DetailViewModel(movie: movie, firstGenre: firstGenre)
    }
    
    func isFavorite() -> Bool {
        return favoriteMovies.contains(where: { $0.id == viewModel?.movie?.id })
    }
    
}


