% Consta
% João Moranguinho
% Rui Oliveira

:- include('menu.pl').
:- include('logic.pl').
:- include('storage.pl').
:- use_module(library(lists)).

consta:-
	menu.
	
%Game Loop
play(Game):-
	victoryCondition(Game) -> gameOver(Game);
	humanPlay(Game,GameState), play(GameState).
/*
	%victoryCondition(Game),
	(
		%pvp | pvc
		(
			humanPlay(Game,GameState),
			(
				%pvp
				(getMode(GameState, Mode), Mode == pvp) -> (play(GameState), !);
				
				%pvc
				%(computerPlay(GameState, ComputerGameState)) -> (play(ComputerGameState), !)
				
			)
		)
	).
*/

gameOver(Game):-
	getPlayerTurn(Game, Player),
	playerName(Player, PlayerName),
	nl,
	write('        GAME OVER!        '),
	nl,
	write('The '), write(PlayerName), write(' won!'),
	nl,
	menu.

firstPlay(Game, NextGameState):-
	getGameBoard(Game, Board), getPlayerTurn(Game, Player),
	printBoard(Board),
	write('The Dark Pieces play the beginning move.'), nl,
	playFirstPiece(Player, Game, GameState),
	changeTurn(GameState, NextGameState).
	
humanPlay(Game, NextGameState):-
	getGameBoard(Game, Board), getPlayerTurn(Game, Player),
	repeat,
	printBoard(Board),
	playerName(Player, Name),
	write(Name), write(' turn:'), nl,
	write('1. Play 2 pieces'), nl,
	write('2. Play a stack'), nl,
	get_char(Input),
	get_char(_),
	(
		Input = '1' -> playPiece(Player, Game, GameState), changeTurn(GameState, NextGameState);
		Input = '2' -> playStack(Player, Game, GameState), changeTurn(GameState, NextGameState);

		nl,
		write('Error: invalid input.'), nl,
		humanPlay(Game, NextGameState)
	).
	
playPiece(Player, Game, GameState):-
	playFirstPiece(Player, Game, TempGameState),
	getGameBoard(TempGameState, Board), printBoard(Board),
	playSecondPiece(Player, TempGameState, GameState).
	
playFirstPiece(Player, Game, TempGameState):-
	write('Where do you want to put the first piece? (example: 3d)'), nl,
	readPlay(RowChar, ColumnChar),
	(
		validateCoords(RowChar, ColumnChar, Row, Column, Game), validatePlay(Row, Column, 1, Player, Game) -> placePiece(Row, Column, 1, Game, TempGameState);
		
		nl,
		write('Error: Invalid play.'), nl,
		playFirstPiece(Player, Game, TempGameState)
	).
	
playSecondPiece(Player, TempGameState, GameState):-
	write('Where do you want to put the second piece? (example: 3d)'), nl,
	readPlay(RowChar, ColumnChar),
	(
		validateCoords(RowChar, ColumnChar, Row, Column, TempGameState), validatePlay(Row, Column, 1, Player, TempGameState) -> placePiece(Row, Column, 1, TempGameState, GameState);
		
		nl,
		write('Error: Invalid play.'), nl,
		playSecondPiece(Player, TempGameState, GameState)
	).
	
playStack(Player, Game, GameState):-
	write('Where do you want to put the stacked pieces? (example: 3d)'), nl,
	readPlay(RowChar, ColumnChar),
	(
		validateCoords(RowChar, ColumnChar, Row, Column, Game), validatePlay(Row, Column, 2, Player, Game) -> placePiece(Row, Column, 2, Game, GameState);
		
		nl,
		write('Error: Invalid play.'), nl,
		playStack(Player, Game, GameState)
	).
	
placePiece(Row, Column, PieceValue, Game, GameState):-
	getGameBoard(Game, Board),
	getPlayerTurn(Game, Player),
	getGameMode(Game, GameMode),
	playerPiece(Player, Piece),  getPieceValue(Piece, PieceValue),
	replace(Board, Row, Column, Piece, NewBoard),
	GameState = [NewBoard, Player, GameMode].
	
changeTurn(GameState, NextGameState):-
	getGameBoard(GameState, Board),
	getPlayerTurn(GameState, Player),
	getGameMode(GameState, GameMode),
	opponent(Player, NextPlayer),
	NextGameState = [Board, NextPlayer, GameMode].
	
readPlay(RowChar, ColumnChar):-
	get_code(Ch),
	readAll(Ch, All),
	translatePlay(All, RowChar, ColumnChar).
	
readAll(10,[]).
readAll(13,[]).
readAll(Ch,[Ch|More]):-
	get_code(NewCh),
	readAll(NewCh, More).
	
translatePlay([R,C], RowChar, ColumnChar):- 
	number_codes(RowChar, [R]),
	atom_codes(ColumnChar, [C]).
translatePlay([R1,R2,C], RowChar, ColumnChar):-
	number_codes(RowChar, [R1,R2]),
	atom_codes(ColumnChar, [C]).
	
	
	