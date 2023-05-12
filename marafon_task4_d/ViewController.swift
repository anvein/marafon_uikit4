import UIKit

struct Model {
    var title: String
    var isSelected: Bool
}

class ViewController: UIViewController {

    var list = [Model]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundView = UIView()
        tableView.tableFooterView = UIView()
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layer.cornerRadius = 15
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addSubview()
        setupViews()
        setupConstraints()
        
        for number in 1...30 {
            list.append(Model(title: String(number), isSelected: false))
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleTable))
        navigationItem.title = "task 4"

        
        tableView.reloadData()
    }
    
    
    @objc func shuffleTable() {
        
        var copyOfListForShuffle = list

        copyOfListForShuffle.shuffle()

        tableView.beginUpdates()

        for (index, item) in list.enumerated() {
            let newItemIndex = copyOfListForShuffle.firstIndex { $0.title == item.title }
            
            guard let newItemIndex else { return }

            tableView.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: newItemIndex, section: 0))
        }
        
        list = copyOfListForShuffle
        
        tableView.endUpdates()
    }
    
    // MARK: - Создание и настройка интерфейса
    
    func addSubview() {
        view.addSubview(tableView)
    }
    
    func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.9490073323, green: 0.9455509782, blue: 0.9702795148, alpha: 1)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isSelected ? .checkmark : .none
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        if list[indexPath.row].isSelected {
            list[indexPath.row].isSelected.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            list[indexPath.row].isSelected.toggle()
            
            cell.accessoryType = list[indexPath.row].isSelected ? .checkmark : .none
            
            tableView.beginUpdates()
            
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            
            list.insert(list[indexPath.row], at: 0)
            list.remove(at: indexPath.row + 1)
            
            tableView.endUpdates()
        }

    }
}
