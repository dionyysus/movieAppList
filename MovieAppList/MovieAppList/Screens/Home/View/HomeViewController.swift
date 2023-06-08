//
//  HomeViewController.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 27.04.2023.
//

import UIKit

// TODO: search yap
class HomeViewController: UIViewController, UITextFieldDelegate {

    private var viewModel: HomeViewModel?

    var searching = false
    var isFiltered = true
/**
    Added `searchedFilm` Property which will be set to the value of  `searchBar.text`
 */ var searchedFilm = String()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"

        viewModel = HomeViewModel(apiManager: APIManager.shared)

        let nib = UINib(nibName: MoviesCollectionViewCell.identifier, bundle: nil)
        moviesCollectionView.register(nib, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)

        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self

        viewModel?.fetchMovies { [weak self] in
            self?.moviesCollectionView.reloadData()
            self?.categoryCollectionView.reloadData()
        }

        viewModel?.fetchGenres { [weak self] in
            self?.moviesCollectionView.reloadData()
            self?.categoryCollectionView.reloadData()
        }
    }

    @IBAction func searchHandler(_ sender: UITextField) {
        if let searchText = sender.text{
            viewModel?.filteredMovies = searchText.isEmpty ? viewModel?.movies : viewModel?.movies?.filter { movie in
                if let title = movie.title?.lowercased() {
/**                 set the `searchedFilm` property to the unwrapped value of the `searchBar.text`
*/                  self.searchedFilm = searchText
                    return title.contains(searchText.lowercased())
                }
                return false
            }
            searching = true
        }
        if sender.text!.isEmpty {
            searching = false
        }
        moviesCollectionView.reloadData()
    }
    
  @IBAction func searchTapped(_ sender: Any) {
/** These MUST be set to `false`, if not, then the `UICollectionViewDataSource` methods will not trigger for the right `collectionView` or the correct `[Movie]`
*/  searching = false
    isFiltered = false
/** This line replaces spaces with `%20` for appropriate URL Creation, returns an optional, thus the unwrapping
*/  guard let searched = searchedFilm.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else { return }
    viewModel?.fetchMovie(named: searched) { [weak self] in
      self?.moviesCollectionView.reloadData()
    }
  }
  
  @objc func labelTapped() {
        print("category lapel tapped")
    }
}

extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if collectionView == moviesCollectionView {
            let storyBoard = UIStoryboard(name: "Detail", bundle: nil)
            let gotoDetailController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
#warning("TODO: - After searching then selecting a cell, is still loading the DeatialViewController populated with the viewModel's categoryMovies array, rather than the viewModel's movies array.")
            let movie = viewModel?.categoryMovies?[indexPath.row]  //save index-collections
            let firstGenre = viewModel?.genres?.filter { $0.id == (movie?.genreIDS?.first ?? 0) }.first
            gotoDetailController.movieId = indexPath.row
            
            if let movie, let firstGenre {
                gotoDetailController.prepare(movie: movie, firstGenre: firstGenre) // TODO: İsim değiştir
                navigationController?.pushViewController(gotoDetailController, animated: true)
            }
            return
        } else if collectionView == categoryCollectionView {
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == moviesCollectionView {
            if searching {
                return viewModel?.filteredMovies?.count ?? 0
            } else if isFiltered {
                return viewModel?.categoryMovies?.count ?? 0
            } else {
                return viewModel?.movies?.count ?? 0
            }
        } else if collectionView == categoryCollectionView {
            return viewModel?.genres?.count ?? 0 + 1
        } else {
            return 0
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == moviesCollectionView {
            guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as? MoviesCollectionViewCell else {
                return UICollectionViewCell()
            }
            if searching {
                cell.movieNameLabel.text = viewModel?.filteredMovies?[indexPath.row].title
                cell.movieVoteLabel.text = String(viewModel?.filteredMovies?[indexPath.row].voteAverage ?? 0.0)

                let imgPosterPath = viewModel?.filteredMovies?[indexPath.row].posterPath ?? ""
                let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")

                if let imageFullPath = imgFullPath {
                    cell.movieImageView.loadImg(url: imageFullPath)
                    viewModel?.filteredMovies?[indexPath.row].genreIDS?.forEach{print("filtered movie:\($0)")}
                }
                
            } else if isFiltered {
                cell.movieNameLabel.text = viewModel?.categoryMovies?[indexPath.row].title
                cell.movieVoteLabel.text = String(viewModel?.categoryMovies?[indexPath.row].voteAverage ?? 0.0)

                let imgPosterPath = viewModel?.categoryMovies?[indexPath.row].posterPath ?? ""
                let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")
                               
                if let imageFullPath = imgFullPath{
                    cell.movieImageView.loadImg(url: imageFullPath)
                }
             
                let movieGenres = viewModel?.categoryMovies?[indexPath.row].genreIDS ?? []
                let genreName = viewModel?.genres?.filter { genre in
                     movieGenres.contains(genre.id ?? 0)
                }.map { $0.name ?? "" }.joined(separator: ",")
                                
                cell.movieCategoryNameLabel.text = genreName
                
            } else {
                cell.movieNameLabel.text = viewModel?.movies?[indexPath.row].title
                cell.movieVoteLabel.text = String(viewModel?.movies?[indexPath.row].voteAverage ?? 0.0)

                let imgPosterPath = viewModel?.movies?[indexPath.row].posterPath ?? ""
                let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")

                cell.movieImageView.loadImg(url: imgFullPath!)
                
                let movieGenres = viewModel?.movies?[indexPath.row].genreIDS ?? []
                let genreName = viewModel?.genres?.filter { genre in
                    movieGenres.contains(genre.id ?? 0)
                }.map { $0.name ?? "" }.joined(separator: ",")
                
                cell.movieCategoryNameLabel.text = genreName
                viewModel?.movies?[indexPath.row].genreIDS?.forEach{print("ggwp \($0)")}
            }
            return cell
        }

        else if collectionView == categoryCollectionView {
            guard let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else {
                return UICollectionViewCell()
            }
             
            categoryCell.categoryNameLabel.text = viewModel?.genres?[indexPath.row].name

            if categoryCell.isSelected {
              categoryCell.categoryNameLabel.highlightedTextColor = UIColor.blue
            }

            categoryCell.delegate = self
            categoryCell.indexPath = indexPath
            return categoryCell
        }
        return UICollectionViewCell()
    }
}

extension HomeViewController: UICollectionViewDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let searchString = (textField.text! as NSString).replacingCharacters(in: range, with: string)

           if searchString.isEmpty {
               viewModel?.filteredMovies = viewModel?.movies
           } else {
               viewModel?.filteredMovies = (viewModel?.movies?.filter { movie in
                 searching = true
                   return (movie.title?.lowercased().contains(searchString.lowercased()))!
               })
           }
           moviesCollectionView.reloadData()
           return true
       }
}

extension HomeViewController: CategoriesCellDelegate {
    func labelClicked(indexPath: IndexPath) {
        viewModel?.categoryMovies = viewModel?.movies?.filter{ $0.genreIDS?.contains(viewModel?.genres?[indexPath.row].id ?? 0) ?? false }
          moviesCollectionView.reloadData()
    }
}
    

