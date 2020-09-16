//
//  ViewController.swift
//  Liverpool
//
//  Created by Daniel Liceaga on 15/09/20.
//  Copyright © 2020 Daniel Liceaga. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var productsTableView: UITableView!
    
    private var productList: [Producto] = []
    private var searchController : UISearchBar!
   
    private var page: Int = 2
    private var criterio: String = ""
    private var append: Bool = false
    
    private var busquedas: [NSManagedObject] = []
    private var coreDataManager: CoreDataManager!
    private var searching: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.register(UINib(nibName: "ProductoCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductoCellTableViewCell")
         
        setSearchBar()
        
        coreDataManager = CoreDataManager()
        busquedas = coreDataManager.get(entity: "Busquedas").reversed()
    }
    
    private func setSearchBar() {
        searchController = UISearchBar()
        searchController.delegate = self
        searchController.barTintColor = .white
        searchController.searchBarStyle = .minimal
        searchController.placeholder = "Buscar en liverpool"
        navigationItem.titleView = searchController
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
            
            let attributes = ["criterio": self.criterio]
            let predicate = NSPredicate(format: "criterio == %@", self.criterio)
            self.coreDataManager.save(entity: "Busquedas", attributes: attributes, predicate: predicate)
            self.busquedas = self.coreDataManager.get(entity: "Busquedas").reversed()
            
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
        searching = false
        productsTableView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searching = true
        productsTableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
        productsTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let predicate = NSPredicate(format: "(criterio CONTAINS[cd] %@)", searchText)
        busquedas = coreDataManager.get(entity: "Busquedas", predicate: searchText.isEmpty ? nil : predicate).reversed()
        productsTableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? busquedas.count : productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searching {
            let cell = UITableViewCell()
            let item = busquedas[indexPath.row]
            cell.textLabel?.text = item.value(forKey: "criterio") as? String
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductoCellTableViewCell") as! ProductoCellTableViewCell
            let item = productList[indexPath.row]
            
            cell.titulo.text = item.titulo
            cell.precio.text = item.precio
            cell.categoria.text = item.categoria
            cell.thumbnail.sd_setImage(with: URL(string: item.thumbnail))
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return searching ? 40.0 : 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (searching) {
            if let crit = busquedas[indexPath.row].value(forKey: "criterio") as? String {
                criterio = crit
                searching = false
                searchController.endEditing(true)
                getProducts()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !searching {
            let lastElement = productList.count - 1
            if indexPath.row == lastElement {
                page += 1
                getProducts()
                append = true
            }
        }
    }
    
    
    
}

