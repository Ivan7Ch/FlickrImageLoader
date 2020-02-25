//
//  ImageLoader.swift
//  SimpleFlickrImageLoader
//
//  Created by Ivan Chernetskiy on 25.02.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


struct SearchModel: Codable {
    let photos: Photos
    let stat: String
}


struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}


struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}


struct FetchedPhoto: Codable {
    let sizes: Sizes
    let stat: String
}


struct Sizes: Codable {
    let canblog, canprint, candownload: Int
    let size: [Size]
}


struct Size: Codable {
    let label: String
    let width, height: Int
    let source: String
    let url: String
    let media: Media
}


enum Media: String, Codable {
    case photo = "photo"
}



class ImageLoader {
    
    private let flickrKey = "d51b387da45dc5a3a9a34dfff8f73623"
    
    private var components: URLComponents
    
    
    init() {
        components = URLComponents()
        
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest/"
    }
    
    
    private func createPhotosSetURL(with searchText: String) -> URL {
        
        let queryItemMethod = URLQueryItem(name: "method", value: "flickr.photos.search")
        let queryItemToken = URLQueryItem(name: "api_key", value: flickrKey)
        let queryItemQuery = URLQueryItem(name: "tags", value: searchText)
        let queryItem1 = URLQueryItem(name: "per_page", value: "1")
        let queryItem2 = URLQueryItem(name: "format", value: "json")
        let queryItem3 = URLQueryItem(name: "nojsoncallback", value: "1")
        
        components.queryItems = [queryItemMethod, queryItemToken, queryItemQuery, queryItem1, queryItem2, queryItem3]
        
        return components.url!
    }
    
    
    private func createPhotoURL(by id: String) -> URL {
        
        let queryItemMethod = URLQueryItem(name: "method", value: "flickr.photos.getSizes")
        let queryItemToken = URLQueryItem(name: "api_key", value: flickrKey)
        let queryItemQuery = URLQueryItem(name: "photo_id", value: id)
        let queryItem1 = URLQueryItem(name: "format", value: "json")
        let queryItem2 = URLQueryItem(name: "nojsoncallback", value: "1")
        
        components.queryItems = [queryItemMethod, queryItemToken, queryItemQuery, queryItem1, queryItem2]
        
        return components.url!
    }
    
    
    private func fetchPhotoId(for searchText: String, completion: @escaping ((String) -> ())) {
        let url = createPhotosSetURL(with: searchText)
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let photosSet = try decoder.decode(SearchModel.self, from: data!)
                guard let firstPhoto = photosSet.photos.photo.first else { return }
                completion(firstPhoto.id)
                
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
    private func getPhotoSource(by id: String, completion: @escaping ((String) -> ())) {
        let url = createPhotoURL(by: id)
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let myResult = try decoder.decode(FetchedPhoto.self, from: data!)
//                let index = Int.random(in: 0...myResult.sizes.size.count-1)
                let index = 0
                completion(myResult.sizes.size[index].source)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
    private func fetchPhoto(by urlString: String, completion: @escaping ((UIImage) -> ())) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            completion(image)
        }.resume()
    }
    
    
    func loadPhoto(by urlString: String, completion: @escaping ((UIImage) -> ())) {
        fetchPhotoId(for: urlString, completion: {
            self.getPhotoSource(by: $0, completion: { source in
                self.fetchPhoto(by: source, completion: { image in
                    completion(image)
                })
            })
        })
    }
    
}

