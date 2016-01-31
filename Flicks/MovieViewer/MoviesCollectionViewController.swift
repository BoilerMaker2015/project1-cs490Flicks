//
//  MoviesCollectionViewController.swift
//  MovieViewer
//
//  Created by wentai,cui on 16/1/23.
//  Copyright © 2016年 wentai,cui. All rights reserved.
//

import UIKit
import AFNetworking
class MoviesCollectionViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: .ValueChanged)
        CollectionView.insertSubview(refreshControl, atIndex: 0)
        CollectionView.dataSource = self
        searchBar.delegate = self
       // CollectionSearch.delegate = self
        filteredData = movies
        // Do any additional setup after loading the view.
        NSLog("hahah")
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
                            NSLog("response from the collection: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.filteredData = self.movies
                            self.CollectionView.reloadData()
                    }
                }
        });
        task.resume()

        
    }

    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl

    
    func refreshControlAction(refreshControl : UIRefreshControl) {
        
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
                            NSLog("response from the collection: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            
                            self.CollectionView.reloadData()
                    }
                }
        });
        task.resume()

        
        CollectionView.reloadData()
        refreshControl.endRefreshing()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = filteredData {
            return filteredData.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let imageUrl = NSURL(string: baseUrl + posterPath)
        let rate = movie["vote_average"] as! Float64
        cell.Collectiontitle.text = title
        cell.CollectionImage.setImageWithURL(imageUrl!)
        cell.rate.text = String(rate)
        if( rate>7.000) {
            cell.rate.textColor = UIColor.greenColor()
        }
        else if(rate>5.000&&rate<7.000) {
            cell.rate.textColor = UIColor.yellowColor()
        }else {
            cell.rate.textColor = UIColor.redColor()
        }
       // cell.titleLabel.text = title
       // cell.overviewLabel.text = overview
       // cell.posterView.setImageWithURL(imageUrl!)
        
        print("row \(indexPath.row)")
        return cell
        
        
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? movies : movies!.filter({ (movie: NSDictionary) -> Bool in
            return (movie["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            
        })
        self.CollectionView.reloadData()
        
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
