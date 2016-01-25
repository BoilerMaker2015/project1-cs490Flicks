//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by wentai,cui on 1/10/16.
//  Copyright © 2016 wentai,cui. All rights reserved.
//

import UIKit
import AFNetworking
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var NetReeor: UIView!
    var movies: [NSDictionary]?
    var overview: String?
    var posterPath: String?
    var YEAR: String?
    var TIME: String?
    var VOTE: Int?
    var RATE: Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
                
                if error != nil {
                    self.NetReeor.hidden = false
                    self.tableView.hidden = true
                }
                
        });
        task.resume()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = movies {
            return movies.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
            overview = movie["overview"] as! String
            YEAR = movie["release_date"] as! String
            //TIME = movie["overview"] as! String
            VOTE = movie["vote_count"] as! Int
            RATE = movie["vote_average"] as! Double
        let baseUrl = "http://image.tmdb.org/t/p/w500"
            posterPath = movie["poster_path"] as! String
        let imageUrl = NSURL(string: baseUrl + posterPath!)
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWithURL(imageUrl!)
        
        print("row \(indexPath.row)")
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        if segue.identifier == "infromation" {
        let MovieDisplayTableController = segue.destinationViewController as! MovieDisplayTableController
        MovieDisplayTableController.movie = movie
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteColor()
        cell.selectedBackgroundView = backgroundView
        
        tabBarController!.tabBar.hidden = true
        resetCollectionViewScrollToTop()
        resetSearchBar(self.searchBar)
        resetMovieData()
            
        }
        */
            print("hahaha!!!!!!@23")
        if segue.identifier != "colle" {
            let cell = sender as! UITableViewCell
            let indexPaths = self.tableView!.indexPathForCell(cell)
            let movie = movies![indexPaths!.row]
            let vc = segue.destinationViewController as!MovieDisplayTableController
            vc.movies = movie
            title = movie["title"] as! String
            vc.titletext = title
            vc.YouTubeId = movie["id"] as! Int
            print("THE TITLE IS: " + title!)
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            posterPath = movie["poster_path"] as! String
            vc.postPath = self.posterPath
            overview = movie["overview"] as! String
            vc.collectiontext = overview
            YEAR = movie["release_date"] as! String
            vc.year = YEAR
            let rate1 = movie["vote_average"] as! Float64
            vc.rate = rate1
        }
        
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
