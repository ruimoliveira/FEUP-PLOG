%getRowIndex():-

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getColumnIndex([Element|_], Element, 0).
getColumnIndex([_|Tail], Element, Index):-
  getColumnIndex(Tail, Element, Index1), % Check in the tail of the list
  Index is Index1 + 1.  % and increment the resulting index
  
getRow(N, List, Elem):-
	nth0(N, List, Elem).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code from https://stackoverflow.com/questions/26719774/replacing-elements-in-list-of-lists-prolog
% Receives Matrix and element position. iterates through the lines until
% it finds the correct line and calls getRowElement
getMatrixElement(_, Row, _, null):-
	(
		Row < 0,
		Row >= 10
	), !.
getMatrixElement(_, _, Column, null):-
	(
		Column < 0,
		Column >= 10
	), !.
getMatrixElement([Line|_], 0, Column, Cell):-
	getRowElement(Line, Column, Cell), !.
getMatrixElement([_|RestOfBoard], Row, Column, Cell):-
	Row > 0,
	NewRow is Row-1, !,
	getMatrixElement(RestOfBoard, NewRow, Column, Cell).

% Finds the respective column and stores the piece.
getRowElement([Cell|_], 0, Cell).
getRowElement([_|RestOfBoard], Column, Cell):-
	Column > 0,
	NewColumn is Column-1,
	getRowElement(RestOfBoard, NewColumn, Cell).

replace( [L|Ls] , 0 , Y , Z , [R|Ls] ) :- % once we find the desired row,
	replace_column(L,Y,Z,R).                 % - we replace specified column, and we're done.
replace( [L|Ls] , X , Y , Z , [L|Rs] ) :- % if we haven't found the desired row yet
	X > 0 ,                                 % - and the row offset is positive,
	X1 is X-1 ,                             % - we decrement the row offset
	replace( Ls , X1 , Y , Z , Rs ).         % - and recurse down

replace_column( [_|Cs] , 0 , Z , [Z|Cs] ) .  % once we find the specified offset, just make the substitution and finish up.
replace_column( [C|Cs] , Y , Z , [C|Rs] ) :- % otherwise,
	Y > 0 ,                                    % - assuming that the column offset is positive,
	Y1 is Y-1 ,                                % - we decrement it
	replace_column( Cs , Y1 , Z , Rs ).         % - and recurse down.
	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

initBoard([[empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
		   [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
		   [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
		   [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
		   [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
		   [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
		   [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
		   [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
		   [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
		   [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
		   [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty]]).

rowNumbersList([' 1',' 2',' 3',' 4',' 5',' 6',' 7',' 8',' 9','10','1l']).

footer([32,32,32,32,32,175,175,175,175,175,175,175,175,175,175,175,175,175,175,175,175,175,175,175,175,175]).

printBoard([L | Ls]) :-
	printBoardHeader,
	rowNumbersList(RowNumbers),
	printBoardRows([L | Ls], RowNumbers),
	printBoardFooter.
	
printBoardHeader:-
	write('     a b c d e f g h i j k'), nl,
	write('     _____________________'), nl.

printBoardFooter:-
	footer(Footer), atom_codes(Foo,Footer),
	write(Foo), nl.

printBoardRows([],[]).
printBoardRows([L | Ls],[R | Rs]):-
	printBoardRow(L, R),
	printBoardRows(Ls, Rs).

printBoardRow([],[]).
printBoardRow(L,R):-
	write(R), write('  '), printRowPieces(L), nl.

printRowPieces([]).
printRowPieces([P | Ps]):-
	getCellPiece(P, Piece),
	write(' '), write(Piece),
	printRowPieces(Ps).

getCellPiece(empty, ' ').
getCellPiece(dark, 'x').
getCellPiece(dark2, 'X').
getCellPiece(light, 'o').
getCellPiece(light2, 'O').