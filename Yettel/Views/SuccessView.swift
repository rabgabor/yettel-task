import SwiftUI

struct SuccessView: View {
    var onClose: () -> Void
    
    @State private var showConfetti = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("YettelGreen").ignoresSafeArea()
            
            GeometryReader { geo in
                Text("A matricákat\nsikeresen\nkifizetted!")
                    .font(.system(size: 38, weight: .heavy))
                    .foregroundColor(Color("YettelBlue"))
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 32)
                    .padding(.trailing, 80)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .position(x: 32 + (geo.size.width - 80) / 2,
                              y: geo.size.height / 2)
                
                Image("SuccessRunner")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 260)
                    .frame(maxWidth: .infinity, maxHeight: .infinity,
                           alignment: .bottomTrailing)
                    .offset(x: 20)
            }
            
                Image("Confetti")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 240)
                    .ignoresSafeArea(edges: .top)
                    .transition(.opacity)
                    .zIndex(1)
                    .opacity(showConfetti ? 1 : 0)
            
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: {showConfetti = false; onClose()}) {
                Text("Rendben")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("YettelBlue"))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showConfetti = true
                }
            }
        }
    }
}

#Preview {
    SuccessView(onClose: {})
}
