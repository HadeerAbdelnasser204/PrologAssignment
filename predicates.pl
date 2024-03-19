:-consult("data.pl").

%SUB RULE%
% get length
% base case: empty List
calcLength([], 0).
%recursive
calcLength([_|T],L):-
   calcLength(T,L2),
   L is L2 + 1.

% RULES
% 1:-
% returns only one order, needs modification to return all orders
% base case: no orders by this name
list_order(CustomerId, Orders) :-
    customer(X,CustomerId),
    order(X, _, Orders).
    
% 2:-
% Return number of orders of a specific customer.
countOrdersOfCustomer(CustomerId,Count):-
 list_order(CustomerId, Orders),
 calcLength(Orders, Count).

% 3:-
% takes name, orderid -> matches the name with customer id  and with the customer id it gets , it gets the order
getItemInOrderByID(X, OrderID , Items):-
    customer(CustomerId,X),
    order(CustomerId,OrderID, Items).

% 4:-
% Return num of items in a specific customer order
getNumOfItems(CustomerName,OrderID,Count):-
       getItemInOrderByID(CustomerName,OrderID,Items), % get List of items
       calcLength(Items, Count).
