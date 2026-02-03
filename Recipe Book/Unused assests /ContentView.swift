////
////  ContentView.swift
////  Recipe Book
////
////  Created by Grizzowl on 2026/02/03.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    @State private var dataText = "Loading..."
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text(dataText)
//                .padding()
//
//            AsyncImage(url: URL(string: "https://www.apple.com/favicon.ico")) { image in
//                image.resizable()
//                     .frame(width: 64, height: 64)
//            } placeholder: {
//                ProgressView()
//            }
//        }
//        .task {
//            await fetchData()
//        }
//    }
//
//    func fetchData() async {
//        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
//            dataText = "Invalid URL"
//            return
//        }
//
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            if let json = try? JSONSerialization.jsonObject(with: data) {
//                dataText = "Success: \(json)"
//            } else {
//                dataText = "Invalid JSON"
//            }
//        } catch {
//            dataText = "Network error: \(error.localizedDescription)"
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
