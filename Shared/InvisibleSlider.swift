
struct InvisibleSlider: View {
    
    @Binding var percent: Double
    
    var body: some View {
        GeometryReader { geo in
            let dragGesture = DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let percent = 1.0 - Double(value.location.y / geo.size.height)
                    self.percent = max(0, min(100, percent * 100))
                }
            
            Rectangle()
                .opacity(0.00001) // The super small value will effectively hide the slider. 
                .frame(width: geo.size.width, height: geo.size.height)
                .gesture(dragGesture)
        }
    }
}