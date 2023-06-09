import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    private var viewModel: HomeViewModel?
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var selectedCategory = false
    var isSelectedCell = false
    var deSelectCell = false
    
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
            if selectedCategory {
                return viewModel?.categoryMovies?.count ?? 0
            } else {
                return viewModel?.movies?.count ?? 0
            }
            
            //  MARK: CATEGORY COLLECTION DATA SOURCE CELL COUNT
        } else if collectionView == categoryCollectionView {
            return viewModel?.genres?.count ?? 0
        } else {
            return 0
        }
    }
    
    //  MARK: - MOVIE COLLECTION DATA SOURCE CELL CONTENT
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == moviesCollectionView {
            guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as? MoviesCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            let funkNasty: [Movie]? = {
                if selectedCategory {
                    return viewModel?.categoryMovies
                } else {
                    return viewModel?.movies
                }
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
            
            //  MARK: - CATEGORY COLLECTION DATA SOURCE CELL CONTENT
        } else if collectionView == categoryCollectionView {
            guard let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            categoryCell.categoryNameLabel.text = viewModel?.genres?[indexPath.row].name
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
            let storyBoard = UIStoryboard(name: "Detail",
                                          bundle: nil)
            let gotoDetailController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            
            let movie = viewModel?.categoryMovies?[indexPath.row]  //save index-collections
            
            let movieGenres = viewModel?.categoryMovies?[indexPath.row].genreIDS
            let genreName = viewModel?.genres?.filter { genre in
                movieGenres!.contains(genre.id ?? 0) // ! ekledim movieGenres yanına (realm için)
            }.map { $0.name ?? "" }.joined(separator: ",") ?? ""
            gotoDetailController.movieId = indexPath.row
            if let movie {
                gotoDetailController.prepare(movie: movie, genreName: genreName)
                navigationController?.pushViewController(gotoDetailController, animated: true)
            }
            return
            
            //   MARK: CATEGORY COLLECTION DELEGATE
        } else if collectionView == categoryCollectionView {
            if let cell = categoryCollectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell {
                if !isSelectedCell {
                    cell.layer.borderColor =  UIColor.darkGray.cgColor
                    cell.layer.borderWidth = 3.0
                    cellClicked(indexPath: indexPath)
                    isSelectedCell = true
                } else {
                    if !deSelectCell {
                        cell.layer.borderColor =  UIColor.white.cgColor
                        isSelectedCell = false
                        viewModel?.fetchMovies { [weak self] in
                            self?.moviesCollectionView.reloadData()
                            self?.categoryCollectionView.reloadData()
                        }
                    }
                }
            }
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





