import UIKit
import Charts

class GraphViewController: UIViewController, UICollectionViewDelegateFlowLayout, ChartViewDelegate {

    var name: String = ""
    var ticker: String = ""
    var price: String = ""
    var difference: String = ""
    var favourite: Bool = false
    var yearData: [Double] = []
    private let apiKey = "cajddvaad3i94jmn55s0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.backgroundColor = .white
        graph.delegate = self
        availableLabel.isHidden = true
        premiumImage.isHidden = true
        title = ""
        labelsCollectionView.delegate = self
        labelsCollectionView.dataSource = self
        labelsCollectionView.register( LabelsCollectionViewCell.self, forCellWithReuseIdentifier: LabelsCollectionViewCell.identifier)
        
        dayButton.addTarget(self, action: #selector(periodButtonPressed), for: .touchUpInside)
        weekButton.addTarget(self, action: #selector(periodButtonPressed), for: .touchUpInside)
        monthButton.addTarget(self, action: #selector(periodButtonPressed), for: .touchUpInside)
        halfYearButton.addTarget(self, action: #selector(periodButtonPressed), for: .touchUpInside)
        yearButton.addTarget(self, action: #selector(periodButtonPressed), for: .touchUpInside)
        
        periodButtonPressed(yearButton)
        setChart(values: yearData, graph)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(buyButton)
        view.addSubview(timeButtonsView)
        timeButtonsView.addSubview(dayButton)
        timeButtonsView.addSubview(weekButton)
        timeButtonsView.addSubview(monthButton)
        timeButtonsView.addSubview(halfYearButton)
        timeButtonsView.addSubview(yearButton)
        view.addSubview(premiumImage)
        view.addSubview(availableLabel)
        view.addSubview(tickerLabel)
        view.addSubview(companyNameLabel)
        view.addSubview(labelsCollectionView)
        view.addSubview(labelPrice)
        view.addSubview(labelPriceDifference)
        view.addSubview(starButton)
        view.addSubview(reclama)
        changeStarColor()
        
        buyButton.setTitle("Buy for \(price)", for: .normal)
        companyNameLabel.text = "\(name)"
        tickerLabel.text = "\(ticker)"
        labelPrice.text = "\(price)"
        labelPriceDifference.text = "\(difference)"
        view.addSubview(graph)
        activateLayaout()
    }
    
    private var graph: LineChartView = {
        let line = LineChartView()
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    private let buyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.tintColor = .white
        return button
    }()
    
    private let timeButtonsView: UIView = {
        let timesView = UIView()
        timesView.translatesAutoresizingMaskIntoConstraints = false
        timesView.backgroundColor = .white
        return timesView
    }()
    
    var selectedPaths:IndexPath!
    
    private let dayButton: UIButton = {
        let button = UIButton()
        button.setTitle("D", for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hexString: "#F0F4F7")
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
   private let weekButton: UIButton = {
       let button = UIButton()
       button.setTitle("W", for: .normal)
       button.layer.cornerRadius = 12
       button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 12)
       button.translatesAutoresizingMaskIntoConstraints = false
       button.backgroundColor = UIColor(hexString: "#F0F4F7")
       button.setTitleColor(.black, for: .normal)
       return button
       
   }()
   private let monthButton: UIButton = {
       let button = UIButton()
       button.setTitle("M", for: .normal)
       button.layer.cornerRadius = 12
       button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 12)
       button.translatesAutoresizingMaskIntoConstraints = false
       button.backgroundColor = UIColor(hexString: "#F0F4F7")
       button.setTitleColor(.black, for: .normal)
       return button
       
   }()
   private let halfYearButton: UIButton = {
       let button = UIButton()
       button.setTitle("6M", for: .normal)
       button.layer.cornerRadius = 12
       button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 12)
       button.translatesAutoresizingMaskIntoConstraints = false
       button.backgroundColor = UIColor(hexString: "#F0F4F7")
       button.setTitleColor(.black, for: .normal)
       return button
       
   }()
   private let yearButton: UIButton = {
       let button = UIButton()
       button.setTitle( "Y", for: .normal)
       button.layer.cornerRadius = 12
       button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 12)
       button.translatesAutoresizingMaskIntoConstraints = false
       button.backgroundColor = UIColor(hexString: "#F0F4F7")
       button.setTitleColor(.black, for: .normal)
       return button
       
   }()
    
    
    private let premiumImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "premium")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let reclama: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "reclama")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let availableLabel: UILabel = {
        let label = UILabel()
        label.text = "Available only for premium users"
        label.font = UIFont(name: "Montserrat-Bold", size: 20)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tickerLabel: UILabel = {
        let labelTicker = UILabel()
        labelTicker.font = UIFont(name: "Montserrat-Bold", size: 18)
        labelTicker.textColor = .black
        labelTicker.translatesAutoresizingMaskIntoConstraints = false
        return labelTicker
    }()
    
    private let companyNameLabel: UILabel = {
        let labelCompany = UILabel()
        labelCompany.font = UIFont(name: "Montserrat-Regular", size: 12)
        labelCompany.textColor = .black
        labelCompany.translatesAutoresizingMaskIntoConstraints = false
        return labelCompany
    }()
    
    var starButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "star.fill")
        button.tintColor = UIColor(hexString: "#BABABA")
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let labelsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let labelPriceDifference: UILabel = {
        let labely = UILabel()
        labely.text = "+$2.21 (1.62%)"
        labely.textColor = .green
        labely.font = UIFont(name: "Montserrat-Regular", size: 12)
        labely.translatesAutoresizingMaskIntoConstraints = false
        return labely
    }()
    

    private let labelPrice: UILabel = {
        let labelx = UILabel()
        labelx.text = "$138.93"
        labelx.textColor = .black
        labelx.font = UIFont(name: "Montserrat-Bold", size: 32)
        labelx.translatesAutoresizingMaskIntoConstraints = false
        return labelx
    }()

    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func activateLayaout(){
        NSLayoutConstraint.activate([
            buyButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16),
            buyButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -16),
            buyButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            buyButton.heightAnchor.constraint(equalToConstant: 56),
            
            timeButtonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16),
            timeButtonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -16),
            timeButtonsView.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -52),
            timeButtonsView.heightAnchor.constraint(equalToConstant: 44),
            
            dayButton.topAnchor.constraint(equalTo: timeButtonsView.topAnchor),
            dayButton.bottomAnchor.constraint(equalTo: timeButtonsView.bottomAnchor),
            dayButton.trailingAnchor.constraint(equalTo: weekButton.leadingAnchor, constant: -10),
            dayButton.widthAnchor.constraint(equalToConstant: 45),
            
            weekButton.topAnchor.constraint(equalTo: timeButtonsView.topAnchor),
            weekButton.bottomAnchor.constraint(equalTo: timeButtonsView.bottomAnchor),
            weekButton.trailingAnchor.constraint(equalTo: monthButton.leadingAnchor, constant: -10),
            weekButton.widthAnchor.constraint(equalToConstant: 45),
            
            monthButton.topAnchor.constraint(equalTo: timeButtonsView.topAnchor),
            monthButton.bottomAnchor.constraint(equalTo: timeButtonsView.bottomAnchor),
            monthButton.centerXAnchor.constraint(equalTo: timeButtonsView.centerXAnchor),
            monthButton.widthAnchor.constraint(equalToConstant: 45),
            
            halfYearButton.topAnchor.constraint(equalTo: timeButtonsView.topAnchor),
            halfYearButton.bottomAnchor.constraint(equalTo: timeButtonsView.bottomAnchor),
            halfYearButton.leadingAnchor.constraint(equalTo: monthButton.trailingAnchor, constant: 10),
            halfYearButton.widthAnchor.constraint(equalToConstant: 45),
            
            yearButton.topAnchor.constraint(equalTo: timeButtonsView.topAnchor),
            yearButton.bottomAnchor.constraint(equalTo: timeButtonsView.bottomAnchor),
            yearButton.leadingAnchor.constraint(equalTo: halfYearButton.trailingAnchor, constant: 10),
            yearButton.widthAnchor.constraint(equalToConstant: 45),
            
            premiumImage.heightAnchor.constraint(equalToConstant: 260),
            premiumImage.widthAnchor.constraint(equalToConstant: 260),
            premiumImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            premiumImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            reclama.heightAnchor.constraint(equalToConstant: view.frame.width-32),
            reclama.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            reclama.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            reclama.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reclama.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            availableLabel.bottomAnchor.constraint(equalTo: reclama.topAnchor, constant: -20),
            availableLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tickerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tickerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 42),
            tickerLabel.heightAnchor.constraint(equalToConstant: 24),
            
            companyNameLabel.topAnchor.constraint(equalTo: tickerLabel.bottomAnchor, constant: 4),
            companyNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            labelsCollectionView.topAnchor.constraint(equalTo: companyNameLabel.topAnchor, constant: 24),
            labelsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            labelsCollectionView.heightAnchor.constraint(equalToConstant: 24),
            
            labelPriceDifference.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelPriceDifference.bottomAnchor.constraint(equalTo: timeButtonsView.topAnchor, constant: -350),
            labelPriceDifference.heightAnchor.constraint(equalToConstant: 16),
            
            labelPrice.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelPrice.bottomAnchor.constraint(equalTo: labelPriceDifference.topAnchor, constant: -8),
            labelPrice.heightAnchor.constraint(equalToConstant: 32),
            
            graph.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graph.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graph.bottomAnchor.constraint(equalTo: timeButtonsView.topAnchor, constant: -40),
            graph.heightAnchor.constraint(equalToConstant: 260),
            
            starButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 54),
            starButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            starButton.heightAnchor.constraint(equalToConstant: 22),
            starButton.widthAnchor.constraint(equalToConstant: 22),
        ])
    }
    
    private func changeStarColor(){
        if favourite {
            starButton.tintColor = UIColor(hexString: "#FFCA1C")
        }
        else{
            starButton.tintColor = UIColor(hexString: "#BABABA")
        }
    }
    @objc func periodButtonPressed(_ sender: UIButton){
        dayButton.backgroundColor = UIColor(hexString: "#F0F4F7")
        dayButton.setTitleColor(.black, for: .normal)
        
        weekButton.backgroundColor = UIColor(hexString: "#F0F4F7")
        weekButton.setTitleColor(.black, for: .normal)
        
        monthButton.backgroundColor = UIColor(hexString: "#F0F4F7")
        monthButton.setTitleColor(.black, for: .normal)
        
        halfYearButton.backgroundColor = UIColor(hexString: "#F0F4F7")
        halfYearButton.setTitleColor(.black, for: .normal)
        
        yearButton.backgroundColor = UIColor(hexString: "#F0F4F7")
        yearButton.setTitleColor(.black, for: .normal)
        
        sender.backgroundColor = .black
        sender.setTitleColor(.white, for: .normal)
        
        if sender.currentTitle == "Y" {
            premiumImage.isHidden = true
            graph.isHidden = false
        } else {
            premiumImage.isHidden = false
            graph.isHidden = true
        }
        reclama.isHidden = true
    }
}

extension GraphViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let index = selectedPaths {
            let deselectedCell = labelsCollectionView.cellForItem(at: index as IndexPath)! as! LabelsCollectionViewCell
            deselectedCell.txtLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
            deselectedCell.txtLabel.textColor = .lightGray
        }
        
        selectedPaths = indexPath
        let selectedCell = labelsCollectionView.cellForItem(at:indexPath as IndexPath)! as! LabelsCollectionViewCell
        selectedCell.txtLabel.font = UIFont(name: "Montserrat-Bold", size: 18)
        selectedCell.txtLabel.textColor = .black
        
        if indexPath.row == 0 {
            graph.isHidden = false
            labelPrice.isHidden = false
            labelPriceDifference.isHidden = false
            reclama.isHidden = true
            timeButtonsView.isHidden = false
            availableLabel.isHidden = true
        } else {
            availableLabel.isHidden = false
            premiumImage.isHidden = true
            graph.isHidden = true
            labelPrice.isHidden = true
            labelPriceDifference.isHidden = true
            reclama.isHidden = false
            timeButtonsView.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelsCollectionViewCell.identifier, for: indexPath)  as! LabelsCollectionViewCell
        if indexPath.row == 0 {
            selectedPaths = indexPath
            cell.txtLabel.font = UIFont(name: "Montserrat-Bold", size: 18)
            cell.txtLabel.font = .boldSystemFont(ofSize: 18)
            cell.txtLabel.textColor = .black
        }
        cell.txtLabel.text = labels[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: labels[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width + 35, height: 24)
    }
}

//MARK: -urL FETCHING

extension MainViewController {
    func fetchDataForGraph(ticker: String, resolution: String) -> [Double]{

        let baseUrl = "https://finnhub.io/api/v1/stock/candle?symbol=" + ticker + "&resolution=" + resolution + "&from=1631022248&to=1631627048&token=" + apiKey
        let graphData = performRequestForGraphData(urlString: baseUrl)
        return graphData
    }
    
    func performRequestForGraphData(urlString: String)->[Double]{
        var numbersData: [Double]!
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            if let url = URL(string: urlString){
                let request = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let safeData = data {
                            numbersData = self.parseJSONNamesGraph(stocksData: safeData)
                            group.leave()
                    }
                }
                task.resume()
            }
        }
        group.wait()
        return numbersData
    }
    
    func parseJSONNamesGraph(stocksData: Data) -> [Double]{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(GraphData.self, from: stocksData)
            return decodedData.c
        } catch {
            print(error)
        }
        return []
    }
}
