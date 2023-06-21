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
    private var favoriteMovies: MovieResponse
    
    var movieId: Int? = 0

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

    @objc private func favoriteTappedImageView() {
        
        if APIManager.shared.setFavoriteMovie(movie: (viewModel?.movie!)!, genre: (viewModel?.firstGenre!)!){
            
            movieFavoriteImageView.image = UIImage(named: Constant.heartFilled)
            
//            let favoriteMovie = Movie(id: selectedMovie.id, title: selectedMovie.title, overview: selectedMovie.overview, posterPath: selectedMovie.posterPath)
//            RealmManager.shared.saveMovie(favoriteMovie)
        }
        else{
            movieFavoriteImageView.image = UIImage(named: Constant.heart)
        }
    }
  
    func prepare(movie: Movie, firstGenre: Genre?) {
        viewModel = DetailViewModel(movie: movie, firstGenre: firstGenre)
    }
    
}

