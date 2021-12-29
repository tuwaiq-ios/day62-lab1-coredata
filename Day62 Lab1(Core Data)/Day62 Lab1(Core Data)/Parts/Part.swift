
import UIKit
import CoreData

class PartVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    var supplier: Supplier?
    
    
    var fetchedResultsController: NSFetchedResultsController<Part>?
    
    lazy var tableView: UITableView = {
        let tablaView = UITableView()
        tablaView.translatesAutoresizingMaskIntoConstraints = false
        tablaView.delegate = self
        tablaView.dataSource = self
        tablaView.register(Cell3.self, forCellReuseIdentifier: Cell3.identifire)
        tablaView.backgroundColor = .white
        return tablaView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(add)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Part> = Part.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: false),
//            NSSortDescriptor(key: "lastName", ascending: false),
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataService.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        } catch {
            fatalError("The fetch could not be performd: \(error.localizedDescription)")
        }
    }
    

    @objc func add() {
        let newVC = NewPart()
        present(newVC, animated: true, completion: nil)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
    }
}

extension PartVC {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let orders = fetchedResultsController?.fetchedObjects else { return 0 }
        
        return orders.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifire, for: indexPath) as! Cell3
//        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "123")
        
        let order = fetchedResultsController?.fetchedObjects?[indexPath.row]
         print(order ?? 0)
         cell.label2.text = "Name: \(order?.name ?? "")"
         cell.label3.text = "Retail Price:\(order!.retailPrice)"
         cell.label6.text =  "Size: \(order!.size)"
         cell.image.image = UIImage(data: order!.image!)
//         cell.img.image = UIImage(data: order!.image!)
      

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex {
            return 370
        }else {
            return 225
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 let fetchSupplier = fetchedResultsController?.fetchedObjects?[indexPath.row]
        
     print(fetchSupplier)
    }

     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(
                    style: .destructive,
                    title: "Delete",
                    handler: { _, _, _ in
                        guard let order = self.fetchedResultsController?.fetchedObjects?[indexPath.row] else {
                            return
                        }
                        DataService.shared.viewContext.delete(order)
                        DataService.shared.saveContext()
                    }
                )
            ]
        )
    }
}


class Cell3: UITableViewCell {
    
    static let identifire = "Cell"
    
    public let label2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let label3: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir-Light", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let label4: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Light", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    public let label5: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir-Light", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let label6: UILabel = {
        let label = UILabel()
//        label.text = "a"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Light", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        //        image.backgroundColor = .yellow
        image.image = UIImage(systemName: "person")
    
        image.isUserInteractionEnabled = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = #colorLiteral(red: 1, green: 0.9926941103, blue: 0.9993625388, alpha: 1)
        contentView.layer.cornerRadius = 13
        

        
        self.addSubview(label2)
        self.addSubview(label3)
        self.addSubview(label4)
        self.addSubview(label6)
        self.addSubview(image)
        
        NSLayoutConstraint.activate([
            label2.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            label2.rightAnchor.constraint(equalTo: self.rightAnchor ),
            label2.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9),
            
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 10),
            label3.rightAnchor.constraint(equalTo: self.rightAnchor),
            label3.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9),
            
            label4.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 10),
            label4.rightAnchor.constraint(equalTo: self.rightAnchor),
            label4.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9),
            
            label6.topAnchor.constraint(equalTo: label4.bottomAnchor, constant: 10),
            label6.rightAnchor.constraint(equalTo: self.rightAnchor),
            label6.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9),
            image.topAnchor.constraint(equalTo: label6.bottomAnchor, constant: 10),
            image.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            image.heightAnchor.constraint(equalToConstant: 100),
            image.widthAnchor.constraint(equalToConstant: 100)
        ])
        
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        
 
        
        
        
    }
    
}
