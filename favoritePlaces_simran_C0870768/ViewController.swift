//
//  ViewController.swift
//  favoritePlaces_simran_C0870768
//
//  Created by simran mehra on 2023-01-24.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var models = [String]()
    func didSelectAnnotation(title: String) {
        models.append(title)
        favouritePlaces.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    @IBOutlet weak var favouritePlaces: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourite Places"
        favouritePlaces.delegate = self
        favouritePlaces.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        // getAllItems()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let model = UserDefaults.standard.array(forKey: "favorite_places") as? [String] {
            self.models = model
        }
        favouritePlaces.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        UserDefaults.standard.set(models, forKey: "favorite_addresses")
        UserDefaults.standard.synchronize()
        
        super.viewWillDisappear(animated)
    }
    @objc private func didTapAdd(){
        performSegue(withIdentifier: "second", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "second" {
            guard let vc = segue.destination as? mapViewVC else { return }
            vc.delegate = self
        }
    }
}
    extension ViewController {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedModel = models[indexPath.row]
            let mapVC = storyboard!.instantiateViewController(withIdentifier: "second") as! mapViewVC
            mapVC.selectedModels = selectedModel
            navigationController?.pushViewController(mapVC, animated: true)
        }
    
    // Core Data methods
    //        func getAllItems(){
    //            do{
    //                models = try context.fetch(Place.fetchRequest())
    //                DispatchQueue.main.async {
    //                    self.favouritePlaces.reloadData()
    //                }
    //            }
    //            catch{
    //                //error
    //                print(error)
    //            }
    //        }
    //
    //        func createItem(name:String, country:String ,longitude:Decimal, latitude:Decimal, city:String){
    //            let newitem = Place(context: context)
    //            newitem.name = name
    //            newitem.country = country
    //            newitem.latitude = (latitude) as NSDecimalNumber
    //            newitem.longitude = (longitude) as NSDecimalNumber
    //            newitem.city = city
    //            models.append(newitem)
    //            do{
    //                try context.save()
    //                getAllItems()
    //            }
    //            catch{
    //                //error
    //                print(error)
    //            }
    //        }
    //
    //        func deleteItem(item : Place){
    //            context.delete(item)
    //            do{
    //                try context.save()
    //            }
    //            catch{
    //                //error
    //                print(error)
    //            }
    //        }
    //
    //        func updateItem(item : Place){
    //            let alert = UIAlertController(title: "Edit Place", message: "Enter the new name of the place:", preferredStyle: .alert)
    //            alert.addTextField { (textField) in
    //            textField.text = item.name
    //            }
    //            let updateAction = UIAlertAction(title: "Update", style: .default) { (action) in
    //            let newName = alert.textFields![0].text!
    //            self.updateItem(item: item, newName: newName)
    //            self.getAllItems()
    //            }
    //            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    //            alert.addAction(updateAction)
    //            alert.addAction(cancelAction)
    //            present(alert, animated: true, completion: nil)
    //            }
    //
    //            func updateItem(item : Place, newName : String){
    //                item.name = newName
    //                do{
    //                    try context.save()
    //                }
    //                catch{
    //                    //error
    //                    print(error)
    //                }
    //            }
    //            }
    //
    //        // Implementing delegate methods
    ////        extension ViewController: mapViewVCDelegate {
    ////        func didAddPlace(name: String, country: String) {
    ////        createItem(name: name, country: country)
    ////        }
    ////        }
    //
    //
    
    //    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
    //                let model = self.models[indexPath.row]
    //                self.deleteItem(item: model)
    //                self.models.remove(at: indexPath.row)
    //                tableView.deleteRows(at: [indexPath], with: .fade)
    //            }
    //            deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.red)
    //            deleteAction.backgroundColor = .red
    //
    //            let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
    //                let model = self.models[indexPath.row]
    //              // self.updateItem(item: model, newName:model )
    //            }
    //            editAction.image = UIImage(systemName: "pencil")?.withTintColor(.blue)
    //            editAction.backgroundColor = .blue
    //
    //            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    //            return configuration
    //        }
    
}


    
