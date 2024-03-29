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
        viewModel?.fetchGenres { [weak self] in
            self?.favoriteMoviesCollectionView.reloadData()
        }
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        favoriteMoviesCollectionView.setCollectionViewLayout(layout, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        favoriteMoviesCollectionView.reloadData()
        favoriteLabel.isHidden = RealmManager.shared.getAllMovies().count != 0
    }
    
    private func addFavoriteLabel() {
        self.view.addSubview(favoriteLabel)
    }
    
    override func viewDidLayoutSubviews() {
        favoriteLabel.layer.cornerRadius = 15.0
        favoriteLabel.layer.borderWidth = 3.0
    }
    
   
    
}

extension FavoriteMoviesViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 1 - gridLayout.minimumInteritemSpacing
        return CGSize(width:widthPerItem, height:240)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           
            return 10.0
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          
            return 10.0
        }
}

extension FavoriteMoviesViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == favoriteMoviesCollectionView {
            let storyBoard = UIStoryboard(name: "Detail", bundle: nil)
            let gotoDetailController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            let movieEntity = RealmManager.shared.getAllMovies()[indexPath.row]
            let movie = Movie.mapToItem(model: movieEntity)
            gotoDetailController.movieId = indexPath.row
            gotoDetailController.prepare(movie: movie, genreName: movie.genreName ?? "")
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
        guard let cell = favoriteMoviesCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCollectionViewCell", for: indexPath) as? FavoritesCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.favoriteMovieNameLabel.text = favorites.title
        cell.favoriteVoteLabel.text =  String(favorites.voteAverage ?? 0.0)
        
        let imgPosterPath = favorites.posterPath ?? ""
        let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")
        cell.favoriteMovieImageView.loadImg(url: imgFullPath!)
        cell.favoriteCategoryNameLabel.text = favorites.genreName
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
}

extension FavoriteMoviesViewController: FavoritesCellDelegate{
    func imageViewClicked(indexPath: IndexPath) {
        let movies = RealmManager.shared.getAllMovies()
        let movie = movies[indexPath.row]
        RealmManager.shared.deleteMovie(movie)
        favoriteLabel.isHidden = RealmManager.shared.getAllMovies().count != 0
        favoriteMoviesCollectionView.reloadData()
    }
}
extension FavoriteMoviesViewController: UICollectionViewDelegate{
    
}

