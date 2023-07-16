import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    private var viewModel: HomeViewModel?
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var selectedCategory = false
    var isSelectedCell = false
    var deSelectCell = false
    var selectedCategories: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        viewModel = HomeViewModel(apiManager: APIManager.shared)
        
        let nib = UINib(nibName: MoviesCollectionViewCell.identifier, bundle: nil)
        moviesCollectionView.register(nib, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        viewModel?.fetchGenres { [weak self] in
            self?.moviesCollectionView.reloadData()
            self?.categoryCollectionView.reloadData()
        }
        
        viewModel?.fetchMovies { [weak self] in
            self?.moviesCollectionView.reloadData()
            self?.categoryCollectionView.reloadData()
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        moviesCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 1 - gridLayout.minimumInteritemSpacing
        return CGSize(width:widthPerItem, height:240)
    }
}
extension HomeViewController: UICollectionViewDataSource {
    //  MARK: MOVIE COLLECTION DATA SOURCE CELL COUNT
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == moviesCollectionView {
            if selectedCategories.isEmpty {
                return viewModel?.movies?.count ?? 0
            } else {
                return viewModel?.movies?.filter { movie in
                    movie.genreIDS.contains(where: { selectedCategories.contains($0 ?? 0) })
                }.count ?? 0
            }
        } else if collectionView == categoryCollectionView {
            return viewModel?.genres?.count ?? 0
        } else {
            return 0
        }
    }
    
    //  MARK: - MOVIE COLLECTION DATA SOURCE CELL CONTENT
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == moviesCollectionView {
            guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as? MoviesCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let filteredMovies: [Movie]? = {
                if selectedCategories.isEmpty {
                    return viewModel?.movies
                } else {
                    return viewModel?.movies?.filter { movie in
                        movie.genreIDS.contains(where: { selectedCategories.contains($0 ?? 0) })
                    }
                }
            }()
            
            let movie = filteredMovies?[indexPath.item]
            
            cell.movieNameLabel.text = movie?.title
            cell.movieVoteLabel.text = String(movie?.voteAverage ?? 0.0)
            
            if let posterPath = movie?.posterPath,
               let imgUrl = URL(string: "\(APIManager.shared.imgUrl + posterPath)") {
                cell.movieImageView.loadImg(url: imgUrl)
            } else {
                // Poster yüklenemediğinde varsayılan görsel kullanılabilir
                cell.movieImageView.image = UIImage(named: "default_poster")
            }
            
            let genreIDs = movie?.genreIDS
            let genreNames = genreIDs?.compactMap { genreID in
                self.viewModel?.genres?.first { genre in genre.id == genreID }?.name
            }.joined(separator: ",")
            
            cell.movieCategoryNameLabel.text = genreNames
            
            return cell
        } else if collectionView == categoryCollectionView {
            guard let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            categoryCell.categoryNameLabel.text = viewModel?.genres?[indexPath.row].name
            if selectedCategories.contains(viewModel?.genres?[indexPath.row].id ?? 0) {
                categoryCell.layer.borderColor =  UIColor.darkGray.cgColor
                categoryCell.layer.borderWidth = 3.0
            } else {
                categoryCell.layer.borderColor =  UIColor.white.cgColor
            }
            return categoryCell
        }
        
        return UICollectionViewCell()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    // MARK: - MOVIE COLLECTION DELEGATE
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if collectionView == moviesCollectionView {
            let storyBoard = UIStoryboard(name: "Detail", bundle: nil)
            let gotoDetailController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            
            let filteredMovies: [Movie]? = {
                if selectedCategories.isEmpty {
                    return viewModel?.movies
                } else {
                    return viewModel?.movies?.filter { movie in
                        movie.genreIDS.contains(where: { selectedCategories.contains($0 ?? 0) })
                    }
                }
            }()
            
            let movie = filteredMovies?[indexPath.row]
            
            let movieGenres = movie?.genreIDS
            let genreName = viewModel?.genres?
                .filter { genre in movieGenres?.contains(genre.id ?? 0) ?? false }
                .compactMap { $0.name }
                .joined(separator: ",") ?? ""
            
            if let selectedMovie = movie {
                gotoDetailController.prepare(movie: selectedMovie, genreName: genreName)
                navigationController?.pushViewController(gotoDetailController, animated: true)
            }
            
            return
            //   MARK: CATEGORY COLLECTION DELEGATE
        }
        else if collectionView == categoryCollectionView {
            let selectedCategoryId = viewModel?.genres?[indexPath.row].id ?? 0
            if selectedCategories.contains(selectedCategoryId) {
                
                // Kategori zaten seçili, seçimini kaldır
                if let index = selectedCategories.firstIndex(of: selectedCategoryId) {
                    selectedCategories.remove(at: index)
                }
            } else {
                // Kategori seçilmedi, seçimini ekle
                selectedCategories.append(selectedCategoryId)
            }
            
            categoryCollectionView.reloadData()
            moviesCollectionView.reloadData()
        }
    }
}

extension HomeViewController {
    func cellClicked(indexPath: IndexPath) {
        selectedCategory = true
        viewModel?.categoryMovies = viewModel?.movies?.filter { $0.genreIDS.contains(viewModel?.genres?[indexPath.row].id ?? 0) }
        moviesCollectionView.reloadData()
    }
}





