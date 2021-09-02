//
//  ViewController.swift
//  USScienceNewsFeed
//
//  Created by gunta.golde on 17/08/2021.
//

import UIKit
import Gloss

class TopHeadlinesNewsFeedViewController: UIViewController {
    
    var items: [Item] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "US Top News"
        activityIndicatorView.isHidden = true
    }
    
    func activityIndicator(animated: Bool){
        DispatchQueue.main.async {
            if animated {
                self.activityIndicatorView.isHidden = false
                self.activityIndicatorView.startAnimating()
            }else{
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    //basicAlert (UIAlert) customized as a message about app and what to do to get news articles
    @IBAction func infoBarItem(_ sender: Any) {
        basicAlert(title: "US Top News Feed Info", message: "🔹 This app allows you to\n find and read today's news top headlines articles in US. \n🔹 Press 🌓 button \nto go to phone settings. \n🔹 Press ✈️  button to fetch US Top News Feed articles")
    }
    
    @IBAction func getDataTapped(_ sender: Any) {
        self.activityIndicator(animated: true)
        handleGetData()
        
    }
    
    //function where we get the data from newsapi.org via jsonurl API.
    func handleGetData(){
        let jsonUrl = "https://newsapi.org/v2/top-headlines?country=us&apiKey=b4987bb0a1f34bd7b684a8adbee1cb6a"
        
        guard let url = URL(string: jsonUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { data, response, err in
            
            if let err = err {
                self.basicAlert(title: "Error!", message: "\(err.localizedDescription)")
            }
            
            guard let data = data else {
                self.basicAlert(title: "Error!", message: "Something went wrong, no data!")
                return
            }
            
            do {
                if let dictData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    print("dictData:", dictData)
                    self.poplateData(dictData)
                }
            }catch{
                
            }
        }
        task.resume()
    }
    
    func poplateData(_ dict: [String: Any]){
        guard let responseDict = dict["articles"] as? [Gloss.JSON] else {
            return
        }
        
        items = [Item].from(jsonArray: responseDict) ?? []
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator(animated: false)
            
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
//I'm using the extension for this TopHeadlinesNewsFeedViewController.This extension helps me to separate the class and extra code and makes code cleaner and more readable
extension TopHeadlinesNewsFeedViewController: UITableViewDelegate, UITableViewDataSource{
    
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //In storyboard there is only one cell. this func allows to reuse this cell depending on number of items that we get from newsapi.org. Fetched items will be presentend in NewsTableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "scienceNewsFeed", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.newsTitleLabel.text = item.title
        cell.newsTitleLabel.numberOfLines = 0
        
        if let image = item.image{
            cell.newsImageView.image = image
        }
        let date = String(item.publishedAt.prefix(10))
        self.title = "US Top News \(date)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    //this func alows to select specific row and pass it's value through the storyboard to ArticleDetailViewController. I'm passing tilte, description, image and url
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "ArticleDetailViewController") as? ArticleDetailViewController else {
            return
        }
        
        let item = items[indexPath.row]
        vc.contentString = item.description
        vc.titleString = item.title
        vc.webURLString = item.url
        vc.newsImage = item.image
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
    

