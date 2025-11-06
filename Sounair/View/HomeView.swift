//
//  HomeView.swift
//  Sounair
//
//  Created by Akshat Srivastava on 05/11/25.
//

import SwiftUI

struct HomeView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("SOUNAIR")
                            .font(.custom("Bitcount Grid Single", size: 35))
                        Text("music that feels in air")
                            .font(.custom("Nunito", size: 15))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "bell")
                        .font(.title3)
                        .foregroundStyle(Color.gray)
                    
                }.padding(.horizontal, 10)
                
                HStack {
                    Text("favourites")
                        .font(.custom("DM Serif Display", size: 20))
                        .foregroundStyle(Color.white.opacity(0.7))
                    
                    Spacer()
                }.padding(.top)
                    .padding(.horizontal, 10)
                
                LazyVGrid(columns: columns, spacing: 2) {
                    TrackGridItem(imageName: "Espresso", songName: "Espresso", artistName: "Sabrina Carpenter")
                    
                    TrackGridItem(imageName: "Closer", songName: "Closer", artistName: "The Chainsmokers")
                    
                    TrackGridItem(imageName: "Attention", songName: "Attention", artistName: "Charlie Puth")
                    
                    TrackGridItem(imageName: "We Don't Talk Anymore", songName: "We Don't Talk Anymore", artistName: "Charlie Puth")
                    
                    TrackGridItem(imageName: "Like I Do", songName: "Like I Do", artistName: "J.Taylor")
                    
                    TrackGridItem(imageName: "I Like Me Better", songName: "I Like Me Better", artistName: "Lauv")
                    
                    TrackGridItem(imageName: "Infinity", songName: "Infinity", artistName: "Jaymes Young")
                    
                    TrackGridItem(imageName: "Can We Kiss Forever?", songName: "Can We Kiss Forever?", artistName: "Kina")
                    
                    TrackGridItem(imageName: "Royalty", songName: "Royalty", artistName: "Egzod")
                }
                .padding(.horizontal, 10)
                
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "arkit")
                            .font(.system(size: 16, weight: .light))
                        Text("Experience in AR")
                            .font(.system(size: 14, weight: .light))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .padding(.horizontal, 25)
                }.padding(.vertical)
                
            }.background(Color.black)
                .foregroundStyle(Color.white)
        }
    }
}

struct TrackGridItem: View {
    let imageName: String
    let songName: String
    let artistName: String
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(songName)
                            .font(.custom("DM Serif Display", size: 12))
                            .foregroundColor(.white)
                        Text(artistName)
                            .font(.custom("Nunito", size: 9))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    Spacer()
                }
                .padding(8)
                .background(Color.black.opacity(0.7))
            }
        }
    }
}

//
//#Preview {
//    HomeView()
//}
