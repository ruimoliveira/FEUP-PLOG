menu:-
	printMenu,
	get_char(Input),
	get_char(_),
	(
		Input = '1' -> pvp, mainMenu;
		Input = '2' -> choose2, mainMenu;
		Input = '3' -> choose3, mainMenu;
		Input = '4';

		nl,
		write('Error: invalid input.'), nl,
		pressEnterToContinue, nl,
		mainMenu
	).
	
printMenu:-
	nl,
	write('=        Consta       ='), nl,
	nl,
	write('1. Human vs Human'), nl,
	write('2. Human vs Computer'), nl,
	write('3. Computer vs Computer'), nl,
	write('4. Exit'), nl,
	nl,
	write('======================='), nl,
	write('Choose an option:'), nl.
	
pvp:-
	playerVSplayer(Game),
	firstPlay(Game, NextGameState),
	play(NextGameState).
	
choose2:-
	write('you wrote 2'), nl.
	
choose3:-
	write('you wrote 3'), nl.
	
choose4:-
	write('you wrote 4'), nl.