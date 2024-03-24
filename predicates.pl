:-consult("data.pl").
:- dynamic(item/3).

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
% Main predicate to list all orders of a specific customer
% Main predicate to list all orders of a specific customer
list_orders(CustomerName, Orders) :-
    customer(CustomerId, CustomerName),
    get_orders(CustomerId, [], Orders),!. % Start with an empty list for the orders 

% Recursive predicate to collect all orders of a specific customer
get_orders(CustomerId, FoundOrders, Orders) :-
    order(CustomerId, OrderID, Items), % Retrieve an order
    not_inList(order(CustomerId, OrderID, _), FoundOrders), % Ensure order hasnt been added to list  yet
    NewOrder = order(CustomerId, OrderID, Items),
    append(FoundOrders, [NewOrder], UpdatedOrders), % Add the new order to the list of found orders
    get_orders(CustomerId, UpdatedOrders, Orders). % Recursively process the rest of the orders

% Base case: when there are no more orders left to process
get_orders(_, Orders, Orders).

% Utility predicate to check if an order is not a member of a list of orders

% Base case: an order is not a member of an empty list
not_inList(_, []). 

% another base case: the order matches the head of the list
not_inList(Order, [H|_]) :-
    order_matches(Order, H), % If the current order matches, it means it is already a member
    !,
    fail.

% Recursive case: check each element of the list
not_inList(Order, [H|T]) :-
    \+ order_matches(Order, H),  % Check if the current order matches the one we are looking for
    not_inList(Order, T). % Recursively check the rest of the list

% Utility function to append to list

% base case: empty list
append([], L, L).

% recursive case: 
append([H|T], L2, [H|NT]):-
    append(T, L2, NT).

% utility to compare two orders to each other , will be used above so if the equal then the order is in the list no need to append
order_matches(order(CustomerId1, OrderID1, _), order(CustomerId2, OrderID2, _)) :-
    CustomerId1 = CustomerId2,
    OrderID1 = OrderID2.
    

% 2:-
% Return number of orders of a specific customer.
countOrdersOfCustomer(CustomerId,Count):-
 list_order(CustomerId, Orders),
 calcLength(Orders, Count).


% 3:-
% takes name, orderid -> matches the name with customer id  and with the customer id it gets , it gets the order
getItemsInOrderById(X, OrderID , Items):-
    customer(CustomerId,X),
    order(CustomerId,OrderID, Items),!.


% 4:-
% Return num of items in a specific customer order
getNumOfItems(CustomerName,OrderID,Count):-
    getItemsInOrderById(CustomerName,OrderID,Items), % get List of items
    calcLength(Items, Count).

%P5
%Calculate the price of a given order given Customer Name and order id
calcPriceOfOrder(CustomerName, OrderID, TotalPrice):-
    getItemsInOrderById(CustomerName, OrderID, Items),
    calc(Items, TotalPrice).

calc([], 0).
calc([H|T], TotalPrice):-
    item(H, _, Price),
    calc(T, NewTotalPrice),
    TotalPrice is Price + NewTotalPrice.


    
% 6:-
% Given the item name or company name, determine whether we need to boycott or not.
% check is boycott with company name.
isBoycott(Company) :-
    boycott_company(Company, _),
    !.

% check is boycott with item name.
isBoycott(Item) :-
    item(Item, Company, _),
    boycott_company(Company, _).


% P7
% take company name or an item name and find the justification for boycotting it
whyToBoycott(Company, Justification) :- 
    boycott_company(Company, Justification).
whyToBoycott(Item, Justification) :-
    item(Item, Company, _), boycott_company(Company, Justification).


% P8
%Given an username and order ID, remove all the boycott items from this order.
removeBoycottItemsFromAnOrder(CustomerName, OrderID, NewList):-
    getItemsInOrderById(CustomerName, OrderID, Items),
    remove(Items, NewList),!.

remove([], []).
remove([H|T], [H|NewList]):-
    \+ whyToBoycott(H, _),
    remove(T, NewList).

remove([H|T], NewList):-
    whyToBoycott(H, _),
    remove(T, NewList).    


% 9:-
% Given an username and order ID, update the order such that all boycott items are replaced by an alternative (if exists).
replaceBoycottItemsFromAnOrder(Name, OrderID, NewList) :-
    customer(ID, Name),
    order(ID, OrderID, OldList),
    replaceItems(OldList, NewList), !.

replaceItems([], []).

replaceItems([H|T], [H|NewT]) :-
    \+ isBoycott(H), % if the item is not boycotted, keep it as it is.
    replaceItems(T, NewT).

replaceItems([H|T], [Alt|NewT]) :-
    isBoycott(H),
    alternative(H, Alt), % Get alternative for boycotted item
    replaceItems(T, NewT).


% 10:-
% Given an username and order ID, calculate the price of the order after replacing all boycott items by its alternative (if it exists).
calcPriceAfterReplacingBoycottItemsFromAnOrder(Name, OrderID, NewList, TotalPrice):-
replaceBoycottItemsFromAnOrder(Name, OrderID, NewList),
calcPrice(NewList, 0, TotalPrice).

calcPrice([], TempPrice, TempPrice).

calcPrice([H|T], TempPrice, TotalPrice):-
item(H, _, Price),
Temp is TempPrice + Price,
calcPrice(T, Temp, TotalPrice).


%P11
%calculate the difference in price between the boycott item and its alternative.
getTheDifferenceInPriceBetweenItemAndAlternative(Product, Alt, Diff) :-
    item(Product, BoycottedCompany, ProPrice),
    alternative(Product, Alt),
    item(Alt, _, AltPrice),
    Diff is ProPrice - AltPrice.

% 12:- 
%add
add_item(ItemName, Type, Quantity) :-
    assertz(item(ItemName, Type, Quantity)).
%remove
remove_item(ItemName, Type, Quantity):-
    retract(item(ItemName, Type, Quantity)).










