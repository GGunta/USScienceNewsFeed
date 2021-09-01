//
//  ArticleDetailViewController.swift
//  USScienceNewsFeed
//
//  Created by gunta.golde on 18/08/2021.
//

import UIKit
import CoreData


class ArticleDetailViewController: UIViewController {

    //variables used later to save the data to CoreData (local phone's storage)
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    
    var webURLString = String()
    var titleString = String()
    var contentString = String()
    var newsImage: UIImage?
    
    //buttons/labels that can bee seen in simulator
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var readFullArticleButton: UIButton!
    @IBOutlet weak var savedButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readFullArticleButton.layer.cornerRadius = 7
        readFullArticleButton.tintColor = .label
        savedButton.layer.cornerRadius = 7
        self.title = "Article"
        
        titleLabel.text = titleString
        contentTextView.text = contentString
        newsImageView.image = newsImage

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    //basicAlert (UIAlert) customized as a message that article is saved to CoreData
    func saveData() {
        do{
            try context?.save()
            basicAlert(title: "Saved!", message: "To see your saved article, go to Saved tab bar.")
        }catch{
            print(error.localizedDescription)
        }
    }
    
    //action for SAVE button. func allows to pass values to CoreData and SavedNewsTableViewController
    @IBAction func savedButtonTapped(_ sender: Any) {
        let newItem = Items(context: self.context!)
        newItem.newsTitle = titleString
        newItem.newsContent = contentString
        newItem.url = webURLString
        
        guard let imageData: Data = newsImage?.pngData() else {
            return
        }
        
        if !imageData.isEmpty {
        newItem.image = imageData
    }
        
        self.savedItems.append(newItem)
        saveData()
    }
    
    //passing the info through the storyboard to WebViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination: WebViewController = segue.destination as! WebViewController
        
        destination.urlString = webURLString
    }
    
}
