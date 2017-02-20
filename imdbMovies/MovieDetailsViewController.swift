//
//  MovieDetailsViewController.swift
//  imdbMovies
//
//  Created by mac on 2/19/17.
//  Copyright © 2017 anhtd. All rights reserved.
//

import UIKit
import MBProgressHUD

class MovieDetailsViewController: UIViewController {
    var postImageUrl = ""
    var overview = ""
    var movieTitle = ""

    @IBOutlet weak var movieDetailView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDetailScrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = overview
        movieTitleLabel.text = movieTitle
        loadContentSize()
        MBProgressHUD.showAdded(to: posterImageView, animated: true)
        let urlRequest = NSURLRequest(url: (NSURL(string: postImageUrl) as! URL)) as URLRequest
        posterImageView.image = nil
        posterImageView.setImageWith(urlRequest, placeholderImage: nil, success: { (request, response, image) in
            self.posterImageView.image = image
            MBProgressHUD.hide(for: self.posterImageView, animated: true)
        }, failure: { (request, response, error) in
            print(error)
        })
    }
    
    func loadContentSize() {
        
        descriptionLabel.sizeToFit()
        movieDetailView.frame.size.height = 65 + descriptionLabel.bounds.height
        let new_height = descriptionLabel.frame.height
        movieDetailScrollView.contentSize = CGSize(width: movieDetailScrollView.bounds.width, height: 390 + new_height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

