Class {
	#name : #SpaceshipTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #'tests - initialization' }
SpaceshipTest >> testSpaceshipInitializeInPositionZero [

| aSpaceship |

aSpaceship:= Spaceship launch.

self assert: (aSpaceship move:1) equals: 1.
]

{ #category : #move }
SpaceshipTest >> testSpaceshipMovesTwiceAndIsInPositionTwo [

| aSpaceship |

aSpaceship:= Spaceship launch.
aSpaceship move:1.

self assert: (aSpaceship move:1) equals: 2.
]

{ #category : #move }
SpaceshipTest >> testWhenASpaceshipMovesTwiceWithTwoJumps [
| aSpaceship |
aSpaceship:= Spaceship launch.
self assert: (aSpaceship move:2) equals: 2.
]

{ #category : #move }
SpaceshipTest >> testWhenSpaceshipMovesTwiceThenPositionIsThree [
| aSpaceship |
aSpaceship:= Spaceship launch .
aSpaceship  move:2.
self assert: (aSpaceship move: 1) equals: 3.
]

{ #category : #tests }
SpaceshipTest >> testWhenSpaceshipMovesTwiceThenPositionReturnsTwo [
| aSpaceship |
aSpaceship:= Spaceship launch .
aSpaceship move:1 .
aSpaceship move:1.
self assert: aSpaceship position equals: 2.
]

{ #category : #'tests - initialization' }
SpaceshipTest >> testWhenSpaceshipThenPositionReturnsZero [

| aSpaceship |
aSpaceship:= Spaceship launch .
self assert: aSpaceship position equals: 0.
]