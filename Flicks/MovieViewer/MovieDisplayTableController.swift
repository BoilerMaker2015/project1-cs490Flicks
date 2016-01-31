//
//  MovieDisplayTableController.swift
//  MovieViewer
//
//  Created by wentai,cui on 16/1/24.
//  Copyright © 2016年 wentai,cui. All rights reserved.
//

import UIKit
import YouTubePlayer

class MovieDisplayTableController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var TopTtile: UILabel!
    @IBOutlet weak var videoplayer: YouTubePlayerView!
    //@IBOutlet weak var imagedisplay: UIImageView!
   // @IBOutlet weak var collection: UILabel!
   // @IBOutlet weak var rate: UILabel!
   // @IBOutlet weak var voteNumber: UILabel!
   // @IBOutlet weak var year: UILabel!
   // @IBOutlet weak var mytitle: UILabel!
    @IBOutlet weak var imagedisplay: UIImageView!
    @IBOutlet weak var TI: UILabel!
    @IBOutlet weak var YEAR: UILabel!
    @IBOutlet weak var TIME: UILabel!
    @IBOutlet weak var VOTE: UILabel!
    @IBOutlet weak var RATE: UILabel!

    @IBOutlet weak var C1: UILabel!
    
    var movies: NSDictionary!
    var mymovies:  [NSDictionary]?
    var YouTubeId:Int? = 0
    var titletext:String? = ""
    var collectiontext:String? = ""
    var postPath: String?
    var year: String?
    var rate: Float64?
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TopTtile.text = titletext
        self.C1.text = collectiontext
        self.YEAR.text = year
        self.TI.text = titletext
        self.YEAR.text = year
        let test = movies["title"] as! String
        print("the title from infornatiomview: ", test)
        // Do any additional setup after loading the view.
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let imageUrl = NSURL(string: baseUrl + postPath!)
        self.imagedisplay.setImageWithURL(imageUrl!)
        
        
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(YouTubeId!)/videos?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if error != nil{
                }
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.mymovies = responseDictionary["results"] as? [NSDictionary]
                            if ((self.mymovies?.isEmpty) == false) {
                                if let videoId = self.mymovies![0]["key"] as? String {
                                    
                                    self.videoPlayer.loadVideoID(videoId)
                                }
                            }
                    }
                }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
