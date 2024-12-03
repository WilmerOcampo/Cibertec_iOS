//
//  BookViewController.swift
//  Cibertec
//
//  Created by Wilmer Ocampo on 3/12/24.
//

import UIKit

struct Book {
    let title: String
    let author: String
    let price: String
    let description: String
    let cover: String
}

class BookViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var bookTableView: UITableView!
    
    var bookList: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookTableView.dataSource = self // delegate
        loadData()
    }
    
    private func loadData(){
        let book1 = Book(title: "1 Cien a~os de soledad", author: "Gabriel Garcia Marquez", price: "50.00", description: "Se cuenta la historia de la familia Buendia", cover: "cibertec_logo")
        let book2 = Book(title: "2 Cien a~os de soledad", author: "Gabriel Garcia Marquez", price: "50.00", description: "Se cuenta la historia de la familia Buendia", cover: "cibertec_logo")
        
        bookList.append(book1)
        bookList.append(book2)
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookCell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTableViewCell
        
        let book = bookList[indexPath.row]
        bookCell.titleLabel.text = book.title
        bookCell.authorLabel.text = book.author
        bookCell.priceLabel.text = book.price
        bookCell.descriptionLabel.text = book.description
        bookCell.coverImageView.image = UIImage(named: book.cover)
        
        return bookCell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
