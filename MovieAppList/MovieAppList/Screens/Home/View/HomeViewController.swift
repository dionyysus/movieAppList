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
    var isFiltered = false
    var searchedFilm = String()

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
                    self.searchedFilm = searchText
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
      
      searching = false
      isFiltered = false
      self.moviesCollectionView.reloadData()

      }

    }

extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if collectionView == moviesCollectionView {
            let storyBoard = UIStoryboard(name: "Detail", bundle: nil)
            let gotoDetailController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                        
            var movie = viewModel?.categoryMovies?[indexPath.row]  //save index-collections
            if searching{
                movie = viewModel?.filteredMovies?[indexPath.row]
            }else{
                movie = viewModel?.categoryMovies?[indexPath.row]
            }
            let firstGenre = viewModel?.genres?.filter { $0.id == (movie?.genreIDS.first ?? 0) }.first
            gotoDetailController.movieId = indexPath.row
            
            if let movie, let firstGenre {
                gotoDetailController.prepare(movie: movie, firstGenre: firstGenre)
                navigationController?.pushViewController(gotoDetailController, animated: true)
            }
            return
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
                    viewModel?.filteredMovies?[indexPath.row].genreIDS.forEach{print("filtered movie:\($0)")}
                }
                
            } else if isFiltered {
                cell.movieNameLabel.text = viewModel?.categoryMovies?[indexPath.row].title
                cell.movieVoteLabel.text = String(viewModel?.categoryMovies?[indexPath.row].voteAverage ?? 0.0)

                let imgPosterPath = viewModel?.categoryMovies?[indexPath.row].posterPath ?? ""
                let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")
                               
                if let imageFullPath = imgFullPath{
                    cell.movieImageView.loadImg(url: imageFullPath)
                }
             
                let movieGenres = viewModel?.categoryMovies?[indexPath.row].genreIDS
                let genreName = viewModel?.genres?.filter { genre in
                    movieGenres!.contains(genre.id ?? 0) // ! ekledim movieGenres yanına (realm için)
                }.map { $0.name ?? "" }.joined(separator: ",")
                                
                cell.movieCategoryNameLabel.text = genreName
                
            } else {
                cell.movieNameLabel.text = viewModel?.movies?[indexPath.row].title
                cell.movieVoteLabel.text = String(viewModel?.movies?[indexPath.row].voteAverage ?? 0.0)

                let imgPosterPath = viewModel?.movies?[indexPath.row].posterPath ?? ""
                let imgFullPath = URL(string: "\(APIManager.shared.imgUrl + imgPosterPath)")

                cell.movieImageView.loadImg(url: imgFullPath!)
                
                let movieGenres = viewModel?.movies?[indexPath.row].genreIDS
                let genreName = viewModel?.genres?.filter { genre in
                    movieGenres!.contains(genre.id ?? 0) // ! ekledim movieGenres yanına (realm için)
                }.map { $0.name ?? "" }.joined(separator: ",")
                
                cell.movieCategoryNameLabel.text = genreName
                viewModel?.movies?[indexPath.row].genreIDS.forEach{print("\($0)")}
            }
            return cell
        }

        else if collectionView == categoryCollectionView {
            guard let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else {
                return UICollectionViewCell()
            }
             
            categoryCell.categoryNameLabel.text = viewModel?.genres?[indexPath.row].name


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
        
        isFiltered = true
        searching = false
        
        viewModel?.categoryMovies = viewModel?.movies?.filter{ $0.genreIDS.contains(viewModel?.genres?[indexPath.row].id ?? 0) }
          moviesCollectionView.reloadData()
    }
}
    

