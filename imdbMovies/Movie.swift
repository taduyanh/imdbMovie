//
//  Movie.swift
//  imdbMovies
//
//  Created by mac on 2/19/17.
//  Copyright © 2017 anhtd. All rights reserved.
//

import UIKit
import AFNetworking

class Movie: NSObject {
    var title: String
    var overview: String
    var imageUrl: String
    private let imageThumbSourceUrl = "https://image.tmdb.org/t/p/w300"
    private let imageOriginalSourceUrl = "https://image.tmdb.org/t/p/original"
    
    init(title: String, overview: String, url: String) {
        self.title = title
        self.overview = overview
        self.imageUrl = url
    }
    
    func getImageUrl(_ type: String = "thumb") -> String {
        switch type {
        case "thumb":
            return "\(imageThumbSourceUrl)/\(imageUrl)"
        default:
            return "\(imageOriginalSourceUrl)/\(imageUrl)"
        }
    }
    
    class func fetchMovies(successCallBack: @escaping (NSDictionary) -> (), errorCallBack: ((Error?) -> ())?) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                errorCallBack?(error)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                successCallBack(dataDictionary)
            }
        }
        task.resume()
    }

}
