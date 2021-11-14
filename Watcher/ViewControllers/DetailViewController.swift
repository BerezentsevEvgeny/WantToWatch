//
//  DetailViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

import AlamofireImage

class DetailViewController: UIViewController {
    
    let selectedMovie: Movie
    let watchlistStorage: WatchlistStorage

    let posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.image = UIImage(named: "moviePlaceholder")
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
        return posterImageView
    }()
    
    lazy var addAndRemoveButton: UIButton = {
        let button = UIButton()
        button.setTitle(!watchlistStorage.watchList.contains(selectedMovie) ? "Add to list" : "Remove" , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addToWatchlist), for: .touchUpInside)
        return button
    }()
    
    lazy var watchTrailerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Watch trailer" , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(watchTrailer), for: .touchUpInside)
        return button
    }()
        
    private let releaseYearLabel = UILabel()
    private let ratingLabel = UILabel()
    private let popularityLabel = UILabel()
    
    private let overviewLabel: UILabel = {
        let overviewLabel = UILabel()
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.textAlignment = .left
        overviewLabel.adjustsFontSizeToFitWidth = true
        overviewLabel.font = .systemFont(ofSize: 20)
        overviewLabel.numberOfLines = 0
        return overviewLabel
    }()
        
    private var hstack = UIStackView()
    private var vstack = UIStackView()
    
    init(selectedMovie: Movie, watchlistStorage: WatchlistStorage) {  //
        self.selectedMovie = selectedMovie
        self.watchlistStorage = watchlistStorage //
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setPosterImage()
        setupLabels()
        setConstraints()
    }
    
    private func setPosterImage() {
        guard let imageString = selectedMovie.posterImage else { return }
        guard let url = URL(string: "https://image.tmdb.org/t/p/w200" + imageString) else { return }
        posterImageView.af.setImage(withURL: url)
    }
    
    private func setViews() {
        title = selectedMovie.title
        overviewLabel.text = selectedMovie.overview
        view.backgroundColor = .systemBackground
        view.addSubview(posterImageView)
        view.addSubview(overviewLabel)
        view.addSubview(addAndRemoveButton)
        view.addSubview(watchTrailerButton)
        
        hstack = UIStackView(arrangedSubviews: [addAndRemoveButton, watchTrailerButton])
        hstack.axis = .horizontal
        hstack.distribution = .fillEqually
        hstack.spacing = 20
        hstack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hstack)
        
        vstack = UIStackView(arrangedSubviews: [releaseYearLabel,popularityLabel,ratingLabel])
        vstack.axis = .vertical
        vstack.distribution = .fillEqually
        vstack.alignment = .fill
        vstack.spacing = 50
        vstack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vstack)
    }
    
    private func setupLabels() {
        let labels = [releaseYearLabel,popularityLabel,ratingLabel]
        labels.forEach {
            $0.backgroundColor = .systemGreen
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
            $0.textColor = .white
            $0.textAlignment = .center
        }
        releaseYearLabel.text = "Year: \(selectedMovie.year?.replacingOccurrences(of: "-", with: ".") ?? "Not available")"
        popularityLabel.text = "Popularity: \(lroundf(selectedMovie.popularity ?? 0))"
        ratingLabel.text = "Rating: \(round(selectedMovie.rate ?? 0.0))"
        
    }
     
    private func setConstraints() {
        let margins = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 160),
            posterImageView.heightAnchor.constraint(equalToConstant: 240) ])
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: addAndRemoveButton.topAnchor, constant: -20) ])
                
        NSLayoutConstraint.activate([
            hstack.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            hstack.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            hstack.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -18) ])
        
        NSLayoutConstraint.activate([
            vstack.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20),
            vstack.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor,constant: -10),
            vstack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            vstack.trailingAnchor.constraint(equalTo: margins.trailingAnchor) ])
    }
    
    @objc func addToWatchlist() {
        if !watchlistStorage.watchList.contains(selectedMovie) {
            presentAlert(message: "Add to watchlist?", actionTitle: "Add") { _ in
                self.watchlistStorage.append(self.selectedMovie)
                self.addAndRemoveButton.setTitle("Remove", for: .normal)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            presentAlert(message: "Remove from watchlist?", actionTitle: "Remove") { _ in
                self.watchlistStorage.remove(self.selectedMovie)
                self.addAndRemoveButton.setTitle("Add to watchlist", for: .normal)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func watchTrailer() {
        guard let query = selectedMovie.title?.replacingOccurrences(of: " ", with: "+") else { return }
        let escapedYoutubeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let appURL = NSURL(string: "youtube://www.youtube.com/results?search_query=\(escapedYoutubeQuery!)")!
        let webURL = NSURL(string: "https://www.youtube.com/results?search_query=\(escapedYoutubeQuery!)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }
    
}
