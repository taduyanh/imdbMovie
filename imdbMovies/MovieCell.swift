//
//  MovieCell.swift
//  imdbMovies
//
//  Created by mac on 2/19/17.
//  Copyright © 2017 anhtd. All rights reserved.
//

import UIKit
import MBProgressHUD
import AFNetworking


class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(title: String, overview: String, imageUrl: String) {
        titleLabel.text = title
        overviewLabel.text = overview
        MBProgressHUD.showAdded(to: self.posterImage, animated: true)
        let urlRequest = NSURLRequest(url: (NSURL(string: imageUrl) as! URL)) as URLRequest
        self.posterImage.image = nil
        self.posterImage.setImageWith(urlRequest, placeholderImage: nil, success: { (request, response, image) in
            self.posterImage.image = image
            MBProgressHUD.hide(for: self.posterImage, animated: true)
        }, failure: { (request, response, error) in
            print(error)
        })
    }

}
