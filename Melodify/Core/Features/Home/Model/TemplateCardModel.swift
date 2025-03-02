//
//  TemplateCard.swift
//  Melodify
//
//  Created by Tural Babayev on 2.03.2025.
//

import Foundation

struct TemplateCardModel: Identifiable,Hashable {
    let id = UUID()
    let imageName: String   // Kapak resmi asset adı
    let category: String    // Kategori örn. "Pop", "Rock"
    let title: String       // Şarkı / Template adı
    let styleDescription: String // Style bilgisi
}

