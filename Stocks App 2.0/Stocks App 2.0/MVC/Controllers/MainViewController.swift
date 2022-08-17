import UIKit

class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        
        fetchUrl()
        tableViewData = fullDataForCells
        getFavouriteData()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.isHidden = true
        stocksLabel.isHidden = true
        showMoreButton.isHidden = true
        tableView.separatorStyle = .none
        searchTextField.isEnabled = true

        favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
        stocksMainButton.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(filterData), for: .editingChanged)
        searchTextField.addTarget(self, action: #selector(openReccomendations), for: .editingDidBegin)
        showMoreButton.addTarget(self, action: #selector(showMoreButtonPressed), for: .touchUpInside)
        
        view.backgroundColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        showMoreButton.isHidden = true
        stocksLabel.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        view.addSubview(tableView)
        view.addSubview(buttonsView)
        view.addSubview(collectionView)
        view.addSubview(stocksLabel)
        view.addSubview(showMoreButton)
        buttonsView.addSubview(stocksMainButton)
        buttonsView.addSubview(favouriteButton)
        view.addSubview(searchTextField)
        activateLayout()
    }
    
    //MARK: -Elements
    private let favouriteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Favourite", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitleColor(.gray, for: .normal)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
        return button
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 24
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.black.cgColor
        textField.attributedPlaceholder = NSAttributedString(
            string: "Find company or ticker",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        textField.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        
        textField.leftViewMode = .always
        
        let button = UIButton(frame: CGRect(x: 12, y: 12, width: 22, height: 24))
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        button.addTarget(MainViewController.self, action: #selector(mainButtonPressed), for: .touchUpInside)
        let containerImageView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        containerImageView.addSubview(button)
        textField.leftView = containerImageView
        return textField
    }()
    
    private let buttonsView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stocksMainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stocks", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return table
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register( CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collection.register(FirstHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FirstHeader.identifier)
        collection.register(SecondHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SecondHeader.identifier)
        return collection
    }()
    
    private let stocksLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 20)
        label.text = "Stocks"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let showMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show more", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.contentVerticalAlignment = .top
        return button
    }()
    
    
    private func activateLayout(){
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 48),
            
            buttonsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsView.heightAnchor.constraint(equalToConstant: 45),
            
            stocksMainButton.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.5),
            stocksMainButton.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 1),
            stocksMainButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            stocksMainButton.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
            
            favouriteButton.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 1),
            favouriteButton.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.5),
            favouriteButton.leadingAnchor.constraint(equalTo: stocksMainButton.trailingAnchor),
            favouriteButton.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
            
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stocksLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
            stocksLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksLabel.heightAnchor.constraint(equalToConstant: 24),
            stocksLabel.widthAnchor.constraint(equalToConstant: 70),
            
            showMoreButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
            showMoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showMoreButton.heightAnchor.constraint(equalToConstant: 16),
            showMoreButton.widthAnchor.constraint(equalToConstant: 90),
        ])
    }
    
    //Button actions
    @objc private func filterData(_ sender: UITextField){
//        changeTableViewOrientation()
        tableView.isHidden = false
        collectionView.isHidden = true
        stocksLabel.isHidden = false
        showMoreButton.isHidden = false
        
        var filteredData : [Stocks] = []
        if sender.text == ""{
            tableViewData  = fullDataForCells
            tableView.reloadData()
        }
        else if let text = sender.text {
            for object in fullDataForCells{
                if object.companyName.lowercased().contains(text.lowercased()) ||  object.ticker.lowercased().contains(text.lowercased()){
                    filteredData.append(object)
                }
            }
            tableViewData  = filteredData
            tableView.reloadData()
        }
    }
    
    @objc private func openReccomendations(){
        changeSearchLeftView("arrow.backward")
        tableView.isHidden = true
        favouriteButton.isHidden = true
        stocksMainButton.isHidden = true
        buttonsView.isHidden = true
        collectionView.isHidden = false
    }
    
    @objc private func favouriteButtonPressed(){
        recolorButton(favouriteButton)
        tableViewData = favouriteData
        tableView.reloadData()
    }
    
    @objc private func mainButtonPressed(){
        recolorButton(stocksMainButton)
        tableViewData = fullDataForCells
        tableView.reloadData()
    }
    
    @objc private func showMoreButtonPressed(){
        searchTextField.text = ""
        changeSearchLeftView("magnifyingglass")
        searchTextField.endEditing(true)
        favouriteButton.isHidden = false
        stocksMainButton.isHidden = false
        buttonsView.isHidden = false
        showMoreButton.isHidden = true
        stocksLabel.isHidden = true
//        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 145).isActive = false
//        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
//        view.layoutIfNeeded()
        mainButtonPressed()
    }
    
    //MARK: - Methods
    private func getFavouriteData(){
        favouriteData = []
        for object in fullDataForCells {
            if defaults.bool(forKey: object.ticker) {
                favouriteData.append(object)
            }
        }
    }
    
    private func recolorButton(_ sender: UIButton){
        if sender == stocksMainButton{
            sender.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 25)
            favouriteButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 20)
            sender.setTitleColor(.black, for: .normal)
            favouriteButton.setTitleColor(.lightGray, for: .normal)
        } else {
            stocksMainButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 20)
            sender.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 25)
            stocksMainButton.setTitleColor(.lightGray, for: .normal)
            sender.setTitleColor(.black, for: .normal)
        }
    }
    
//    private func changeTableViewOrientation(){
//        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = false
//        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 145).isActive = true
//        view.layoutIfNeeded()
//    }
    
    private func changeSearchLeftView(_ string: String){
        let button = UIButton(frame: CGRect(x: 12, y: 12, width: 22, height: 24))
        button.setImage(UIImage(systemName: string), for: .normal)
        button.tintColor = .black
        let containerImageView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        containerImageView.addSubview(button)
        searchTextField.leftView = containerImageView
    }
    var tableViewData: [Stocks]!
    var fullDataForCells: [Stocks]!
    var favouriteData: [Stocks]!
    let urlBase = "https://finnhub.io/api/v1/stock/profile2?symbol=" // provile 2
    let urlBase2 = "https://finnhub.io/api/v1/quote?symbol=" // quote data
    let apiKey = "cajddvaad3i94jmn55s0"
    
}

extension MainViewController: CustomTableViewCellDelegate {
    func starDidTapped(with cell: CustomTableViewCell) {
        guard let objectIndex = tableView.indexPath(for: cell) else {
            return
        }
        let pressedCell = tableViewData[objectIndex.item]
        if !defaults.bool(forKey: tableViewData[objectIndex.row].ticker) {
                defaults.set(true, forKey: pressedCell.ticker)
                favouriteData.append(pressedCell)
        } else {
            defaults.removeObject(forKey: pressedCell.ticker)
            if let index = favouriteData.firstIndex(of: pressedCell){
                favouriteData.remove(at: index)
            }
        }
    }
}

//MARK: -TableView extension
extension MainViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let graphViewController = GraphViewController()
        let favourite = defaults.bool(forKey: tableViewData[indexPath.row].ticker)
        graphViewController.name = tableViewData[indexPath.row].companyName
        graphViewController.ticker = tableViewData[indexPath.row].ticker
        graphViewController.price = tableViewData[indexPath.row].price
        graphViewController.difference = tableViewData[indexPath.row].difference
        graphViewController.favourite = favourite
        let yearData = fetchDataForGraph(ticker: tableViewData[indexPath.row].ticker, resolution: "30")
        graphViewController.yearData = yearData
        navigationController?.pushViewController(graphViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = view.frame.height/12 + 5
        return CGFloat(size)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as?     CustomTableViewCell else {
                return UITableViewCell()
            }
        if defaults.bool(forKey: tableViewData[indexPath.row].ticker) {
            cell.starButton.tintColor = UIColor(hexString: "#FFCA1C")
        } else {
            cell.starButton.tintColor = UIColor(hexString: "#BABABA")
        }
        
        cell.layer.cornerRadius = cell.frame.height/4.0
        cell.price.text = tableViewData[indexPath.row].price
        cell.companyName.text = tableViewData[indexPath.row].companyName
        cell.ticker.text = tableViewData[indexPath.row].ticker
        cell.difference.text = tableViewData[indexPath.row].difference
        cell.backgroundColor = recolorTableViewCell(index: indexPath.row)
        cell.difference.textColor = recolorDifference(index: indexPath.row)
        DispatchQueue.main.async {
            cell.companyImage.image = self.tableViewData[indexPath.row].companyImage.image
        }
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func recolorTableViewCell(index: Int) -> UIColor{
        if index % 2 == 0{
            return UIColor(hexString: "#CCF2F4")
        }
        return .white
    }
    
    func recolorDifference(index: Int) -> UIColor{
        let difference = tableViewData[index].difference
        if difference.first == "-"{
            return .red
        }
        return UIColor(red: 0.0745, green: 0.7569, blue: 0, alpha: 1.0) // green
    }
}


//MARK: - CollectionView
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var text: String!
        if indexPath.section == 0 {
            text = mostSearchs[indexPath.row]
        } else {
            text = lastSearchs[indexPath.row]
        }
        searchTextField.text = text
        filterData(searchTextField)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if(section==0) {
            return CGSize(width:collectionView.frame.size.width, height:70)
        } else {
            return CGSize(width:collectionView.frame.size.width, height:70)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview = UICollectionReusableView()
        if (kind == UICollectionView.elementKindSectionHeader) {
            let section = indexPath.section
            switch (section) {
            case 0:
                let  firstheader: FirstHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FirstHeader.identifier, for: indexPath) as! FirstHeader
                reusableview = firstheader
            case 1:
                let  secondheader: SecondHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SecondHeader.identifier, for: indexPath) as! SecondHeader
                reusableview = secondheader
            default:
                return reusableview
            }
        }
        return reusableview
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mostSearchs[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width + 40, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return mostSearchs.count
        }
        return lastSearchs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath)  as! CustomCollectionViewCell
        let section = indexPath.section
        if section == 0 {
            cell.textLabel.text = mostSearchs[indexPath.row]
        } else {
            cell.textLabel.text = lastSearchs[indexPath.row]
        }
        return cell
    }
}

//MARK: - Fetch url data

extension MainViewController {
    
    private func fetchUrl(){
        var stocks: [Stocks] = []
        for ticker in tickers {
            let urlString1 = urlBase  + ticker + "&token=" + apiKey
            let urlString2 = urlBase2 + ticker + "&token=" + apiKey
            let namesData = performRequestForNames(urlString: urlString1)
            var numbersData = performRequestForNumbers(urlString: urlString2)
            var diff = ""
            if numbersData[1].first == "-" {
                if let i = numbersData[1].firstIndex(of: "-") {
                    numbersData[1].remove(at: i)
                }
                if let i = numbersData[2].firstIndex(of: "-") {
                    numbersData[2].remove(at: i)
                }
                diff = "-$\(numbersData[1]) (\(numbersData[2])%)"
            } else {
                diff = "+$\(numbersData[1]) (\(numbersData[2])%)"
            }
            let image = UIImageView()
            image.loadFrom(urlString: namesData[1])
            let cellObject = Stocks(companyName: namesData[0], ticker: ticker, price: "$" + numbersData[0], difference: diff, companyImage: image)
            stocks.append(cellObject)
        }
        fullDataForCells = stocks
    }
    
    
    private func performRequestForNumbers(urlString: String)->[String]{
        var numbersData: [String] = []
        let group = DispatchGroup()
        group.enter()
        if let url = URL(string: urlString){
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    numbersData = self.parseJSONNumbers(stocksData: safeData)
                    group.leave()
                }
            }
            task.resume()
            
        }
        group.wait()
        return numbersData
    }
    
    
    private func performRequestForNames(urlString: String) -> [String] {
        var namesData: [String] = []
        guard let url = URL(string: urlString) else {
            return []
        }
        let group = DispatchGroup()
        group.enter()
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print(error!)
                return
            }
            if let safeData = data {
                namesData = self.parseJSONNames(stocksData: safeData)
                group.leave()
            }
        }
        task.resume()
        group.wait()
        return namesData
    }
    
    private func parseJSONNames(stocksData: Data) -> [String]{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(ProfileURL.self, from: stocksData)
            print(decodedData.name)
            return [decodedData.name, decodedData.logo]
        } catch {
            print(error)
        }
        return []
    }
    
    private func parseJSONNumbers(stocksData: Data)->[String]{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(QuoteURL.self, from: stocksData)
            return[String(format:"%.2f", decodedData.c), String(format:"%.2f", decodedData.d), String(format:"%.2f", decodedData.dp)]
        } catch {
            print(error)
        }
        return []
    }
}









































//class Assembly {
//    func makeMainView() -> UIViewController {
//        let controller = MainViewController()
//
//        let mainView = MainView(controller: controller)
//        controller.connectedView = mainView
//
//        return mainView
//    }
//}
//
//class MainViewController: UIViewController {
//    weak var connectedView: MainView?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        controller.fetchData()
//    }
//
////    func fetchData() {
//////        var stocks: [Stock]
//////        view?.updateStocks(stocks)
////    }
//}


//    let controller: MainViewController!
//    // MARK: - Init
//
//    init(controller: MainViewController) {
//        self.controller = controller
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
