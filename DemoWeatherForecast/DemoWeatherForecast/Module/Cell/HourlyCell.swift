
import UIKit

class HourlyCell: UICollectionViewCell {
    //MARK: -  Outlets
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var imgSymbol: UIImageView!
    
    //MARK: - Variable Declaration
    static var reuseIdentifier: String = "HourlyCell"
    
    //MARK: - Initialization Method
    func configure(with item: WeatherInfo) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        if let date = dateFormatterGet.date(from: item.time) {
            lblTime.text = dateFormatter.string(from: date)
        }
        lblDescription.text = item.description
        
        imgSymbol.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(item.icon)@2x.png")
        
        lblTemp.attributedText = decorateText(sub: "\(String(item.max_temp.kelvinToCeliusConverter())) °C", des: "- \(String(item.min_temp.kelvinToCeliusConverter())) °C")
    }
    
    func decorateText(sub:String, des:String)->NSAttributedString{
     
        let textPartOne = NSMutableAttributedString(string: sub, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)])
        let textPartTwo = NSMutableAttributedString(string: des, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 9.0)])

        let textCombination = NSMutableAttributedString()
        textCombination.append(textPartOne)
        textCombination.append(textPartTwo)
        return textCombination
    }
}

