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
    var searchedFilm = String()
    @IBOutlet weak var searchTextField: UITextField!
    var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = SearchViewModel(apiManager: APIManager.shared)
        
        let nibMovie = UINib(nibName: MoviesCollectionViewCell.identifier, bundle: nil)
        movieCollectionView.register(nibMovie, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        movieCollectionView.setCollectionViewLayout(layout, animated: true)
  
        viewModel?.fetchGenres { [weak self] in
          self?.movieCollectionView.reloadData()
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        guard let searched = searchTextField.text else {return}
        viewModel?.fetchMovie(named: searched) { [weak self] in
        self?.movieCollectionView.reloadData()
        }
    }
}
extension SearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 1 - gridLayout.minimumInteritemSpacing
        return CGSize(width:widthPerItem, height:240)
    }
}
extension SearchViewController: UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.movies?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as? MoviesCollectionViewCell
        else {
          return UICollectionViewCell()
        }

        let funkNasty: [Movie]? = {
            viewModel?.movies
        }()

        cell.movieNameLabel.text = funkNasty?[indexPath.row].title
        cell.movieVoteLabel.text = String(funkNasty?[indexPath.row].voteAverage ?? 0.0)

        let imgPosterPath = funkNasty?[indexPath.row].posterPath ?? ""
        let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")

        cell.movieImageView.loadImg(url: imgFullPath!)

        let movieGenres = funkNasty?[indexPath.row].genreIDS
        let genreName = viewModel?.genres?.filter { genre in
          movieGenres!.contains(genre.id ?? 0) // ! ekledim movieGenres yanına (realm için)
        }.map { $0.name ?? "" }.joined(separator: ",")

        cell.movieCategoryNameLabel.text = genreName
        funkNasty?[indexPath.row].genreIDS.forEach{print("Genre ID: \($0)")}
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Detail", bundle: nil)
        let gotoDetailController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let movie = viewModel?.movies?[indexPath.row]  //save index-collections
        let movieGenres = viewModel?.movies?[indexPath.row].genreIDS
        let genreName = viewModel?.genres?.filter { genre in
          movieGenres!.contains(genre.id ?? 0) // ! ekledim movieGenres yanına (realm için)
        }.map { $0.name ?? "" }.joined(separator: ",") ?? ""
        gotoDetailController.movieId = indexPath.row
        if let movie {
          gotoDetailController.prepare(movie: movie, genreName: genreName)
          navigationController?.pushViewController(gotoDetailController, animated: true)
        }
        return
    }
    
    
}
