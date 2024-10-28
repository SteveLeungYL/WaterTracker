//
//  MyIcon.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/27/24.
//

import SwiftUI

struct Cup: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.46882*width, y: 0.05265*height))
        path.addCurve(to: CGPoint(x: 0.09564*width, y: 0.05899*height), control1: CGPoint(x: 0.28034*width, y: 0.05341*height), control2: CGPoint(x: 0.11797*width, y: 0.05611*height))
        path.addCurve(to: CGPoint(x: 0.07315*width, y: 0.06786*height), control1: CGPoint(x: 0.08345*width, y: 0.06051*height), control2: CGPoint(x: 0.08073*width, y: 0.06161*height))
        path.addCurve(to: CGPoint(x: 0.05841*width, y: 0.11975*height), control1: CGPoint(x: 0.06195*width, y: 0.07707*height), control2: CGPoint(x: 0.06047*width, y: 0.08223*height))
        path.addCurve(to: CGPoint(x: 0.06022*width, y: 0.44934*height), control1: CGPoint(x: 0.05668*width, y: 0.14967*height), control2: CGPoint(x: 0.05808*width, y: 0.40193*height))
        path.addCurve(to: CGPoint(x: 0.06928*width, y: 0.58413*height), control1: CGPoint(x: 0.06244*width, y: 0.49928*height), control2: CGPoint(x: 0.06582*width, y: 0.54999*height))
        path.addCurve(to: CGPoint(x: 0.1482*width, y: 0.81349*height), control1: CGPoint(x: 0.07958*width, y: 0.68495*height), control2: CGPoint(x: 0.10553*width, y: 0.7605*height))
        path.addCurve(to: CGPoint(x: 0.18544*width, y: 0.85118*height), control1: CGPoint(x: 0.15701*width, y: 0.82439*height), control2: CGPoint(x: 0.17333*width, y: 0.84095*height))
        path.addCurve(to: CGPoint(x: 0.19606*width, y: 0.86014*height), control1: CGPoint(x: 0.19112*width, y: 0.85591*height), control2: CGPoint(x: 0.1959*width, y: 0.85997*height))
        path.addCurve(to: CGPoint(x: 0.19013*width, y: 0.86724*height), control1: CGPoint(x: 0.19623*width, y: 0.86031*height), control2: CGPoint(x: 0.19351*width, y: 0.86352*height))
        path.addCurve(to: CGPoint(x: 0.16855*width, y: 0.89791*height), control1: CGPoint(x: 0.18115*width, y: 0.87704*height), control2: CGPoint(x: 0.17382*width, y: 0.88743*height))
        path.addCurve(to: CGPoint(x: 0.16402*width, y: 0.91152*height), control1: CGPoint(x: 0.16476*width, y: 0.9056*height), control2: CGPoint(x: 0.16402*width, y: 0.90772*height))
        path.addCurve(to: CGPoint(x: 0.21015*width, y: 0.9378*height), control1: CGPoint(x: 0.16402*width, y: 0.92394*height), control2: CGPoint(x: 0.17885*width, y: 0.93248*height))
        path.addCurve(to: CGPoint(x: 0.28635*width, y: 0.94287*height), control1: CGPoint(x: 0.2319*width, y: 0.94152*height), control2: CGPoint(x: 0.24384*width, y: 0.94236*height))
        path.addCurve(to: CGPoint(x: 0.33825*width, y: 0.94414*height), control1: CGPoint(x: 0.30859*width, y: 0.94313*height), control2: CGPoint(x: 0.33191*width, y: 0.94372*height))
        path.addCurve(to: CGPoint(x: 0.38067*width, y: 0.94625*height), control1: CGPoint(x: 0.34459*width, y: 0.94465*height), control2: CGPoint(x: 0.3637*width, y: 0.94558*height))
        path.addCurve(to: CGPoint(x: 0.4301*width, y: 0.94836*height), control1: CGPoint(x: 0.39764*width, y: 0.94701*height), control2: CGPoint(x: 0.41989*width, y: 0.94794*height))
        path.addCurve(to: CGPoint(x: 0.57056*width, y: 0.94667*height), control1: CGPoint(x: 0.46973*width, y: 0.95014*height), control2: CGPoint(x: 0.53365*width, y: 0.94929*height))
        path.addCurve(to: CGPoint(x: 0.66842*width, y: 0.92859*height), control1: CGPoint(x: 0.62575*width, y: 0.94262*height), control2: CGPoint(x: 0.6559*width, y: 0.93712*height))
        path.addCurve(to: CGPoint(x: 0.65796*width, y: 0.87831*height), control1: CGPoint(x: 0.68276*width, y: 0.91887*height), control2: CGPoint(x: 0.68012*width, y: 0.90619*height))
        path.addLine(to: CGPoint(x: 0.65302*width, y: 0.87205*height))
        path.addLine(to: CGPoint(x: 0.65796*width, y: 0.86774*height))
        path.addCurve(to: CGPoint(x: 0.70401*width, y: 0.81112*height), control1: CGPoint(x: 0.67674*width, y: 0.85126*height), control2: CGPoint(x: 0.68993*width, y: 0.83495*height))
        path.addCurve(to: CGPoint(x: 0.75426*width, y: 0.65588*height), control1: CGPoint(x: 0.72823*width, y: 0.76988*height), control2: CGPoint(x: 0.74067*width, y: 0.73134*height))
        path.addCurve(to: CGPoint(x: 0.75739*width, y: 0.6394*height), control1: CGPoint(x: 0.75591*width, y: 0.64692*height), control2: CGPoint(x: 0.75731*width, y: 0.63948*height))
        path.addCurve(to: CGPoint(x: 0.78104*width, y: 0.63999*height), control1: CGPoint(x: 0.75739*width, y: 0.6394*height), control2: CGPoint(x: 0.7681*width, y: 0.63957*height))
        path.addCurve(to: CGPoint(x: 0.89398*width, y: 0.62376*height), control1: CGPoint(x: 0.83162*width, y: 0.64168*height), control2: CGPoint(x: 0.87009*width, y: 0.6361*height))
        path.addCurve(to: CGPoint(x: 0.95041*width, y: 0.55709*height), control1: CGPoint(x: 0.92009*width, y: 0.61033*height), control2: CGPoint(x: 0.9369*width, y: 0.59047*height))
        path.addCurve(to: CGPoint(x: 0.96713*width, y: 0.49032*height), control1: CGPoint(x: 0.95947*width, y: 0.53452*height), control2: CGPoint(x: 0.96301*width, y: 0.52024*height))
        path.addCurve(to: CGPoint(x: 0.97174*width, y: 0.35131*height), control1: CGPoint(x: 0.97364*width, y: 0.44249*height), control2: CGPoint(x: 0.97562*width, y: 0.3835*height))
        path.addCurve(to: CGPoint(x: 0.96425*width, y: 0.29806*height), control1: CGPoint(x: 0.96968*width, y: 0.33381*height), control2: CGPoint(x: 0.96565*width, y: 0.30542*height))
        path.addCurve(to: CGPoint(x: 0.88928*width, y: 0.22547*height), control1: CGPoint(x: 0.95601*width, y: 0.25573*height), control2: CGPoint(x: 0.93113*width, y: 0.23164*height))
        path.addCurve(to: CGPoint(x: 0.80089*width, y: 0.21922*height), control1: CGPoint(x: 0.87503*width, y: 0.22336*height), control2: CGPoint(x: 0.8303*width, y: 0.22023*height))
        path.addLine(to: CGPoint(x: 0.78334*width, y: 0.21863*height))
        path.addLine(to: CGPoint(x: 0.78334*width, y: 0.18102*height))
        path.addCurve(to: CGPoint(x: 0.77815*width, y: 0.07741*height), control1: CGPoint(x: 0.78359*width, y: 0.1293*height), control2: CGPoint(x: 0.78161*width, y: 0.0895*height))
        path.addCurve(to: CGPoint(x: 0.76332*width, y: 0.06017*height), control1: CGPoint(x: 0.77601*width, y: 0.0698*height), control2: CGPoint(x: 0.77049*width, y: 0.0633*height))
        path.addCurve(to: CGPoint(x: 0.75426*width, y: 0.05586*height), control1: CGPoint(x: 0.7611*width, y: 0.05916*height), control2: CGPoint(x: 0.75698*width, y: 0.05721*height))
        path.addCurve(to: CGPoint(x: 0.46882*width, y: 0.05265*height), control1: CGPoint(x: 0.74471*width, y: 0.05113*height), control2: CGPoint(x: 0.76637*width, y: 0.05138*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.82025*width, y: 0.29857*height))
        path.addCurve(to: CGPoint(x: 0.84958*width, y: 0.3044*height), control1: CGPoint(x: 0.83079*width, y: 0.29967*height), control2: CGPoint(x: 0.84224*width, y: 0.30195*height))
        path.addCurve(to: CGPoint(x: 0.88969*width, y: 0.35807*height), control1: CGPoint(x: 0.87066*width, y: 0.31167*height), control2: CGPoint(x: 0.88327*width, y: 0.32849*height))
        path.addCurve(to: CGPoint(x: 0.88805*width, y: 0.48863*height), control1: CGPoint(x: 0.89571*width, y: 0.38562*height), control2: CGPoint(x: 0.89497*width, y: 0.44782*height))
        path.addCurve(to: CGPoint(x: 0.88014*width, y: 0.5161*height), control1: CGPoint(x: 0.88607*width, y: 0.5008*height), control2: CGPoint(x: 0.88385*width, y: 0.50849*height))
        path.addCurve(to: CGPoint(x: 0.856*width, y: 0.53554*height), control1: CGPoint(x: 0.87536*width, y: 0.52607*height), control2: CGPoint(x: 0.87157*width, y: 0.52911*height))
        path.addCurve(to: CGPoint(x: 0.79916*width, y: 0.55151*height), control1: CGPoint(x: 0.83722*width, y: 0.54331*height), control2: CGPoint(x: 0.8177*width, y: 0.54872*height))
        path.addCurve(to: CGPoint(x: 0.7681*width, y: 0.55514*height), control1: CGPoint(x: 0.78656*width, y: 0.55337*height), control2: CGPoint(x: 0.76851*width, y: 0.55548*height))
        path.addCurve(to: CGPoint(x: 0.76901*width, y: 0.5439*height), control1: CGPoint(x: 0.76794*width, y: 0.55497*height), control2: CGPoint(x: 0.76835*width, y: 0.5499*height))
        path.addCurve(to: CGPoint(x: 0.78186*width, y: 0.33728*height), control1: CGPoint(x: 0.777*width, y: 0.47376*height), control2: CGPoint(x: 0.78186*width, y: 0.39534*height))
        path.addCurve(to: CGPoint(x: 0.78244*width, y: 0.30795*height), control1: CGPoint(x: 0.78186*width, y: 0.27922*height), control2: CGPoint(x: 0.78211*width, y: 0.31353*height))
        path.addLine(to: CGPoint(x: 0.78293*width, y: 0.29764*height))
        path.addLine(to: CGPoint(x: 0.7971*width, y: 0.29764*height))
        path.addCurve(to: CGPoint(x: 0.82025*width, y: 0.29857*height), control1: CGPoint(x: 0.80484*width, y: 0.29764*height), control2: CGPoint(x: 0.81531*width, y: 0.29806*height))
        path.closeSubpath()
        return path
    }
}

struct CupView: View {
    @State private var percent: Double = 20
    
    var body : some View {
        
        GeometryReader { geometry in
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    ZStack{
                        
                        @State var cupWidth = geometry.size.width * 0.8
                        
                        Cup()
                            .fill(Color.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: cupWidth, alignment: .center)
                            .overlay(
                                WaveAnimation($percent)
                                    .frame(width: cupWidth, alignment: .center)
                                    .aspectRatio( contentMode: .fill)
                                    .mask(
                                Cup()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: cupWidth, alignment: .center)
                                )
                            )
                        
                        
                        Cup()
                            .stroke(Color.black, style: StrokeStyle(lineWidth: 8))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: cupWidth, alignment: .center)
                        
                        // FIXME: Update the correct text here.
                        Text("\(Int(percent))%")
                            .font(.system(size: 300))
                            .minimumScaleFactor(0.00001)
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                            .frame(height: cupWidth * 0.30, alignment: .center)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    CupView()
}
