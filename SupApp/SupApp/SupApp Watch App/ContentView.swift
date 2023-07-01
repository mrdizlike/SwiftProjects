//
//  ContentView.swift
//  SupApp Watch App
//
//  Created by Виктор on 27.05.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TicketView()
                .tabItem {
                    Image(systemName: "ticket")
                    Text("Билет")
                }
                .tag(0)
            
            ConceptView()
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("Понятие")
                }
                .tag(1)
        }
    }
}

struct TicketView: View {
    @State private var tickets: [Ticket] = []
    @State private var selectedTicket: Ticket?
    
    var body: some View {
        List(tickets) { ticket in
            Button(action: {
                selectedTicket = ticket
            }) {
                Text(ticket.title)
                    .font(.headline)
                    .lineLimit(1)
            }
        }
        .sheet(item: $selectedTicket) { ticket in
            TicketDetail(ticket: ticket)
        }
        .onAppear {
            loadTickets()
        }
    }
    
    func loadTickets() {
        guard let fileURL = Bundle.main.url(forResource: "tickets", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            tickets = try JSONDecoder().decode([Ticket].self, from: data)
        } catch {
            print("Error loading tickets: \(error.localizedDescription)")
        }
    }
}

struct ConceptView: View {
    @State private var concepts: [Concept] = []
    @State private var selectedConcept: Concept?
    
    var body: some View {
        List(concepts) { concept in
            Button(action: {
                selectedConcept = concept
            }) {
                Text(concept.title)
                    .font(.headline)
                    .lineLimit(1)
            }
        }
        .sheet(item: $selectedConcept) { concept in
            ConceptDetail(concept: concept)
        }
        .onAppear {
            loadConcepts()
        }
    }
    
    func loadConcepts() {
        guard let fileURL = Bundle.main.url(forResource: "concepts", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            concepts = try JSONDecoder().decode([Concept].self, from: data)
        } catch {
            print("Error loading concepts: \(error.localizedDescription)")
        }
    }
}

struct Ticket: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
}

struct Concept: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
}

struct TicketDetail: View {
    let ticket: Ticket
    
    var body: some View {
        ScrollView {
            VStack {
                Text(ticket.title)
                    .font(.title)
                    .padding()
                
                Text(ticket.description)
                    .padding()
            }
        }
        .navigationTitle("Детали билета")
    }
}

struct ConceptDetail: View {
    let concept: Concept
    
    var body: some View {
        ScrollView {
            VStack {
                Text(concept.description)
                    .padding()
            }
        }
        .navigationTitle("Детали понятия")
    }
}
