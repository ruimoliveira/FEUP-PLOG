menu:-
	printMenu,
	get_char(Input),
	get_char(_),
	(
		Input = '1' -> pvp;
		Input = '2' -> pvcpu;
		Input = '3' -> cpuvscpu;
		Input = '4';

		nl,
		write('Error: invalid input.'), nl,
		menu
	).
	
printMenu:-
	nl,
	write('=        Consta       ='), nl,
	nl,
	write('1. Player vs Player'), nl,
	write('2. Player vs CPU'), nl,
	write('3. CPU vs CPU'), nl,
	write('4. Exit'), nl,
	nl,
	write('======================='), nl,
	write('Choose an option:'), nl.
	
choosePiecesMenu(Player):-
	printChooseMenu,
	get_char(Input),
	get_char(_),
	(
		Input = '1' -> Player = darkPieces;
		Input = '2' -> Player = lightPieces;

		nl,
		write('Error: invalid input.'), nl,
		choosePiecesMenu(Player)
	).
	
printChooseMenu:-
	nl,
	write('Play as :'), nl,
	nl,
	write('1. Dark Pieces'), nl,
	write('2. Light Pieces'), nl,
	nl,
	write('======================='), nl,
	write('Choose an option:'), nl.
	
pvp:-
	playerVSplayer(GameState),
	firstPlay(GameState, NextGameState),
	play(NextGameState).
	
pvcpu:-
	playerVScpu(GameState),
	choosePiecesMenu(Player),
	(
		Player == darkPieces, firstPlay(GameState, TempGameState), cpuPlay(TempGameState, NextGameState);
		Player == lightPieces, cpuPlayPiece(1, [], GameState, TempGameState), changeTurn(TempGameState, NextGameState)
	),
	play(NextGameState).
	
cpuvscpu:-
	cpuVScpu(GameState),
	cpuPlayPiece(1, [], GameState, TempGameState),
	changeTurn(TempGameState, NextGameState),
	playWithMyself(NextGameState).
	
playWithMyself(GameState):-
	victoryCondition(GameState), gameOver(GameState);
	cpuPlay(GameState, NextGameState),
	seePlayByPlay(NextGameState),
	playWithMyself(NextGameState).
	
seePlayByPlay(NextGameState):-
	getGameBoard(NextGameState, Board),
	printBoard(Board),
	write('Press "Enter" to continue...'), nl,
	get_char(_), !.
	
