//
//  MoviesViewController.swift
//  imdbMovies
//
//  Created by mac on 2/19/17.
//  Copyright © 2017 anhtd. All rights reserved.
//

import UIKit
import MBProgressHUD

class MoviesViewController: UIViewController {
    var refreshControl = UIRefreshControl()
    var networkErrorView = UIView(frame: CGRect(x: 0, y: 64, width: 320, height: 50))
    @IBOutlet weak var movieTableView: UITableView!
    var movies = [Movie]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initNetworkErrorView()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        
        refreshControl.addTarget(self, action: #selector(loadPlayingMovies(_ :)), for: UIControlEvents.valueChanged)
        self.movieTableView.addSubview(refreshControl)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Movie.fetchMovies(successCallBack: loadMovies, errorCallBack: handleError)
        // Do any additional setup after loading the view.
    }
    
    func loadPlayingMovies(_ refreshControl: UIRefreshControl) {
        networkErrorView.alpha = 0
        Movie.fetchMovies(successCallBack: loadMovies, errorCallBack: handleError)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadMovies(_ data: NSDictionary) {
        
        movies = []
        if let results = data["results"] as? [NSDictionary] {
            for result in results {
                let movie = Movie(title: (result["title"] as? String)!, overview: (result["overview"] as? String)!, url: (result["poster_path"] as? String)!)
                movies.append(movie)
            }
        }
        movieTableView.reloadData()
        refreshControl.endRefreshing()
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func initNetworkErrorView() {
        networkErrorView.backgroundColor = UIColor(white: 0.5, alpha: 1)
        let networkErrorTextLabel = UILabel(frame: CGRect(x: 50, y: 10, width: 200, height:30))
        networkErrorTextLabel.text = "Network Error"
        networkErrorView.addSubview(networkErrorTextLabel)
        networkErrorView.alpha = 0
        self.view.addSubview(networkErrorView)
        
    }
    
    func handleError(_ error: Error?) {
        networkErrorView.alpha = 1
        MBProgressHUD.hide(for: self.view, animated: true)
        refreshControl.endRefreshing()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MovieDetailsViewController
        let row = movies[(movieTableView.indexPathForSelectedRow?.row)!]
        vc.overview = row.overview
        vc.postImageUrl = row.getImageUrl("full")
        vc.movieTitle = row.title
    }
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieCell
        let movie = self.movies[indexPath.row]
        cell.loadData(title: movie.title, overview: movie.overview, imageUrl: movie.getImageUrl())
        return cell
    }
}
