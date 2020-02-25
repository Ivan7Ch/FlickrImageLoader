//
//  ImagesViewController.swift
//  SimpleFlickrImageLoader
//
//  Created by Ivan Chernetskiy on 25.02.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


struct ImageModel {
    let name: String?
    let image: UIImage?
}


class ImagesViewController: UIViewController {
    
    private var images = [ImageModel]()
    
    let imagesTableView = UITableView()
    
    var searchBar: UISearchBar = UISearchBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images = RealmManager().retrieveAllImages()
        
        setupTableView()
        setupSearchBar()
        imagesTableView.keyboardDismissMode = .onDrag
    }
    
    
    private func setupTableView() {
        view.addSubview(imagesTableView)
        
        imagesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        imagesTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        imagesTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        imagesTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        imagesTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        imagesTableView.dataSource = self
        imagesTableView.delegate = self
        
        imagesTableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "imageCell")
    }
    
    
    private func setupSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    
    private func appendNewItem(imageModel: ImageModel) {
        RealmManager().saveImage(image: imageModel)
        self.images.insert(imageModel, at: 0)
        self.imagesTableView.reloadData()
    }
}


extension ImagesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageTableViewCell
        
        cell.imageModel = images[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}


extension ImagesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let tag = searchBar.text else { return }
        
        ImageLoader().loadPhoto(by: tag){ image in
            DispatchQueue.main.async {
                let imageModel = ImageModel(name: tag, image: image)
                self.appendNewItem(imageModel: imageModel)
            }
        }
    }
}
