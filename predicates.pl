:-consult("data.pl").


% RULES
% 1:-
% returns only one order, needs modification to return all orders
% base case: no orders by this name
list_order(CustomerId, Orders) :-
    customer(X,CustomerId),
    order(X, _, Orders).


% 3:-
% takes name, orderid -> matches the name with customer id  and with the customer id it gets , it gets the order
getItemInOrderByID(X, OrderID , Items):-
    customer(CustomerId,X),
    order(CustomerId,OrderID, Items).
