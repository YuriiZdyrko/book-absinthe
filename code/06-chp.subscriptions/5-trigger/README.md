Testing subscription:


# Place order subscription
open 3 browser windows:

## Window 1
mutation ($input: PlaceOrderInput!) { 
	placeOrder(input: $input) {
    errors { message }
    order { id state }
  }
}

{
  "input": {
    "items": [
      {"quantity": 1, "menuItemId": "4"}
    ]
  }
}

## Window 2
subscription { newOrder {
    customerNumber
    items { name quantity}
  }
}

## Window 3
subscription { newOrder {
    customerNumber
    items { name quantity}
  }
}

# Update order subscription (order with ID 1 must exist in db): 

## Window 1
mutation ($id: ID!) {
  readyOrder(id: $id) {
    errors {
      message
    }
  }
}

{
  "id": 1
}


## Window 2 (updated order ID)

subscription {
  updateOrder(id: "1") {
    customerNumber
    state
  }
}

## Window 3

subscription {
  updateOrder(id: "2") {
    customerNumber
    state
  }
}



