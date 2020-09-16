//
//  ViewController.swift
//  Liverpool
//
//  Created by Daniel Liceaga on 15/09/20.
//  Copyright © 2020 Daniel Liceaga. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var productsTableView: UITableView!
    
    private var productList: [Producto] = []
    private var searchController : UISearchController!
    
    private var page: Int = 2
    private var criterio: String = ""
    private var append: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.register(UINib(nibName: "ProductoCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductoCellTableViewCell")
        
        setSearchBar()
    }
    
    private func setSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar en liverpool"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func getProducts() {
        LiverpoolGetProducts().getProducts(criterio: criterio, x: page) { (res) in
            if (self.append) {
                self.append = false
                self.productList.append(contentsOf: res)
            }
            else {
                self.productList = res
            }
            
            DispatchQueue.main.async {
                self.productsTableView.reloadData()
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        criterio = searchBar.text ?? ""
        getProducts()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        productList = []
        criterio =  ""
        page = 1
        productsTableView.reloadData()
    }
    
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getProducts(criterio: searchBar.text ?? "")
    }*/
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductoCellTableViewCell") as! ProductoCellTableViewCell
        let item = productList[indexPath.row]
        
        cell.titulo.text = item.titulo
        cell.precio.text = item.precio
        cell.categoria.text = item.categoria
        cell.thumbnail.sd_setImage(with: URL(string: item.thumbnail))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = productList.count - 1
        if indexPath.row == lastElement {
            page += 1
            getProducts()
            append = true
        }
    }
    
    
    
}

