//
//  ViewController.swift
//  favoritePlaces_simran_C0870768
//
//  Created by simran mehra on 2023-01-24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [Place]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = Place.name
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
        {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
                print("Delete Action Tapped")
            }
            deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.red)
            deleteAction.backgroundColor = .red
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        }
    @IBOutlet weak var favouritePlaces: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourite Places"
        favouritePlaces.delegate = self
        favouritePlaces.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        // Do any additional setup after loading the view.
    }
    
    @objc private func didTapAdd(){
        performSegue(withIdentifier: "second", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "second" {
            guard let vc = segue.destination as? mapViewVC else { return }
           
        }
    }
    // core data
//    func getAllItems(){
//        do{
//            Place = try context.fetch(Place.fetchRequest())
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//
//
//        }
//        catch{
//            //error
//        }
//    }
//    func createItem(name:String){
//        let newitem = Place(context: context)
//        newitem.name = name
//        newitem.country = country
//        self.models.append(newitem)
//        do{
//            try context.save()
//            getAllItems()
//        }
//        catch{
//            //error
//        }
//    }
//
    func deleteItem(item : Place){
        context.delete(item)
        do{
            try context.save( )
        }
        catch{
            //error
        }
    }
    
    func updateItem(item : Place, newName : String){
        item.name = newName
        do{
            try context.save( )
        }
        catch{
            //error
        }
    }
    
}





