import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.productName, ascending: true)],
        animation: .default)
    private var products: FetchedResults<Product>

    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                SearchBar(text: $searchText)
                    .padding()
                
                List {
                    ForEach(filteredProducts, id: \.self) { product in
                        NavigationLink(destination: Text(product.productName ?? "No name")) {
                            Text(product.productName ?? "No name")
                        }
                    }
                    .onDelete(perform: deleteProducts)
                }
                .navigationBarTitle("Products")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addProduct) {
                            Label("Add Product", systemImage: "plus")
                        }
                    }
                }
            }
        }
    }

    // Filter products based on search text
    private var filteredProducts: [Product] {
        if searchText.isEmpty {
            return Array(products)
        } else {
            return products.filter { product in
                product.productName?.lowercased().contains(searchText.lowercased()) ?? false ||
                product.productDescription?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }

    // Add a new product
    private func addProduct() {
        withAnimation {
            let newProduct = Product(context: viewContext)
            newProduct.productName = "New Product"
            newProduct.productDescription = "Product Description"
            newProduct.productPrice = NSDecimalNumber(string: "10.00")
            newProduct.productProvider = "Provider"
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // Delete a product
    private func deleteProducts(offsets: IndexSet) {
        withAnimation {
            offsets.map { products[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// Search bar component
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        TextField("Search", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
}
