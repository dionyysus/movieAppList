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

    let imgUrl = "http://image.tmdb.org/t/p/w500"

    @IBOutlet weak var movieDetailNameLabel: UILabel!
    @IBOutlet weak var movieDetailImageView: UIImageView!
    @IBOutlet weak var movieDetailCategoryLabel: UILabel!
    @IBOutlet weak var movieVoteLabel: UILabel!
    @IBOutlet weak var movieDetailDescriptionLabel: UILabel!
    
    var movie: Movie?
    
    var movieId: Int? = 0
    
    @IBOutlet weak var movieFavoriteImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapFavorite = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.favoriteTappedImageView))

        
        movieFavoriteImageView.addGestureRecognizer(tapFavorite)
        movieFavoriteImageView.isUserInteractionEnabled = true
        
        
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        movieDetailNameLabel.text = movie?.title
        
        movieVoteLabel.text = String(movie?.voteAverage ?? 0.0)
        
        let imgPosterPath = movie?.posterPath ?? ""
        let imgFullPath = URL(string: "\(imgUrl + imgPosterPath)")
        movieDetailImageView.loadImg(url: imgFullPath!)
        
        movieDetailDescriptionLabel.text = movie?.overview
    }
  
    @objc private func favoriteTappedImageView() {
        print("favorite button tapped")
        
        if APIManager.shared.setFavoriteMovie(movie: movie!){
            movieFavoriteImageView.image = UIImage(named: Constant.heartFilled )
        }
        else{
            movieFavoriteImageView.image = UIImage(named: Constant.heart)
        }
    }
  
    func prepare(movie: Movie) {
        self.movie = movie
    }
   
}

