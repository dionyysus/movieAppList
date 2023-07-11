//
//  SearchViewController.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 7.07.2023.
//

import UIKit

class SearchViewController: UIViewController{


    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    private var viewModel: SearchViewModel?
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        let nibMovie = UINib(nibName: MoviesCollectionViewCell.identifier, bundle: nil)
        movieCollectionView.register(nibMovie, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
    }
    
    @IBAction func searchButton(_ sender: Any) {
    }
}

extension SearchViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        if collectionView == movieCollectionView{
            guard let cellMovie = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as? MoviesCollectionViewCell else { return UICollectionViewCell() }
            return cellMovie
        }
        return UICollectionViewCell()
        
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == movieCollectionView {
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
}
