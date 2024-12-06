//
//  ContactViewController.swift
//  Cibertec
//
//  Created by Wilmer Ocampo on 3/12/24.
//

import UIKit
import CoreData

enum OperationType {
    case register
    case edit
}

class ContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var contacTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var contactList: [ContactEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacTableView.dataSource = self
        contacTableView.delegate = self
        searchBar.delegate = self
        findAllCoreData()
    }
    
    
    @IBAction func register(_ sender: Any) {
        showAlertRegister(type: .register, contact: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        let contact = contactList[indexPath.row]
        cell.nameLabel.text = "Nombres: \(contact.name ?? "")"
        cell.numberLabel.text = "Numero: \(contact.number ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ /*contact*/ = contactList[indexPath.row]
    }
    // desde la derecha
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar", handler: {_, _, complete in
            let contact = self.contactList[indexPath.row]
            self.deleteCoreData(index: indexPath, contact: contact)
            complete(true)
        })
        deleteAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .normal, title: "Editar", handler: {_, _, complete in
            let contact = self.contactList[indexPath.row]
            self.showAlertRegister(type: .edit, contact: contact)
            //self.editCoreData(contact: contact, name: contact.name, number: contact.number)
            complete(true)
        })
        editAction.backgroundColor = .green
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    // desde la izquierda
    /*func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }*/
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            findAllCoreData()
        } else {
            self.searchCoreData(query: searchText)
        }
    }

}

extension ContactViewController {
    func showAlertBasic(){
        let alert = UIAlertController(title: "Cibertec", message: "Verifique sus credenciales", preferredStyle: .alert)
        let action = UIAlertAction(title: "Entiendo", style: .default, handler: {_ in
            print("Entiendo seleccionado")
        })
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel)
        let actionDelete = UIAlertAction(title: "Eliminar", style: .destructive)
        alert.addAction(action)
        alert.addAction(actionCancel)
        alert.addAction(actionDelete)
        present(alert, animated: true)
    }
    
    func showAlertRegister(type: OperationType, contact: ContactEntity?){
        var nameText = UITextField()
        var numberText = UITextField()
        let title = (type == .register) ? "Registrar" : "Editar"
        let alert = UIAlertController(title: title, message: "Se guaradara en su telefono", preferredStyle: .alert)
        alert.addTextField { text in
            text.placeholder = "Ingrese el Nombre"
            nameText = text
            nameText.text = (type == .edit) ? contact?.name : ""
        }
        alert.addTextField { text in
            text.placeholder = "Ingrese el Numero"
            numberText = text
            numberText.text = (type == .edit) ? contact?.number : ""
        }
        let action = UIAlertAction(title: title, style: .default, handler: {_ in
            let name = nameText.text!
            let number = numberText.text!
            if (type == .register) {
                self.registerCoreData(name: name, number: number)
            } else {
                if let contact = contact {
                    self.editCoreData(contact: contact, name: name, number: number)
                }
            }
        })
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
}

extension ContactViewController {
    func registerCoreData(name: String, number: String){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let entity = ContactEntity(context: context)
        entity.name = name
        entity.number = number
        do {
            try context.save()
            self.contactList.append(entity)
        } catch let error as NSError {
            print(error)
        }
        self.contacTableView.reloadData()
    }
    func findAllCoreData(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        do {
            let contacts = try context.fetch(ContactEntity.fetchRequest())
            self.contactList = contacts
        } catch let error as NSError {
            print(error)
        }
        self.contacTableView.reloadData()
    }
    
    func editCoreData(contact: ContactEntity, name: String, number: String){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        contact.name = name
        contact.number = number
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
        self.contacTableView.reloadData()
    }
    
    func deleteCoreData(index: IndexPath, contact: ContactEntity){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        context.delete(contact)
        
        do {
            try context.save()
            contactList.remove(at: index.row)
            contacTableView.deleteRows(at: [index], with: .automatic)
        } catch let error as NSError {
            print(error)
        }
        self.contacTableView.reloadData()
    }
    
    func searchCoreData(query: String){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[c] %@ OR number CONTAINS[c] %@", query, query)
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request)
            contactList = result
        } catch let error as NSError {
            print(error)
        }
        contacTableView.reloadData()
    }
}
