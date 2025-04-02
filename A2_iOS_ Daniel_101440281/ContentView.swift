import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // FetchRequest for Product entity
    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.productName, ascending: true)],
        animation: .default)
    private var products: FetchedResults<Product>

    var body: some View {
        NavigationView {
            VStack {
                // Display the first product
                if let firstProduct = products.first {
                    Text(firstProduct.productName ?? "No name")
                        .font(.largeTitle)
                        .padding()
                    
                    Text(firstProduct.productDescription ?? "No description")
                        .padding()
                } else {
                    Text("No products available")
                        .font(.title)
                        .padding()
                }
            }
            .navigationTitle("First Product")
            .toolbar {
                // Toolbar button to add new item
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    // Add a new item (for demonstration purposes)
    private func addItem() {
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

    // Delete items (to be used later for managing products)
    private func deleteItems(offsets: IndexSet) {
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

// Formatter for displaying timestamp (used previously, could be updated for product)
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
