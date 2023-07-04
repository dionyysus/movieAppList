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
        movieDetailCategoryLabel.text = viewModel?.genreName?.components(separatedBy: ",").first
    }
    
    override func viewWillAppear(_ animated: Bool) {
        movieFavoriteImageView.image = isFavorite() ? UIImage(named: Constant.heartFilled) :
        UIImage(named: Constant.heart)
    }
    
    @objc private func favoriteTappedImageView() {
        if let movie = viewModel?.movie {
            movie.genreName = viewModel?.genreName
            let entityMovie = MovieEntity.mapToEntity(model: movie)
            if let movieToDelete = RealmManager.shared.getMovie(withID: entityMovie.id) {
                RealmManager.shared.deleteMovie(movieToDelete)
                movieFavoriteImageView.image = UIImage(named: Constant.heart)
            } else {
                RealmManager.shared.saveMovie(entityMovie)
                movieFavoriteImageView.image = UIImage(named: Constant.heartFilled)
            }
        }
    }
    
    func prepare(movie: Movie, genreName: String) {
        viewModel = DetailViewModel(movie: movie, genreName: genreName)
    }
    
    func isFavorite() -> Bool {
        return RealmManager.shared.getAllMovies().contains(where: { $0.id == viewModel?.movie?.id })
    }
}



