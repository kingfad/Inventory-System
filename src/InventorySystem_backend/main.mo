import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";

actor {
  type Item = {
    id: Nat;
    name: Text;
    description: Text;
    quantity: Nat;
    price: Nat;
  };

  var inventory = Buffer.Buffer<Item>(0);

  public func addItem(name: Text, description: Text, quantity: Nat, price: Nat) : async Nat {
    let id = inventory.size();
    let newItem: Item = {
      id;
      name;
      description;
      quantity;
      price;
    };
    inventory.add(newItem);
    id
  };

  public func increaseItemQuantity(id: Nat, quantityToAdd: Nat) : async Bool {
    if (id >= inventory.size()) return false;
    let item = inventory.get(id);
    let newQuantity = item.quantity + quantityToAdd;
    let updatedItem: Item = {
      id = item.id;
      name = item.name;
      description = item.description;
      quantity = newQuantity;
      price = item.price;
    };
    inventory.put(id, updatedItem);
    true
  };

  public func decreaseItemQuantity(id: Nat, quantityToRemove: Nat) : async Bool {
    if (id >= inventory.size()) return false;
    let item = inventory.get(id);
    let newQuantity = if (item.quantity >= quantityToRemove) {
      item.quantity - quantityToRemove
    } else {
      0
    };
    let updatedItem: Item = {
      id = item.id;
      name = item.name;
      description = item.description;
      quantity = newQuantity;
      price = item.price;
    };
    inventory.put(id, updatedItem);
    true
  };

  public query func getItem(id: Nat) : async ?Item {
    if (id >= inventory.size()) return null;
    ?inventory.get(id)
  };

  public query func getLowStockItems(threshold: Nat) : async [Item] {
    Buffer.toArray(Buffer.mapFilter<Item, Item>(inventory, func (item) {
      if (item.quantity <= threshold) ?item else null
    }))
  };
}