//
//  Cup.swift
//  WaterTracker
//
//  Created by Yu Liang on 10/29/24.
//

import SwiftUI

struct Cup: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.4496*width, y: 0.04148*height))
        path.addCurve(to: CGPoint(x: 0.0455*width, y: 0.04824*height), control1: CGPoint(x: 0.2455*width, y: 0.04229*height), control2: CGPoint(x: 0.06967*width, y: 0.04518*height))
        path.addCurve(to: CGPoint(x: 0.02114*width, y: 0.05771*height), control1: CGPoint(x: 0.03229*width, y: 0.04986*height), control2: CGPoint(x: 0.02935*width, y: 0.05104*height))
        path.addCurve(to: CGPoint(x: 0.00517*width, y: 0.11307*height), control1: CGPoint(x: 0.00901*width, y: 0.06754*height), control2: CGPoint(x: 0.0074*width, y: 0.07304*height))
        path.addCurve(to: CGPoint(x: 0.00714*width, y: 0.46474*height), control1: CGPoint(x: 0.0033*width, y: 0.145*height), control2: CGPoint(x: 0.00482*width, y: 0.41416*height))
        path.addCurve(to: CGPoint(x: 0.01695*width, y: 0.60857*height), control1: CGPoint(x: 0.00955*width, y: 0.51803*height), control2: CGPoint(x: 0.0132*width, y: 0.57214*height))
        path.addCurve(to: CGPoint(x: 0.10241*width, y: 0.85329*height), control1: CGPoint(x: 0.0281*width, y: 0.71614*height), control2: CGPoint(x: 0.0562*width, y: 0.79675*height))
        path.addCurve(to: CGPoint(x: 0.14273*width, y: 0.89351*height), control1: CGPoint(x: 0.11195*width, y: 0.86492*height), control2: CGPoint(x: 0.12962*width, y: 0.8826*height))
        path.addCurve(to: CGPoint(x: 0.15424*width, y: 0.90307*height), control1: CGPoint(x: 0.14888*width, y: 0.89856*height), control2: CGPoint(x: 0.15406*width, y: 0.90289*height))
        path.addCurve(to: CGPoint(x: 0.14781*width, y: 0.91064*height), control1: CGPoint(x: 0.15442*width, y: 0.90325*height), control2: CGPoint(x: 0.15147*width, y: 0.90667*height))
        path.addCurve(to: CGPoint(x: 0.12444*width, y: 0.94337*height), control1: CGPoint(x: 0.13809*width, y: 0.9211*height), control2: CGPoint(x: 0.13015*width, y: 0.93219*height))
        path.addCurve(to: CGPoint(x: 0.11954*width, y: 0.95789*height), control1: CGPoint(x: 0.12034*width, y: 0.95158*height), control2: CGPoint(x: 0.11954*width, y: 0.95383*height))
        path.addCurve(to: CGPoint(x: 0.16949*width, y: 0.98593*height), control1: CGPoint(x: 0.11954*width, y: 0.97115*height), control2: CGPoint(x: 0.13559*width, y: 0.98025*height))
        path.addCurve(to: CGPoint(x: 0.25201*width, y: 0.99134*height), control1: CGPoint(x: 0.19304*width, y: 0.9899*height), control2: CGPoint(x: 0.20598*width, y: 0.9908*height))
        path.addCurve(to: CGPoint(x: 0.30821*width, y: 0.9927*height), control1: CGPoint(x: 0.27609*width, y: 0.99161*height), control2: CGPoint(x: 0.30134*width, y: 0.99225*height))
        path.addCurve(to: CGPoint(x: 0.35415*width, y: 0.99495*height), control1: CGPoint(x: 0.31508*width, y: 0.99324*height), control2: CGPoint(x: 0.33577*width, y: 0.99423*height))
        path.addCurve(to: CGPoint(x: 0.40767*width, y: 0.9972*height), control1: CGPoint(x: 0.37252*width, y: 0.99576*height), control2: CGPoint(x: 0.39661*width, y: 0.99675*height))
        path.addCurve(to: CGPoint(x: 0.55977*width, y: 0.9954*height), control1: CGPoint(x: 0.45058*width, y: 0.9991*height), control2: CGPoint(x: 0.5198*width, y: 0.9982*height))
        path.addCurve(to: CGPoint(x: 0.66574*width, y: 0.9761*height), control1: CGPoint(x: 0.61954*width, y: 0.99107*height), control2: CGPoint(x: 0.65219*width, y: 0.98521*height))
        path.addCurve(to: CGPoint(x: 0.65442*width, y: 0.92245*height), control1: CGPoint(x: 0.68127*width, y: 0.96573*height), control2: CGPoint(x: 0.67841*width, y: 0.95221*height))
        path.addLine(to: CGPoint(x: 0.64906*width, y: 0.91578*height))
        path.addLine(to: CGPoint(x: 0.65442*width, y: 0.91118*height))
        path.addCurve(to: CGPoint(x: 0.70428*width, y: 0.85077*height), control1: CGPoint(x: 0.67475*width, y: 0.8936*height), control2: CGPoint(x: 0.68903*width, y: 0.87619*height))
        path.addCurve(to: CGPoint(x: 0.7587*width, y: 0.68512*height), control1: CGPoint(x: 0.73051*width, y: 0.80676*height), control2: CGPoint(x: 0.74398*width, y: 0.76564*height))
        path.addCurve(to: CGPoint(x: 0.76209*width, y: 0.66754*height), control1: CGPoint(x: 0.76048*width, y: 0.67556*height), control2: CGPoint(x: 0.762*width, y: 0.66763*height))
        path.addCurve(to: CGPoint(x: 0.78769*width, y: 0.66817*height), control1: CGPoint(x: 0.76209*width, y: 0.66754*height), control2: CGPoint(x: 0.77368*width, y: 0.66772*height))
        path.addCurve(to: CGPoint(x: 0.90999*width, y: 0.65086*height), control1: CGPoint(x: 0.84246*width, y: 0.66997*height), control2: CGPoint(x: 0.88412*width, y: 0.66402*height))
        path.addCurve(to: CGPoint(x: 0.9711*width, y: 0.57971*height), control1: CGPoint(x: 0.93827*width, y: 0.63652*height), control2: CGPoint(x: 0.95647*width, y: 0.61533*height))
        path.addCurve(to: CGPoint(x: 0.98921*width, y: 0.50848*height), control1: CGPoint(x: 0.98091*width, y: 0.55564*height), control2: CGPoint(x: 0.98475*width, y: 0.5404*height))
        path.addCurve(to: CGPoint(x: 0.9942*width, y: 0.36014*height), control1: CGPoint(x: 0.99625*width, y: 0.45744*height), control2: CGPoint(x: 0.99839*width, y: 0.3945*height))
        path.addCurve(to: CGPoint(x: 0.98608*width, y: 0.30334*height), control1: CGPoint(x: 0.99197*width, y: 0.34148*height), control2: CGPoint(x: 0.9876*width, y: 0.31118*height))
        path.addCurve(to: CGPoint(x: 0.90491*width, y: 0.22588*height), control1: CGPoint(x: 0.97716*width, y: 0.25816*height), control2: CGPoint(x: 0.95022*width, y: 0.23246*height))
        path.addCurve(to: CGPoint(x: 0.80919*width, y: 0.21921*height), control1: CGPoint(x: 0.88947*width, y: 0.22362*height), control2: CGPoint(x: 0.84103*width, y: 0.22029*height))
        path.addLine(to: CGPoint(x: 0.79019*width, y: 0.21858*height))
        path.addLine(to: CGPoint(x: 0.79019*width, y: 0.17845*height))
        path.addCurve(to: CGPoint(x: 0.78457*width, y: 0.0679*height), control1: CGPoint(x: 0.79045*width, y: 0.12326*height), control2: CGPoint(x: 0.78831*width, y: 0.08079*height))
        path.addCurve(to: CGPoint(x: 0.76851*width, y: 0.0495*height), control1: CGPoint(x: 0.78225*width, y: 0.05978*height), control2: CGPoint(x: 0.77627*width, y: 0.05284*height))
        path.addCurve(to: CGPoint(x: 0.7587*width, y: 0.04491*height), control1: CGPoint(x: 0.7661*width, y: 0.04842*height), control2: CGPoint(x: 0.76164*width, y: 0.04635*height))
        path.addCurve(to: CGPoint(x: 0.4496*width, y: 0.04148*height), control1: CGPoint(x: 0.74835*width, y: 0.03986*height), control2: CGPoint(x: 0.77181*width, y: 0.04013*height))
        path.addLine(to: CGPoint(x: 0.4496*width, y: 0.04148*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.83015*width, y: 0.30388*height))
        path.addCurve(to: CGPoint(x: 0.86191*width, y: 0.3101*height), control1: CGPoint(x: 0.84157*width, y: 0.30505*height), control2: CGPoint(x: 0.85397*width, y: 0.30748*height))
        path.addCurve(to: CGPoint(x: 0.90535*width, y: 0.36736*height), control1: CGPoint(x: 0.88475*width, y: 0.31785*height), control2: CGPoint(x: 0.89839*width, y: 0.3358*height))
        path.addCurve(to: CGPoint(x: 0.90357*width, y: 0.50667*height), control1: CGPoint(x: 0.91186*width, y: 0.39675*height), control2: CGPoint(x: 0.91106*width, y: 0.46312*height))
        path.addCurve(to: CGPoint(x: 0.895*width, y: 0.53598*height), control1: CGPoint(x: 0.90143*width, y: 0.51966*height), control2: CGPoint(x: 0.89902*width, y: 0.52786*height))
        path.addCurve(to: CGPoint(x: 0.86887*width, y: 0.55672*height), control1: CGPoint(x: 0.88983*width, y: 0.54662*height), control2: CGPoint(x: 0.88573*width, y: 0.54986*height))
        path.addCurve(to: CGPoint(x: 0.80731*width, y: 0.57376*height), control1: CGPoint(x: 0.84853*width, y: 0.56501*height), control2: CGPoint(x: 0.82739*width, y: 0.57078*height))
        path.addCurve(to: CGPoint(x: 0.77368*width, y: 0.57764*height), control1: CGPoint(x: 0.79367*width, y: 0.57574*height), control2: CGPoint(x: 0.77413*width, y: 0.578*height))
        path.addCurve(to: CGPoint(x: 0.77467*width, y: 0.56564*height), control1: CGPoint(x: 0.77351*width, y: 0.57746*height), control2: CGPoint(x: 0.77395*width, y: 0.57205*height))
        path.addCurve(to: CGPoint(x: 0.78858*width, y: 0.34518*height), control1: CGPoint(x: 0.78332*width, y: 0.4908*height), control2: CGPoint(x: 0.78858*width, y: 0.40712*height))
        path.addCurve(to: CGPoint(x: 0.78921*width, y: 0.31389*height), control1: CGPoint(x: 0.78858*width, y: 0.28323*height), control2: CGPoint(x: 0.78885*width, y: 0.31984*height))
        path.addLine(to: CGPoint(x: 0.78974*width, y: 0.30289*height))
        path.addLine(to: CGPoint(x: 0.80508*width, y: 0.30289*height))
        path.addCurve(to: CGPoint(x: 0.83015*width, y: 0.30388*height), control1: CGPoint(x: 0.81347*width, y: 0.30289*height), control2: CGPoint(x: 0.8248*width, y: 0.30334*height))
        path.addLine(to: CGPoint(x: 0.83015*width, y: 0.30388*height))
        path.closeSubpath()
        return path
    }
}

#Preview {
    Cup().aspectRatio(contentMode: .fit)
}
