Class {
	#name : #GameWithDefinedPositionsOfCellsTest,
	#superclass : #TestCase,
	#instVars : [
		'aLoadedDie',
		'aWormholeCreator',
		'collectionOfCells',
		'aBoardCreator',
		'gameDeck',
		'aConversor',
		'values'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #running }
GameWithDefinedPositionsOfCellsTest >> setUp [

	super setUp.
	aLoadedDie := LoadedDie of: #( 6 ).

	aConversor := Conversor totalCells: 4 convertionValue: 8.
	values := OrderedCollection
		          with: (Parsecs ofValue: 10)
		          with: (LightYear ofValue: 24)
		          with: (Parsecs ofValue: 6)
		          with: (Parsecs ofValue: 4).

	aWormholeCreator := WormholeCreator withBeginning: 2 andEnd: 3.
	collectionOfCells := OrderedCollection new.

	10 timesRepeat: [ collectionOfCells add: Cell new ].

	collectionOfCells at: 5 put: AtomicBombCell new.
	collectionOfCells at: 6 put: BlackHoleCell new.
	collectionOfCells at: 4 put: CardDispenserCell new.
	collectionOfCells
		at: 8
		put:
		(HyperGravityCell withValueToMove: aLoadedDie amountOfFaces // 2).
	collectionOfCells
		at: 9
		put: (HyperJumpCell withConversor: aConversor andValues: values).
	collectionOfCells at: 7 put: (MoonWalkCell withValueToMove: 4).

	aBoardCreator := BoardCreator
		                 with: collectionOfCells
		                 ofLaps: 2
		                 withWormholeCreator: aWormholeCreator.

	gameDeck := EffectManager
		            manage: (OrderedCollection withAll: {
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
		            withProbabilitiesDistribution:
		            #( 10 10 10 10 10 10 10 10 10 10 )
]

{ #category : #'atomic bomb' }
GameWithDefinedPositionsOfCellsTest >> test01GameMovesSpaceshipWhichEntersAtomicBombThenEveryoneGoesBackToCellOne [

	| result aGame |
	aLoadedDie := LoadedDie of: #( 9 8 4 ).

	aGame := Game
		         numberOfSpaceships: 3
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 1.
	result at: 2 put: 1.
	result at: 3 put: 1.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #'hyper jump' }
GameWithDefinedPositionsOfCellsTest >> test02GameMovesSpaceshipEntersHyperJumpThenReturnsNewPositionAdjustedByParsecs [

	| result aGame |
	aLoadedDie := LoadedDie of: #( 9 8 3 ).

	aGame := Game
		         numberOfSpaceships: 3
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 10.
	result at: 2 put: 4.
	result at: 3 put: 4.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #'moon walk' }
GameWithDefinedPositionsOfCellsTest >> test03SpaceshipThreeEntersMoonWalkThenEveryOtherSpaceshipGoesBackAValue [

	| result aGame |
	aLoadedDie := LoadedDie of: #( 9 9 6 ).

	aGame := Game
		         numberOfSpaceships: 3
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 6.
	result at: 2 put: 6.
	result at: 3 put: 7.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #'black hole' }
GameWithDefinedPositionsOfCellsTest >> test04GameMovesSpaceshipsOneEntersBlackHoleThenPositionIsMinusFour [

	| result aGame |
	aLoadedDie := LoadedDie of: #( 5 9 9 ).

	aGame := Game
		         numberOfSpaceships: 3
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 2.
	result at: 2 put: 10.
	result at: 3 put: 10.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #'hyper gravity' }
GameWithDefinedPositionsOfCellsTest >> test05SpaceshipOneEntersHyperGravityAndRollsLessThanMinuminValueThenStaysThere [

	| result aGame |
	aLoadedDie := LoadedDie of: #( 7 9 2 ).

	aGame := Game
		         numberOfSpaceships: 2
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 8.
	result at: 2 put: 10.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #'hyper gravity' }
GameWithDefinedPositionsOfCellsTest >> test06SpaceshipEntersHyperGravityAndRollsValueThenSpaceshipCanMove [

	| result aGame |
	aLoadedDie := LoadedDie of: #( 7 9 6 ).

	aGame := Game
		         numberOfSpaceships: 2
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 4.
	result at: 2 put: 10.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #'hyper jump' }
GameWithDefinedPositionsOfCellsTest >> test07SecondSpaceshipAndThirdSpaceshipEnterHyperJumpThenThirdMovesLessParsecsThanSecond [

	| result aGame |
	aLoadedDie := LoadedDie of: #( 9 8 8 ).

	aGame := Game
		         numberOfSpaceships: 3
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 10.
	result at: 2 put: 4.
	result at: 3 put: 3.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #'card dispenser' }
GameWithDefinedPositionsOfCellsTest >> test08SpaceshipEntersCardDispenserThenItCanUseTwoAccelerationCards [

	| aGame result |
	aLoadedDie := LoadedDie of: #( 3 3 3 50 ).

	collectionOfCells := OrderedCollection new.
	10 timesRepeat: [ collectionOfCells add: Cell new ].
	collectionOfCells at: 4 put: CardDispenserCell new.

	aBoardCreator := BoardCreator
		                 with: collectionOfCells
		                 ofLaps: 2
		                 withWormholeCreator: aWormholeCreator.

	gameDeck := LoadedEffectManager manage:
		            (OrderedCollection with: AccelerationCard).

	aGame := Game
		         numberOfSpaceships: 1
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame usePermanentCard: AccelerationCard toDoEffectFor: nil.
	aGame usePermanentCard: AccelerationCard toDoEffectFor: nil.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 9.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #'black hole' }
GameWithDefinedPositionsOfCellsTest >> test09SpaceshipFallsOnBlackHoleThenGoesBackOnlyTheAllowedMovements [

	| result aGame |
	aWormholeCreator := WormholeCreator withBeginning: 8 andEnd: 9.
	collectionOfCells := OrderedCollection new.

	10 timesRepeat: [ collectionOfCells add: Cell new ].

	collectionOfCells at: 2 put: BlackHoleCell new.

	aBoardCreator := BoardCreator
		                 with: collectionOfCells
		                 ofLaps: 2
		                 withWormholeCreator: aWormholeCreator.

	gameDeck := EffectManager
		            manage: (OrderedCollection
				             with: AccelerationCard new
				             with: AllyCard new
				             with: OverloadCard new
				             with: RedoCard new
				             with: RepeatCard new
				             with: CancellationCard new)
		            withProbabilitiesDistribution: #( 16 16 17 17 17 17 ).
	aLoadedDie := LoadedDie of: #( 1 5 ).

	aGame := Game
		         numberOfSpaceships: 1
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 1.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #'black hole' }
GameWithDefinedPositionsOfCellsTest >> test10SpaceshipFallsOnBlackHoleThenGoesBackALap [

	| result aGame |
	aWormholeCreator := WormholeCreator withBeginning: 8 andEnd: 9.
	collectionOfCells := OrderedCollection new.

	10 timesRepeat: [ collectionOfCells add: Cell new ].

	collectionOfCells at: 2 put: BlackHoleCell new.

	aBoardCreator := BoardCreator
		                 with: collectionOfCells
		                 ofLaps: 2
		                 withWormholeCreator: aWormholeCreator.

	gameDeck := EffectManager
		            manage: (OrderedCollection
				             with: AccelerationCard new
				             with: AllyCard new
				             with: OverloadCard new
				             with: RedoCard new
				             with: RepeatCard new
				             with: CancellationCard new)
		            withProbabilitiesDistribution: #( 16 16 17 17 17 17 ).
	aLoadedDie := LoadedDie of: #( 10 1 ).

	aGame := Game
		         numberOfSpaceships: 1
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 8.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #'black hole' }
GameWithDefinedPositionsOfCellsTest >> test11SpaceshipGoesToJailThenOnlyMovesWhenMaxDiceThrow [

	| result aGame |
	aWormholeCreator := WormholeCreator withBeginning: 7 andEnd: 8.
	collectionOfCells := OrderedCollection new.

	10 timesRepeat: [ collectionOfCells add: Cell new ].

	collectionOfCells at: 2 put: JailCell new.

	aBoardCreator := BoardCreator
		                 with: collectionOfCells
		                 ofLaps: 2
		                 withWormholeCreator: aWormholeCreator.

	gameDeck := EffectManager
		            manage: (OrderedCollection withAll: {
					             AccelerationCard.
					             AllyCard.
					             OverloadCard.
					             RedoCard.
					             RepeatCard.
					             CancellationCard.
					             ReverseCard.
					             SkipCard.
					             DoubleCard })
		            withProbabilitiesDistribution:
		            #( 12 11 11 11 11 11 11 11 11 ).

	aLoadedDie := LoadedDie of: #( 1 5 7 ).

	aGame := Game
		         numberOfSpaceships: 1
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 9.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]

{ #category : #'hyper space jump' }
GameWithDefinedPositionsOfCellsTest >> test12SpaceshipEnterHyperSpaceJumpThenItMovesFourCellsWithoutUsingFuel [

	| result aGame |
	aWormholeCreator := WormholeCreator withBeginning: 2 andEnd: 3.
	collectionOfCells := OrderedCollection new.

	30 timesRepeat: [ collectionOfCells add: Cell new ].

	collectionOfCells at: 8 put: HyperSpaceJumpCell new.

	aBoardCreator := BoardCreator
		                 with: collectionOfCells
		                 ofLaps: 2
		                 withWormholeCreator: aWormholeCreator.

	aLoadedDie := LoadedDie of: #( 7 6 10 ).

	aGame := Game
		         numberOfSpaceships: 1
		         with: aBoardCreator
		         playWith: aLoadedDie
		         andGameDeck: gameDeck.

	aGame playTurn.
	aGame playTurn.

	result := Dictionary new.
	result at: 1 put: 18.

	self assert: aGame spaceships cellsOfSpaceships equals: result
]
