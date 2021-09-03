//
//  Item.swift
//  USScienceNewsFeed
//
//  Created by gunta.golde on 17/08/2021.
//

import UIKit
import Gloss

//based on the JSON which is what the API is giving to me, I can take specific key (description, title, image etc.) and use it to display in my app
class Item: JSONDecodable {
    
    var description: String
    var title: String
    var url: String
    var urlToImage: String
    var image: UIImage?
    var publishedAt: String
    
    
    required init?(json: JSON) {
        self.description = "description" <~~ json ?? ""
        self.title = "title" <~~ json ?? ""
        self.url = "url" <~~ json ?? ""
        self.urlToImage = "urlToImage" <~~ json ?? ""
        self.publishedAt = "publishedAt" <~~ json ?? ""
        
        DispatchQueue.main.async {
            self.image = self.laodImage()
        }
        
    }
    
    private func laodImage() -> UIImage? {
        var returnImage: UIImage?
        
        guard let url = URL(string: urlToImage) else {
            return returnImage
        }
        
        if let data = try? Data(contentsOf: url){
            if let image = UIImage(data: data){
                returnImage = image
            }
        }
        return returnImage
    }

}
