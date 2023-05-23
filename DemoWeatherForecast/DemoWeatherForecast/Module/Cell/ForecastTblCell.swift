
import UIKit

class ForecastTblCell: UITableViewCell{
    
    //MARK: -  Outlets
    @IBOutlet weak var lblWeekday: UILabel!
    @IBOutlet weak var cvForecast: UICollectionView!
    
    //MARK: - Variable Declaration
    static var reuseIdentifier: String = "ForecastCell"
    var dailyForecast: [WeatherInfo] = []
    
    //MARK: - Default Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
}

//MARK: - Delegate Extension
extension ForecastTblCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCell.reuseIdentifier, for: indexPath) as! HourlyCell
        cell.configure(with: dailyForecast[indexPath.row])
        return cell
    }
    
    func configure(with item: ForecastTemperature) {
        lblWeekday.text = "\(item.weekDay ?? ""),\n\(item.date ?? "")"
        dailyForecast = item.hourlyForecast ?? []
    }
}
