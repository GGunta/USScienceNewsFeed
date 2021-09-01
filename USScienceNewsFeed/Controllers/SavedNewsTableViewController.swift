//
//  SavedNewsTableViewController.swift
//  USScienceNewsFeed
//
//  Created by gunta.golde on 18/08/2021.
//

import UIKit
import CoreData

class SavedNewsTableViewController: UITableViewController {
    
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
        
    @IBOutlet weak var editButtonTitle: UIBarButtonItem!
    
    //way how app is loading and saving the data inside the local storage
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        loadData()
        countItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        countItems()
    }
    
    //basicAlert (UIAlert) customized as a message that article is deleted from CoreData
    func saveData(){
        do{
            try context?.save()
            basicAlert(title: "Deleted!", message: "You've deleted saved article from CoreData")
        }catch{
            print(error.localizedDescription)
        }
        loadData()
    }
    
    //allows to load fetched and saved articles. if something goes wrong with saved articles, it will be presented in console as an error
    func loadData() {
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        do{
            savedItems = try (context?.fetch(request))!
            tableView.reloadData()
        }catch{
            fatalError("Error in retrieving saved items")
        }
        tableView.reloadData()
    }
    
    //func to count how many articles have been saved
    func countItems() {
        let itemsInTable = String(self.tableView.numberOfRows(inSection: 0))
        self.title = "Saved (\(itemsInTable))"
    }
    
    //basicAlert (UIAlert) customized as a info button message where to find all saved articles
    @IBAction func infoButtonTapped(_ sender: Any) {
        basicAlert(title: "Saved articles info", message: "All articles that you saved in Top Headlines News Feed can be found there")
    }
    
    //func alows to edit saved articles: reorganize, delete
    @IBAction func editButtonTapped(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        if tableView.isEditing {
            editButtonTitle.title = "Save"
        }else{
            editButtonTitle.title = "Edit"
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return savedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedFeedCell", for: indexPath) as? NewsTableViewCell else{
            return UITableViewCell()
        }
        
        let item = savedItems[indexPath.row]
        cell.newsTitleLabel.text = item.newsTitle
        cell.newsTitleLabel.numberOfLines = 0
        
        if let image = UIImage(data: item.image!){
            cell.newsImageView.image = image
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController else {
            return
        }
        self.title = "Saved"
        
        vc.urlString = savedItems[indexPath.row].url ?? "https://blog.thomasnet.com/hs-fs/hubfs/shutterstock_774749455.jpg?width=1200&name=shutterstock_774749455.jpg"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Override to support editing the table view with customized UIAlert as a warning about deleting the article.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete saved article?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
                let item = self.savedItems[indexPath.row]
                self.context?.delete(item)
                self.saveData()
            }))
            self.present(alert, animated: true)
        }
    }
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let row = savedItems.remove(at: fromIndexPath.row)
        savedItems.insert(row, at: to.row)
    }
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
}
