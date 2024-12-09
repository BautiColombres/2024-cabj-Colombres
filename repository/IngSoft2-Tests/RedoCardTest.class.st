Class {
	#name : #RedoCardTest,
	#superclass : #TestCase,
	#instVars : [
		'aLoadedDie',
		'aWormholeCreator',
		'aBoardCreator',
		'collectionOfCells',
		'gameDeck'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #running }
RedoCardTest >> setUp [

	super setUp.
	aLoadedDie := LoadedDie of: #( 6 ).

	aWormholeCreator := WormholeCreator withBeginning: 2 andEnd: 3.
	collectionOfCells := OrderedCollection new.

	30 timesRepeat: [ collectionOfCells add: Cell new ].

	aBoardCreator := BoardCreator
		                 with: collectionOfCells
		                 ofLaps: 1
		                 withWormholeCreator: aWormholeCreator.

	gameDeck := LoadedEffectManager manage:
		            (OrderedCollection withAll: {
				             AccelerationCard.
				             AllyCard.
				             OverloadCard.
				             RedoCard.
				             RepeatCard.
				             CancellationCard.
				             ReverseCard.
				             SkipCard.
				             DoubleCard.
				             FreedomCard })
]

{ #category : #acceleration }
RedoCardTest >> test01TwoRedoCardsPlayedAfterAccelerationThenSpaceshipMovesThreeCellsMore [

	| result aGame |
	aLoadedDie := LoadedDie of: #( 7 7 ).

	aGame := Game
		         numberOfSpaceships: 2
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame usePermanentCard: AccelerationCard toDoEffectFor: nil.
	aGame spaceshipId: 2 useInstantCard: RedoCard toDoEffectFor: nil.
	aGame spaceshipId: 1 useInstantCard: RedoCard toDoEffectFor: 2.

	aGame playTurn.
	result := Dictionary new.
	result at: 1 put: 11.
	result at: 2 put: 1.
	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #overload }
RedoCardTest >> test02RedoCardPlayedAfterOverloadThenSpaceshipsAffectedHaveLessMovement [

	| result aGame |
	aLoadedDie := LoadedDie of: #( 7 7 7 ).

	aGame := Game
		         numberOfSpaceships: 3
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame usePermanentCard: OverloadCard toDoEffectFor: 2.
	aGame spaceshipId: 1 useInstantCard: RedoCard toDoEffectFor: 3.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 8.
	result at: 2 put: 6.
	result at: 3 put: 6.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #ally }
RedoCardTest >> test03RedoCardPlayedAfterAllyThenSpaceshipsThreeAndFourShareFuelBeacuseOfIt [

	| result aGame |
	aLoadedDie := LoadedDie of: #( 7 7 7 1 ).
	aGame := Game
		         numberOfSpaceships: 4
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame usePermanentCard: AllyCard toDoEffectFor: 2.
	aGame spaceshipId: 3 useInstantCard: RedoCard toDoEffectFor: 4.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 1.
	result at: 2 put: 1.
	result at: 3 put: 15.
	result at: 4 put: 4.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #cancellation }
RedoCardTest >> test04TwoAccelerationCardsPlayThenACancellationAndARedoSoNoAccelerationEffectOccurs [

	| aGame result |
	aLoadedDie := LoadedDie of: #( 7 7 7 1 ).

	aGame := Game
		         numberOfSpaceships: 2
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame usePermanentCard: AccelerationCard toDoEffectFor: nil.
	aGame spaceshipId: 2 useInstantCard: RedoCard toDoEffectFor: nil.
	aGame
		spaceshipId: 2
		useInstantCard: CancellationCard
		toDoEffectFor: AccelerationCard new.
	aGame
		spaceshipId: 1
		useInstantCard: RedoCard
		toDoEffectFor: AccelerationCard new.

	aGame playTurn.
	result := Dictionary new.
	result at: 1 put: 8.
	result at: 2 put: 1.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #repeat }
RedoCardTest >> test05RedoCardPlayedAfterRepeatCardThenCellEffectRepeatsTwice [

	| aGame result |
	aLoadedDie := LoadedDie of: #( 9 5 10 ).

	aWormholeCreator := WormholeCreator withBeginning: 2 andEnd: 3.
	collectionOfCells := OrderedCollection new.
	30 timesRepeat: [ collectionOfCells add: Cell new ].

	collectionOfCells at: 6 put: BlackHoleCell new.

	aBoardCreator := BoardCreator
		                 with: collectionOfCells
		                 ofLaps: 1
		                 withWormholeCreator: aWormholeCreator.

	aGame := Game
		         numberOfSpaceships: 2
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame playTurn.
	aGame spaceshipId: 2 useInstantCard: RepeatCard toDoEffectFor: 1.
	aGame spaceshipId: 2 useInstantCard: RedoCard toDoEffectFor: 1.

	result := Dictionary new.
	result at: 1 put: 2.
	result at: 2 put: 2.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #reverse }
RedoCardTest >> test06RedoAReverseCardThenTurnOrderStaysNormal [

	| result aGame |
	aLoadedDie := LoadedDie of: #( 7 7 ).

	aGame := Game
		         numberOfSpaceships: 3
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame spaceshipId: 1 useInstantCard: ReverseCard toDoEffectFor: nil.
	aGame spaceshipId: 2 useInstantCard: RedoCard toDoEffectFor: nil.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 8.
	result at: 2 put: 8.
	result at: 3 put: 1.


	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #reverse }
RedoCardTest >> test07RedoASkipCardThenTwoTurnsAreSkipped [

	| result aGame |
	aLoadedDie := LoadedDie of: #( 7 7 10 ).

	aGame := Game
		         numberOfSpaceships: 3
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame spaceshipId: 3 useInstantCard: SkipCard toDoEffectFor: nil.
	aGame spaceshipId: 1 useInstantCard: RedoCard toDoEffectFor: nil.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 15.
	result at: 2 put: 1.
	result at: 3 put: 1.


	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #reverse }
RedoCardTest >> test08RedoADoubleCardThenSpaceshipOnePlaysThreeTimesInARow [

	| result aGame |
	aLoadedDie := LoadedDie of: #( 7 7 7 15 ).

	aGame := Game
		         numberOfSpaceships: 3
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame spaceshipId: 1 useInstantCard: DoubleCard toDoEffectFor: nil.
	aGame playTurn.
	aGame spaceshipId: 1 useInstantCard: RedoCard toDoEffectFor: nil.
	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 22.
	result at: 2 put: 1.
	result at: 3 put: 1.


	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #freedom }
RedoCardTest >> test09RedoAFreedomCardThenSpaceshipTwoGetsToMove [

	| aGame result |
	aLoadedDie := LoadedDie of: #( 7 7 4 4 10 ).

	collectionOfCells := OrderedCollection new.
	30 timesRepeat: [ collectionOfCells add: Cell new ].

	collectionOfCells at: 8 put: JailCell new.

	aBoardCreator := BoardCreator
		                 with: collectionOfCells
		                 ofLaps: 2
		                 withWormholeCreator: aWormholeCreator.

	aGame := Game
		         numberOfSpaceships: 2
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame spaceshipId: 1 useInstantCard: FreedomCard toDoEffectFor: 1.
	aGame playTurn.
	aGame spaceshipId: 2 useInstantCard: RedoCard toDoEffectFor: 2.
	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 12.
	result at: 2 put: 12.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]
