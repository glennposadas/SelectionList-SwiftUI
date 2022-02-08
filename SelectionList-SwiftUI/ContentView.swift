import SwiftUI

// SOURCE: https://www.mitchellcurrie.com/blog-post/swiftui-selectable-list/#.

struct ContentView: View {
  var body: some View {
    NavigationView {
      MenuView()
        .navigationBarTitle(Text("Menu"))
    }
  }
}

struct MenuView: View {
  @State var selectedFruit: FruitModel?
  @State var selectedSandwich: SandwichModel?
  
  let fruitModels = [FruitModel(name: "Apple", color: "Red"),
                     FruitModel(name: "Apple", color: "Green"),
                     FruitModel(name: "Lemon", color: "Yellow")]
  let sandwichModels = [SandwichModel(name: "Club Sandwich",
                                      ingredients: ["White bread", "Chicken", "Lettuce", "Mayonnaise"],
                                      price: 7.50),
                        SandwichModel(name: "Ham/Cheese Toastie",
                                      ingredients: ["White bread", "Ham", "Cheese", "Mustard"],
                                      price: 6.00)]
  
  var body: some View {
    return List {
      Section(header: Text("Fruit (free)")) {
        ForEach(fruitModels, id: \.self) { model in
          SelectableWrapperCell(selected: self.$selectedFruit,
                                wrapped: FruitCell(model: model))
        }
      }
      Section(header: Text("Sandwiches (to buy)")) {
        ForEach(sandwichModels, id: \.self) { model in
          SelectableWrapperCell(selected: self.$selectedSandwich,
                                wrapped: SandwichCell(model: model))
        }
      }
    }
  }
}

struct SandwichCell: View, ViewProtocol {
  var model: SandwichModel
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(model.name).fontWeight(.medium)
        Text(model.formattedPrice)
      }
      Text(model.ingredients.joined(separator: ",")).italic()
    }
  }
}

struct SandwichModel: Equatable, Hashable {
  var name: String
  var ingredients: [String]
  var price: Float
}

extension SandwichModel {
  var formattedPrice: String {
    return String(format: "$%0.2f", price)
  }
}

struct SelectableWrapperCell<Wrapped: View & ViewProtocol>: View {
  @Binding var selected: Wrapped.Model?
  var wrapped: Wrapped
  var body: some View {
    return HStack {
      wrapped
      Spacer()
      if selected == wrapped.model {
        Image(systemName: "checkmark")
      }
    }
    .contentShape(Rectangle())  // Important for [max] area to tap
    .onTapGesture {
      self.selected = self.wrapped.model
    }
  }
}

struct FruitCell: View, ViewProtocol {
  var model: FruitModel
  var body: some View {
    VStack(alignment: .leading) {
      Text(model.name).fontWeight(.medium).scaledToFill()
      Text(model.color).italic().scaledToFill()
    }
  }
}

protocol ViewProtocol {
  associatedtype Model: Equatable
  var model: Model { get }
}

struct FruitModel: Equatable, Hashable {
  var name: String
  var color: String
}
