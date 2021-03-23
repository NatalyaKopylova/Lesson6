import Foundation

//1. Реализовать свой тип коллекции «очередь» (queue) c использованием дженериков.
//2. Добавить ему несколько методов высшего порядка, полезных для этой коллекции (пример: filter для массивов)
//3. * Добавить свой subscript, который будет возвращать nil в случае обращения к несуществующему индексу.

struct Queue<T: CustomStringConvertible>: CustomStringConvertible {
    var description: String {
        var tempStr = "Очередь:\n"
        for element in innerArray {
            tempStr += element.description + "\n"
        }
        return tempStr
    }
    
    private var innerArray = [T]()
    
    init() {}
    
    init(array: [T]) {
        innerArray = array
    }
    
    mutating func add(_ element: T) {
        innerArray.append(element)
    }
    
    mutating func next() -> T? {
        guard innerArray.count > 0 else { return nil }
        return innerArray.remove(at: 0)
    }
    
    func filter(predicate: (T) -> Bool) -> Queue<T> {
        var tempQueue = Queue<T>()
        for element in innerArray {
            if predicate(element) {
                tempQueue.add(element)
            }
        }
        return tempQueue
    }
    
    func anotherFilter(predicate: (T) -> Bool) -> Queue<T> {
        let filteredArray = innerArray.filter(predicate)
        return Queue(array: filteredArray)
    }
    
    mutating func sort(predicate: (T, T) -> Bool) {
        innerArray.sort(by: predicate)
    }
    
    func sorted(predicate: (T, T) -> Bool) -> Queue<T> {
        let sortedArrey = innerArray.sorted(by: predicate)
        return Queue(array: sortedArrey)
    }
    
    func find(predicate: (T) -> Bool) -> T? {
        return innerArray.first(where: predicate)
    }
    
    subscript(index: Int) -> T? {
        guard index >= 0 && index < innerArray.count else { return nil }
        return innerArray[index]
    }
}

//MARK:- пример применения

struct Order: CustomStringConvertible {
    var description: String {
        return "Заказ: \(name) стоит \(price) рублей"
    }
    let price: Decimal
    let name: String
}

let order1 = Order(price: 10, name: "burger")
let order2 = Order(price: 15, name: "french frise")
let order3 = Order(price: 20, name: "juice")
let order4 = Order(price: 25, name: "coffee")
let order5 = Order(price: 30, name: "salad")

let orderArray = [order1, order2, order3, order4, order5]
var orderQueue = Queue<Order>(array: orderArray)

let burger = orderQueue.find(predicate: { order in
    return order.name == "burger"
})
let juice = orderQueue.find { $0.name == "juice" }
print(burger!)
print(juice!)

var sabscriptIndex = orderQueue[0]

print(orderQueue)

orderQueue.sort { $0.name < $1.name }
print(orderQueue)

orderQueue.sort { $0.price > $1.price }
print(orderQueue)

let moneyQueue = orderQueue.anotherFilter { $0.price <= 20 }
print(moneyQueue)










