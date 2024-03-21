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

%P5
%Calculate the price of a given order given Customer Name and order id
calcPriceOfOrder(CustomerName, OrderID, TotalPrice):-
    getItemInOrderByID(CustomerName, OrderID, Items),
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
    getItemInOrderByID(CustomerName, OrderID, Items),
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
getTheDiffInPriceBetProductAndAlt(Product, Alt, Diff) :-
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










