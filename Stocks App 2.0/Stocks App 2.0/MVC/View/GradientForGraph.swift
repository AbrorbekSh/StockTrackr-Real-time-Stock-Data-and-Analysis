
import UIKit
import Charts

var dataEntries: [ChartDataEntry] = []

func setChart(values: [Double], _ mChart: LineChartView) {
    dataEntries = []
    mChart.noDataText = "No data available!"
    for i in 0..<values.count {
        let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
        dataEntries.append(dataEntry)
    }
    let line1 = LineChartDataSet(entries: dataEntries, label: "Units Consumed")
    
    if let x =  values.first, let y = values.last{
        if x > y {
            line1.colors = [NSUIColor.red]
        } else {
            line1.colors = [NSUIColor.green]
        }
    } else {
        line1.colors = [NSUIColor.black]
    }

    line1.mode = .cubicBezier
    line1.cubicIntensity = 0.2
    line1.lineWidth = 2.5
    line1.drawCirclesEnabled = false
    
    let gradient = getGradientFilling()
    line1.fill = LinearGradientFill(gradient: gradient, angle: 90.0)
    line1.drawFilledEnabled = true
    
    let data = LineChartData()
    data.append(line1)
    data.setDrawValues(false)
    mChart.data = data
    mChart.setScaleEnabled(false)
    mChart.animate(xAxisDuration: 1)
    mChart.drawGridBackgroundEnabled = false
    mChart.xAxis.drawAxisLineEnabled = false
    mChart.xAxis.drawGridLinesEnabled = false
    mChart.leftAxis.drawAxisLineEnabled = false
    mChart.leftAxis.drawGridLinesEnabled = false
    mChart.rightAxis.drawAxisLineEnabled = false
    mChart.rightAxis.drawGridLinesEnabled = false
    mChart.legend.enabled = false
    mChart.xAxis.enabled = false
    mChart.leftAxis.enabled = false
    mChart.rightAxis.enabled = false
    mChart.xAxis.drawLabelsEnabled = false
}


// Creating gradient for filling space under the line chart
private func getGradientFilling() -> CGGradient {
    // Setting fill gradient color
    let coloTop = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).cgColor
    let colorBottom = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 0).cgColor
    // Colors of the gradient
    let gradientColors = [coloTop, colorBottom] as CFArray
    // Positioning of the gradient
    let colorLocations: [CGFloat] = [0.5, 0.0]
    // Gradient Object
    return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
}
