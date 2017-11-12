cpuPlay(GameState, NextGameState):-
	random(0,10, Random),
	(
		Random > 4,
		PieceValue is 2,
		cpuPlayPiece(PieceValue, [], GameState, TempGameState),
		changeTurn(TempGameState, NextGameState);
		
		PieceValue is 1,
		cpuPlayPiece(PieceValue, [], GameState, TempGameState1),
		cpuPlayPiece(PieceValue, [], TempGameState1, TempGameState2),
		changeTurn(TempGameState2, NextGameState);
		
		write('Random ERROR'), nl,
		fail
	).

cpuPlayPiece(PieceValue, InvalidPlays, GameState, NextGameState):-
	random(0,11,Row), random(0,11,Column),
	(
		\+(member([Row, Column], InvalidPlays)),
		
		getGameBoard(GameState, Board),
		getMatrixElement(Board, Row, Column, Cell),
		getPieceValue(Cell, 0),
		getPlayerTurn(GameState, Player),
		validatePlay(Row, Column, PieceValue, Player, GameState),
		%write('Played: ['), write(Row), write(','), write(Column), write(']'), nl,
		placePiece(Row, Column, PieceValue, GameState, NextGameState);
		
		cpuPlayPiece(PieceValue, [[Row,Column]|InvalidPlays], GameState, NextGameState)
	).