playerVSplayer(Game):-
	initBoard(Board),
	Game = [Board, darkPlayer, pvp], !.
	
playerVScpu(Game):-
	initBoard(Board),
	Game = [Board, darkPlayer, pvcpu], !.
	
cpuVScpu(Game):-
	initBoard(Board),
	Game = [Board, darkPlayer, cpuvcpu], !.
	
getGameBoard([Board|_], Board).

getPlayerTurn([_,Player,_], Player).

getGameMode([_,_,GameMode], GameMode).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
victoryCondition(Game):-
	getPlayerTurn(Game, Player),
	getGameBoard(Game, Board),
	%write('Column: '), write(Column), nl,
	%write('HERE 3'), nl,
	(
		Player == darkPlayer,
		Row is 10,
		checkHedge(Row, Column, Board, Player),
		DestRow is 0,
		checkHedge(DestRow, DestColumn, Board, Player);
		
		Player == lightPlayer,
		Column is 0,
		checkVedge(Row, Column, Board, Player),
		DestColumn is 10,
		checkVedge(DestRow, DestColumn, Board, Player)
	),
	findPath([Row, Column], [DestRow, DestColumn], Board, Player).

checkHedge(Row, Column, Board, Player):-
	playerPiece(Player, Piece),
	getRow(Row, Board, FullRow),
	getColumnIndex(FullRow, Piece, Column).

checkVedge(Row, Column, Board, Player):-
	Index is 0,
	getRowIndex(Row, Column, Board, Player, Index).
	
getRowIndex(_, _, _, _, 11):-
	fail.
getRowIndex(Row, Column, Board, Player, Index):-
	getRow(Index, Board, FullRow),
	(
		Column == 0,
		checkFirst(FullRow, Player),
		Row is Index;
		
		Column == 10,
		checkLast(FullRow, Player),
		Row is Index;
		
		Index1 is Index + 1,
		getRowIndex(Row, Column, Board, Player, Index1)
	).
	
checkFirst([Cell|_], Player):-
	playerPiece(Player, Cell).
checkLast(FullRow, Player):-
	last(FullRow, Cell),
	playerPiece(Player, Cell).
	
findPath([Row, Column], [DestRow, DestColumn], Board, Player):-
	findPath([Row, Column], [DestRow, DestColumn], [[Row, Column]], Board, Player).
findPath([Row, Column], [DestRow, DestColumn], Visited, Board, Player):-
	%write('Visited: '), write(Visited), nl,
	neighbour([Row, Column], [NextRow, NextColumn], Visited, Board, Player),
	\+(member([NextRow, NextColumn], Visited)),
	findPath([NextRow, NextColumn], [DestRow, DestColumn], [[NextRow, NextColumn]|Visited], Board, Player).
findPath([Row, Column], [Row, Column], _, _, _).

neighbour([Row, Column], [NextRow, NextColumn], Visited, Board, Player):-
	LeftColumn is Column - 1,
	RightColumn is Column + 1,
	TopRow is Row - 1,
	BottomRow is Row + 1,
	(
		LeftColumn >= 0,
		\+(member([Row, LeftColumn], Visited)),
		getMatrixElement(Board, Row, LeftColumn, Piece),
		playerPiece(Player, Piece),
		NextRow is Row,
		NextColumn is LeftColumn;
		
		LeftColumn >= 0, TopRow >= 0,
		\+(member([TopRow, LeftColumn], Visited)),
		getMatrixElement(Board, TopRow, LeftColumn, Piece),
		playerPiece(Player, Piece),
		checkCross(Row, Column, TopRow, LeftColumn, Board, Player),
		NextRow is TopRow,
		NextColumn is LeftColumn;
		
		TopRow >= 0,
		\+(member([TopRow, Column], Visited)),
		getMatrixElement(Board, TopRow, Column, Piece),
		playerPiece(Player, Piece),
		NextRow is TopRow,
		NextColumn is Column;
		
		TopRow >= 0, RightColumn =< 10,
		\+(member([TopRow, RightColumn], Visited)),
		getMatrixElement(Board, TopRow, RightColumn, Piece),
		playerPiece(Player, Piece),
		checkCross(Row, Column, TopRow, RightColumn, Board, Player),
		NextRow is TopRow,
		NextColumn is RightColumn;
		
		RightColumn =< 10,
		\+(member([Row, RightColumn], Visited)),
		getMatrixElement(Board, Row, RightColumn, Piece),
		playerPiece(Player, Piece),
		NextRow is Row,
		NextColumn is RightColumn;
		
		RightColumn =< 10, BottomRow =< 10,
		\+(member([BottomRow, RightColumn], Visited)),
		getMatrixElement(Board, BottomRow, RightColumn, Piece),
		playerPiece(Player, Piece),
		checkCross(Row, Column, BottomRow, RightColumn, Board, Player),
		NextRow is BottomRow,
		NextColumn is RightColumn;
		
		BottomRow =< 10,
		\+(member([BottomRow, Column], Visited)),
		getMatrixElement(Board, BottomRow, Column, Piece),
		playerPiece(Player, Piece),
		NextRow is BottomRow,
		NextColumn is Column;
		
		BottomRow =< 10, LeftColumn >= 0,
		\+(member([BottomRow, LeftColumn], Visited)),
		getMatrixElement(Board, BottomRow, LeftColumn, Piece),
		playerPiece(Player, Piece),
		checkCross(Row, Column, BottomRow, LeftColumn, Board, Player),
		NextRow is BottomRow,
		NextColumn is LeftColumn
	).
	
checkCross(Row, Column, CornerRow, CornerColumn, Board, Player):-
	(
		Row < CornerRow, Column < CornerColumn,
		checkCrossValues(Row, Column, CornerRow, CornerColumn, Board, Player);
		
		Row < CornerRow, Column > CornerColumn,
		checkCrossValues(Row, Column, CornerRow, CornerColumn, Board, Player);
		
		Row > CornerRow, Column < CornerColumn,
		checkCrossValues(Row, Column, CornerRow, CornerColumn, Board, Player);
		
		Row > CornerRow, Column > CornerColumn,
		checkCrossValues(Row, Column, CornerRow, CornerColumn, Board, Player)
	).
	
checkCrossValues(Row, Column, CornerRow, CornerColumn, Board, Player):-
	opponent(Player, Opponent),
	getMatrixElement(Board, CornerRow, Column, PieceB),
	(
		playerPiece(Opponent, PieceB),
		getPieceValue(PieceB, B);
		
		B is 0
	),
	
	getMatrixElement(Board, Row, CornerColumn, PieceC),
	(
		B == 0, C is 0;
		
		playerPiece(Opponent, PieceC),
		getPieceValue(PieceC, C);
		
		C is 0, B is 0
	),
	
	getMatrixElement(Board, Row, Column, PieceA),
	getPieceValue(PieceA, A),
	
	getMatrixElement(Board, CornerRow, CornerColumn, PieceD),
	getPieceValue(PieceD, D),
	
	crossCheck(A,B,C,D).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
validateCoords(RowChar, ColumnChar, Row, Column, Game):-
	atom_codes(ColumnChar, [C]),
	Row is RowChar - 1,
	Column is C - 97,
	getGameBoard(Game, Board),
	getMatrixElement(Board, Row, Column, Cell),
	getPieceValue(Cell, 0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getSurroundingCells(Row, Column, Game, Cells):-
	getGameBoard(Game, Board),
	(
		(Row == 0, Column == 0) -> getFourCells(Row, Column, Cells, Board);
		(Row == 0, Column == 10) -> getFourCells(0, 9, Cells, Board);
		(Row == 10, Column == 0) -> getFourCells(9, 0, Cells, Board);
		(Row == 10, Column == 10) -> getFourCells(9, 9, Cells, Board);
		Row == 0 -> getHSixCells(Row, Column, Cells, Board);
		Row == 10 -> getHSixCells(9, Column, Cells, Board);
		Column == 0 -> getVSixCells(Row, Column, Cells, Board);
		Column == 10 -> getVSixCells(Row, 9, Cells, Board);
		getNineCells(Row, Column, Cells, Board)
	).
	
getFourCells(Row, Column, Cells, Board):-
	AuxRow is Row + 1,
	AuxColumn is Column + 1,
	getMatrixElement(Board, Row, Column, CellA),
	getMatrixElement(Board, Row, AuxColumn, CellB),
	getMatrixElement(Board, AuxRow, Column, CellC),
	getMatrixElement(Board, AuxRow, AuxColumn, CellD),
	Cells = [[CellA, CellB],
			 [CellC, CellD]].
	
getHSixCells(Row, Column, Cells, Board):-
	AuxRow is Row + 1,
	AuxColumn is Column - 1,
	getMatrixElement(Board, Row, AuxColumn, CellA),
	getMatrixElement(Board, Row, Column, CellB),
	getMatrixElement(Board, AuxRow, AuxColumn, CellD),
	getMatrixElement(Board, AuxRow, Column, CellE),
	AuxColumn2 is Column + 1,
	getMatrixElement(Board, Row, AuxColumn2, CellC),
	getMatrixElement(Board, AuxRow, AuxColumn2, CellF),
	Cells = [[CellA, CellB, CellC],
			 [CellD, CellE, CellF]].
	
getVSixCells(Row, Column, Cells, Board):-
	AuxRow is Row - 1,
	AuxColumn is Column + 1,
	getMatrixElement(Board, AuxRow, Column, CellA),
	getMatrixElement(Board, AuxRow, AuxColumn, CellB),
	getMatrixElement(Board, Row, Column, CellC),
	getMatrixElement(Board, Row, AuxColumn, CellD),
	AuxRow2 is Row + 1,
	getMatrixElement(Board, AuxRow2, Column, CellE),
	getMatrixElement(Board, AuxRow2, AuxColumn, CellF),
	Cells = [[CellA, CellB],
			 [CellC, CellD],
			 [CellE, CellF]].
	
getNineCells(Row, Column, Cells, Board):-
	AuxRow is Row + 1,
	AuxColumn is Column - 1,
	getMatrixElement(Board, Row, Column, CellE),
	getMatrixElement(Board, Row, AuxColumn, CellD),
	getMatrixElement(Board, AuxRow, AuxColumn, CellG),
	getMatrixElement(Board, AuxRow, Column, CellH),
	AuxColumn2 is Column + 1,
	getMatrixElement(Board, AuxRow, AuxColumn2, CellI),
	getMatrixElement(Board, Row, AuxColumn2, CellF),
	AuxRow2 is Row - 1,
	getMatrixElement(Board, AuxRow2, AuxColumn2, CellC),
	getMatrixElement(Board, AuxRow2, Column, CellB),
	getMatrixElement(Board, AuxRow2, AuxColumn, CellA),
	
	Cells = [[CellA, CellB, CellC],
			 [CellD, CellE, CellF],
			 [CellG, CellH, CellI]].
			 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
validatePlay(Row, Column, PieceValue, Player, Game):-
	getSurroundingCells(Row, Column, Game, Cells),
	(
		(
			(Row == 0, Column == 0);
			(Row == 0, Column == 10);
			(Row == 10, Column == 0);
			(Row == 10, Column == 10)
		) -> checkCornerCross(Cells, PieceValue, Player);
		
		( Row == 0; Row == 10 ) -> checkLeftCross(Cells, PieceValue, Player), checkRightCross(Cells, PieceValue, Player);
		
		( Column == 0; Column == 10 ) -> checkTopCross(Cells, PieceValue, Player), checkBottomCross(Cells, PieceValue, Player);
		
		checkForCrossTopLeft(Cells, PieceValue, Player),
		checkForCrossBottomLeft(Cells, PieceValue, Player),
		checkForCrossTopRight(Cells, PieceValue, Player),
		checkForCrossBottomRight(Cells, PieceValue, Player)
	).
	
checkForCrossTopLeft([[TopLeft,Top,_],[Left,_,_],[_,_,_]], PieceValue, Player):-
	getPieceValue(TopLeft, A),
	getPieceValue(Top, B),
	getPieceValue(Left, C),
	(
		checkTwoEmpty(A, B, C);
		playerPiece(Player, Left);
		playerPiece(Player, Top);
		opponent(Player, Opponent), playerPiece(Opponent, TopLeft);		
		crossCheck(A,B,C,PieceValue)
	).
	
checkForCrossBottomLeft([[_,_,_],[Left,_,_],[BottomLeft,Bottom,_]], PieceValue, Player):-
	getPieceValue(BottomLeft, A),
	getPieceValue(Bottom, B),
	getPieceValue(Left, C),
	(
		checkTwoEmpty(A, B, C);
		playerPiece(Player, Left);
		playerPiece(Player, Bottom);
		opponent(Player, Opponent), playerPiece(Opponent, BottomLeft);
		
		crossCheck(A,B,C,PieceValue)
	).

checkForCrossTopRight([[_,Top,TopRight],[_,_,Right],[_,_,_]], PieceValue, Player):-
	getPieceValue(TopRight, A),	getPieceValue(Top, B),
	getPieceValue(Right, C),
	(
		checkTwoEmpty(A, B, C);
		playerPiece(Player, Right);
		playerPiece(Player, Top);
		opponent(Player, Opponent), playerPiece(Opponent, TopRight);
		
		crossCheck(A,B,C,PieceValue)
	).
	
checkForCrossBottomRight([[_,_,_],[_,_,Right],[_,Bottom,BottomRight]], PieceValue, Player):-
		getPieceValue(BottomRight, A),
		getPieceValue(Bottom, B),
		getPieceValue(Right, C),
	(
		checkTwoEmpty(A, B, C);
		playerPiece(Player, Right);
		playerPiece(Player, Bottom);
		opponent(Player, Opponent), playerPiece(Opponent, BottomRight);
		
		crossCheck(A,B,C,PieceValue)
	).
		
checkTopCross([[TopLeft,TopRight],[Left,Right],[_,_]], PieceValue, Player):-
	getPieceValue(TopLeft, A),
	getPieceValue(TopRight, B),
	getPieceValue(Left, C),
	getPieceValue(Right, D),
	(
		checkTwoEmpty(A, B, C, D);
		C == 0, playerPiece(Player, TopLeft);
		C == 0, playerPiece(Player, Right);
		C == 0, opponent(Player, Opponent), playerPiece(Opponent, TopRight);
		D == 0, playerPiece(Player, TopRight);
		D == 0, playerPiece(Player, Left);
		D == 0, opponent(Player, Opponent), playerPiece(Opponent, TopLeft);
		
		C == 0, crossCheck(B,A,D,PieceValue);
		D == 0, crossCheck(A,B,C,PieceValue)
	).

checkBottomCross([[_,_],[Left,Right],[BottomLeft,BottomRight]], PieceValue, Player):-
	getPieceValue(BottomLeft, A),
	getPieceValue(BottomRight, B),
	getPieceValue(Left, C),
	getPieceValue(Right, D),
	(
		checkTwoEmpty(A, B, C, D);
		C == 0, playerPiece(Player, BottomLeft);
		C == 0, playerPiece(Player, Right);
		C == 0, opponent(Player, Opponent), playerPiece(Opponent, BottomRight);
		D == 0, playerPiece(Player, BottomRight);
		D == 0, playerPiece(Player, Left);
		D == 0, opponent(Player, Opponent), playerPiece(Opponent, BottomLeft);
		
		C == 0, crossCheck(B,A,D,PieceValue);
		D == 0, crossCheck(A,B,C,PieceValue)
	).
	
checkLeftCross([[TopLeft,Top,_],[BottomLeft,Bottom,_]], PieceValue, Player):-
	getPieceValue(BottomLeft, A),
	getPieceValue(TopLeft, B),
	getPieceValue(Bottom, C),
	getPieceValue(Top, D),
	(
		checkTwoEmpty(A, B, C, D);
		C == 0, playerPiece(Player, BottomLeft);
		C == 0, playerPiece(Player, Top);
		C == 0, opponent(Player, Opponent), playerPiece(Opponent, TopLeft);
		D == 0, playerPiece(Player, TopLeft);
		D == 0, playerPiece(Player, Bottom);
		D == 0, opponent(Player, Opponent), playerPiece(Opponent, BottomLeft);
		
		C == 0, crossCheck(B,A,D,PieceValue);
		D == 0, crossCheck(A,B,C,PieceValue)
	).

checkRightCross([[_,Top,TopRight],[_,Bottom,BottomRight]], PieceValue, Player):-
	getPieceValue(BottomRight, A),
	getPieceValue(TopRight, B),
	getPieceValue(Bottom, C),
	getPieceValue(Top, D),
	(
		checkTwoEmpty(A, B, C, D);
		C == 0, playerPiece(Player, BottomRight);
		C == 0, playerPiece(Player, Top);
		C == 0, opponent(Player, Opponent), playerPiece(Opponent, TopRight);
		D == 0, playerPiece(Player, TopRight);
		D == 0, playerPiece(Player, Bottom);
		D == 0, opponent(Player, Opponent), playerPiece(Opponent, BottomRight);
		
		C == 0, crossCheck(B,A,D,PieceValue);
		D == 0, crossCheck(A,B,C,PieceValue)
	).
		
checkCornerCross([[TopLeft,TopRight],[BottomLeft,BottomRight]], PieceValue, Player):-
	getPieceValue(TopLeft, A),
	getPieceValue(TopRight, B),
	getPieceValue(BottomLeft, C),
	getPieceValue(BottomRight, D),
	(
		checkTwoEmpty(A, B, C, D);
		A == 0, playerPiece(Player, BottomLeft);
		A == 0, playerPiece(Player, TopRight);
		A == 0, opponent(Player, Opponent), playerPiece(Opponent, BottomRight);
		B == 0, playerPiece(Player, TopLeft);
		B == 0, playerPiece(Player, BottomRight);
		B == 0, opponent(Player, Opponent), playerPiece(Opponent, BottomLeft);
		C == 0, playerPiece(Player, TopLeft);
		C == 0, playerPiece(Player, BottomRight);
		C == 0, opponent(Player, Opponent), playerPiece(Opponent, TopRight);
		D == 0, playerPiece(Player, TopRight);
		D == 0, playerPiece(Player, BottomLeft);
		D == 0, opponent(Player, Opponent), playerPiece(Opponent, TopLeft);
		
		A == 0, crossCheck(D,B,C,PieceValue);
		B == 0, crossCheck(C,A,D,PieceValue);
		C == 0, crossCheck(B,A,D,PieceValue);
		D == 0, crossCheck(A,B,C,PieceValue)
	).
	
checkTwoEmpty(A, B, C):-
	A == 0;	B == 0;
	C == 0.
checkTwoEmpty(A, B, C, D):-
	A == 0, B == 0;
	A == 0, C == 0;
	A == 0, D == 0;
	B == 0, C == 0;
	B == 0, D == 0;
	C == 0, D == 0.
	
crossCheck(A,B,C,D):-
	OpponentCross is B + C,
	PlayerCross is A + D,
	OpponentCross < PlayerCross.
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getPieceValue(empty, 0).
getPieceValue(dark, 1).
getPieceValue(dark2, 2).
getPieceValue(light, 1).
getPieceValue(light2, 2).

playerPiece(darkPlayer, dark).
playerPiece(darkPlayer, dark2).
playerPiece(lightPlayer, light).
playerPiece(lightPlayer, light2).

opponent(lightPlayer, darkPlayer).
opponent(darkPlayer, lightPlayer).

playerName(darkPlayer, 'Dark Pieces').
playerName(lightPlayer, 'Light Pieces').