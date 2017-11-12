cpuPlay(GameState, NextGameState):-
	random(0,10, Random),
	(
		Random > 4, PieceValue is 2;
		
		PieceValue is 1
	),
	(
		PieceValue == 1, cpuPlayPiece(PieceValue, GameState, TempGameState1), cpuPlayPiece(PieceValue, TempGameState1, TempGameState2), changeTurn(TempGameState2, NextGameState);
		PieceValue == 2, cpuPlayPiece(PieceValue, GameState, TempGameState), changeTurn(TempGameState, NextGameState);
		
		write('Random ERROR'), nl,
		fail
	).

cpuPlayPiece(PieceValue, GameState, NextGameState):-
	(
		random(0,11,Row), random(0,11,Column),
		
		getGameBoard(GameState, Board),
		getMatrixElement(Board, Row, Column, Cell),
		getPieceValue(Cell, 0),
		getPlayerTurn(GameState, Player),
		validatePlay(Row, Column, PieceValue, Player, GameState),
		placePiece(Row, Column, PieceValue, GameState, NextGameState);
		
		cpuPlayPiece(PieceValue, GameState, NextGameState)
	).