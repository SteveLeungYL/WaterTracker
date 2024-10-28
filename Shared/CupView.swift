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
        path.move(to: CGPoint(x: 0.5232*width, y: 0.38324*height))
        path.addCurve(to: CGPoint(x: 0.342*width, y: 0.38624*height), control1: CGPoint(x: 0.43168*width, y: 0.3836*height), control2: CGPoint(x: 0.35284*width, y: 0.38488*height))
        path.addCurve(to: CGPoint(x: 0.33108*width, y: 0.39044*height), control1: CGPoint(x: 0.33608*width, y: 0.38696*height), control2: CGPoint(x: 0.33476*width, y: 0.38748*height))
        path.addCurve(to: CGPoint(x: 0.32392*width, y: 0.415*height), control1: CGPoint(x: 0.32564*width, y: 0.3948*height), control2: CGPoint(x: 0.32492*width, y: 0.39724*height))
        path.addCurve(to: CGPoint(x: 0.3248*width, y: 0.571*height), control1: CGPoint(x: 0.32308*width, y: 0.42916*height), control2: CGPoint(x: 0.32376*width, y: 0.54856*height))
        path.addCurve(to: CGPoint(x: 0.3292*width, y: 0.6348*height), control1: CGPoint(x: 0.32588*width, y: 0.59464*height), control2: CGPoint(x: 0.32752*width, y: 0.61864*height))
        path.addCurve(to: CGPoint(x: 0.36752*width, y: 0.74336*height), control1: CGPoint(x: 0.3342*width, y: 0.68252*height), control2: CGPoint(x: 0.3468*width, y: 0.71828*height))
        path.addCurve(to: CGPoint(x: 0.3856*width, y: 0.7612*height), control1: CGPoint(x: 0.3718*width, y: 0.74852*height), control2: CGPoint(x: 0.37972*width, y: 0.75636*height))
        path.addCurve(to: CGPoint(x: 0.39076*width, y: 0.76544*height), control1: CGPoint(x: 0.38836*width, y: 0.76344*height), control2: CGPoint(x: 0.39068*width, y: 0.76536*height))
        path.addCurve(to: CGPoint(x: 0.38788*width, y: 0.7688*height), control1: CGPoint(x: 0.39084*width, y: 0.76552*height), control2: CGPoint(x: 0.38952*width, y: 0.76704*height))
        path.addCurve(to: CGPoint(x: 0.3774*width, y: 0.78332*height), control1: CGPoint(x: 0.38352*width, y: 0.77344*height), control2: CGPoint(x: 0.37996*width, y: 0.77836*height))
        path.addCurve(to: CGPoint(x: 0.3752*width, y: 0.78976*height), control1: CGPoint(x: 0.37556*width, y: 0.78696*height), control2: CGPoint(x: 0.3752*width, y: 0.78796*height))
        path.addCurve(to: CGPoint(x: 0.3976*width, y: 0.8022*height), control1: CGPoint(x: 0.3752*width, y: 0.79564*height), control2: CGPoint(x: 0.3824*width, y: 0.79968*height))
        path.addCurve(to: CGPoint(x: 0.4346*width, y: 0.8046*height), control1: CGPoint(x: 0.40816*width, y: 0.80396*height), control2: CGPoint(x: 0.41396*width, y: 0.80436*height))
        path.addCurve(to: CGPoint(x: 0.4598*width, y: 0.8052*height), control1: CGPoint(x: 0.4454*width, y: 0.80472*height), control2: CGPoint(x: 0.45672*width, y: 0.805*height))
        path.addCurve(to: CGPoint(x: 0.4804*width, y: 0.8062*height), control1: CGPoint(x: 0.46288*width, y: 0.80544*height), control2: CGPoint(x: 0.47216*width, y: 0.80588*height))
        path.addCurve(to: CGPoint(x: 0.5044*width, y: 0.8072*height), control1: CGPoint(x: 0.48864*width, y: 0.80656*height), control2: CGPoint(x: 0.49944*width, y: 0.807*height))
        path.addCurve(to: CGPoint(x: 0.5726*width, y: 0.8064*height), control1: CGPoint(x: 0.52364*width, y: 0.80804*height), control2: CGPoint(x: 0.55468*width, y: 0.80764*height))
        path.addCurve(to: CGPoint(x: 0.62012*width, y: 0.79784*height), control1: CGPoint(x: 0.5994*width, y: 0.80448*height), control2: CGPoint(x: 0.61404*width, y: 0.80188*height))
        path.addCurve(to: CGPoint(x: 0.61504*width, y: 0.77404*height), control1: CGPoint(x: 0.62708*width, y: 0.79324*height), control2: CGPoint(x: 0.6258*width, y: 0.78724*height))
        path.addLine(to: CGPoint(x: 0.61264*width, y: 0.77108*height))
        path.addLine(to: CGPoint(x: 0.61504*width, y: 0.76904*height))
        path.addCurve(to: CGPoint(x: 0.6374*width, y: 0.74224*height), control1: CGPoint(x: 0.62416*width, y: 0.76124*height), control2: CGPoint(x: 0.63056*width, y: 0.75352*height))
        path.addCurve(to: CGPoint(x: 0.6618*width, y: 0.66876*height), control1: CGPoint(x: 0.64916*width, y: 0.72272*height), control2: CGPoint(x: 0.6552*width, y: 0.70448*height))
        path.addCurve(to: CGPoint(x: 0.66332*width, y: 0.66096*height), control1: CGPoint(x: 0.6626*width, y: 0.66452*height), control2: CGPoint(x: 0.66328*width, y: 0.661*height))
        path.addCurve(to: CGPoint(x: 0.6748*width, y: 0.66124*height), control1: CGPoint(x: 0.66336*width, y: 0.66092*height), control2: CGPoint(x: 0.66852*width, y: 0.66104*height))
        path.addCurve(to: CGPoint(x: 0.72964*width, y: 0.65356*height), control1: CGPoint(x: 0.69936*width, y: 0.66204*height), control2: CGPoint(x: 0.71804*width, y: 0.6594*height))
        path.addCurve(to: CGPoint(x: 0.75704*width, y: 0.622*height), control1: CGPoint(x: 0.74232*width, y: 0.6472*height), control2: CGPoint(x: 0.75048*width, y: 0.6378*height))
        path.addCurve(to: CGPoint(x: 0.76516*width, y: 0.5904*height), control1: CGPoint(x: 0.76144*width, y: 0.61132*height), control2: CGPoint(x: 0.76316*width, y: 0.60456*height))
        path.addCurve(to: CGPoint(x: 0.7674*width, y: 0.5246*height), control1: CGPoint(x: 0.76832*width, y: 0.56776*height), control2: CGPoint(x: 0.76928*width, y: 0.53984*height))
        path.addCurve(to: CGPoint(x: 0.76376*width, y: 0.4994*height), control1: CGPoint(x: 0.7664*width, y: 0.51632*height), control2: CGPoint(x: 0.76444*width, y: 0.50288*height))
        path.addCurve(to: CGPoint(x: 0.72736*width, y: 0.46504*height), control1: CGPoint(x: 0.75976*width, y: 0.47936*height), control2: CGPoint(x: 0.74768*width, y: 0.46796*height))
        path.addCurve(to: CGPoint(x: 0.68444*width, y: 0.46208*height), control1: CGPoint(x: 0.72044*width, y: 0.46404*height), control2: CGPoint(x: 0.69872*width, y: 0.46256*height))
        path.addLine(to: CGPoint(x: 0.67592*width, y: 0.4618*height))
        path.addLine(to: CGPoint(x: 0.67596*width, y: 0.444*height))
        path.addCurve(to: CGPoint(x: 0.6734*width, y: 0.39496*height), control1: CGPoint(x: 0.67604*width, y: 0.41952*height), control2: CGPoint(x: 0.67508*width, y: 0.40068*height))
        path.addCurve(to: CGPoint(x: 0.6662*width, y: 0.3868*height), control1: CGPoint(x: 0.67236*width, y: 0.39136*height), control2: CGPoint(x: 0.66968*width, y: 0.38828*height))
        path.addCurve(to: CGPoint(x: 0.6618*width, y: 0.38476*height), control1: CGPoint(x: 0.66512*width, y: 0.38632*height), control2: CGPoint(x: 0.66312*width, y: 0.3854*height))
        path.addCurve(to: CGPoint(x: 0.5232*width, y: 0.38324*height), control1: CGPoint(x: 0.65716*width, y: 0.38252*height), control2: CGPoint(x: 0.66768*width, y: 0.38264*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.69384*width, y: 0.49964*height))
        path.addCurve(to: CGPoint(x: 0.70808*width, y: 0.5024*height), control1: CGPoint(x: 0.69896*width, y: 0.50016*height), control2: CGPoint(x: 0.70452*width, y: 0.50124*height))
        path.addCurve(to: CGPoint(x: 0.72756*width, y: 0.5278*height), control1: CGPoint(x: 0.71832*width, y: 0.50584*height), control2: CGPoint(x: 0.72444*width, y: 0.5138*height))
        path.addCurve(to: CGPoint(x: 0.72676*width, y: 0.5896*height), control1: CGPoint(x: 0.73048*width, y: 0.54084*height), control2: CGPoint(x: 0.73012*width, y: 0.57028*height))
        path.addCurve(to: CGPoint(x: 0.72292*width, y: 0.6026*height), control1: CGPoint(x: 0.7258*width, y: 0.59536*height), control2: CGPoint(x: 0.72472*width, y: 0.599*height))
        path.addCurve(to: CGPoint(x: 0.7112*width, y: 0.6118*height), control1: CGPoint(x: 0.7206*width, y: 0.60732*height), control2: CGPoint(x: 0.71876*width, y: 0.60876*height))
        path.addCurve(to: CGPoint(x: 0.6836*width, y: 0.61936*height), control1: CGPoint(x: 0.70208*width, y: 0.61548*height), control2: CGPoint(x: 0.6926*width, y: 0.61804*height))
        path.addCurve(to: CGPoint(x: 0.66852*width, y: 0.62108*height), control1: CGPoint(x: 0.67748*width, y: 0.62024*height), control2: CGPoint(x: 0.66872*width, y: 0.62124*height))
        path.addCurve(to: CGPoint(x: 0.66896*width, y: 0.61576*height), control1: CGPoint(x: 0.66844*width, y: 0.621*height), control2: CGPoint(x: 0.66864*width, y: 0.6186*height))
        path.addCurve(to: CGPoint(x: 0.6752*width, y: 0.51796*height), control1: CGPoint(x: 0.67284*width, y: 0.58256*height), control2: CGPoint(x: 0.6752*width, y: 0.54544*height))
        path.addCurve(to: CGPoint(x: 0.67548*width, y: 0.50408*height), control1: CGPoint(x: 0.6752*width, y: 0.513*height), control2: CGPoint(x: 0.67532*width, y: 0.50672*height))
        path.addLine(to: CGPoint(x: 0.67572*width, y: 0.4992*height))
        path.addLine(to: CGPoint(x: 0.6826*width, y: 0.4992*height))
        path.addCurve(to: CGPoint(x: 0.69384*width, y: 0.49964*height), control1: CGPoint(x: 0.68636*width, y: 0.4992*height), control2: CGPoint(x: 0.69144*width, y: 0.4994*height))
        path.closeSubpath()
        return path
    }
}

struct CupView: View {
    var body : some View {
        Cup()
            .containerRelativeFrame(.vertical, count: 100, span: 43, spacing: 0)
    }
}

#Preview {
    CupView()
}
