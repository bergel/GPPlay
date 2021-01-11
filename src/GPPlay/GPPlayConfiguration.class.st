Class {
	#name : #GPPlayConfiguration,
	#superclass : #GPConfiguration,
	#instVars : [
		'grammar'
	],
	#category : #GPPlay
}

{ #category : #operations }
GPPlayConfiguration >> createNewIndividual [	
	| rootNode |
	rootNode := self newFunction.
	^ rootNode
]

{ #category : #operations }
GPPlayConfiguration >> distanceFromSolutionOf: individual [
	"^ (individual evaluate - 234) abs"
	
	| p |
	p := GPPlay new.
	p assertionGP: [ :obj | individual evaluateWith: { 'obj' -> obj } asDictionary ].
	individual fitness: GPPlayTest buildSuite run passedCount negated.
	^ individual fitness
]

{ #category : #example }
GPPlayConfiguration >> example [ 	
	| e |
	e := GPEngine new.
	GPRandom seed: 1342.
	e configuration: GPPlayConfiguration new.
	e execute.
	^ e pickBestIndividual.
]

{ #category : #initialization }
GPPlayConfiguration >> initialize [ 
	super initialize.
	grammar := self initializeGrammar.
]

{ #category : #initialization }
GPPlayConfiguration >> initializeGrammar [
	"Should find something like:
		obj isNotNil and: [ obj isCollection ]
		
	Messages the algorithm can use:
		isNil
		or:
		and:
		isCollection
		isNumber
		isByteString
		isFloat
	"
	grammar := GPContextFreeGrammar new.
	grammar 
		addRule: #E ofClass: RBMessageNode withSequence: #(#E #And #Block);
		addRule: #E redirectingTo: #Variable;
		addRule: #E redirectingTo: #E2;
		addRule: #E2 ofClass: RBMessageNode withSequence: #(#Variable #Message);
		
		addMessageRule: #And withValues: #(#and:);
		addMessageRule: #Message withValues: #(#isNil #isCollection #isNumber #isByteString #isFloat);
		addRule: #Block ofClass: RBBlockNode withSequence: #(#E);
		addLeafRule: #Variable ofClass: RBVariableNode withValues: #('obj').
	^ grammar
	
	"grammar := GPContextFreeGrammar new.
	grammar 
      addRule: #E ofClass: RBMessageNode withSequence: #( #E #AddOp #T );
		addMessageRule: #AddOp withValues: #( #+ );
      addRule: #E redirectingTo: #T;
		addRule: #T ofClass: RBMessageNode  withSequence: #( #T #MultOp #F );
	 	addMessageRule: #MultOp withValues: #( #* );
	 	addRule: #T redirectingTo: #F;
	 	addLeafRule: #F ofClass: RBLiteralNode withValues: (1 to: 10).
	^ grammar"
]

{ #category : #operations }
GPPlayConfiguration >> mutate: individual [
	| nodeToMutate source |
	"nodeToMutate := self randomElementOf: (individual withAllChildren select: [ :n | n isLeafNode ])."
	source := self newTerminal.
	nodeToMutate := individual withAllChildren detect: [ :ch | ch isKindOf: source class ] 
		ifNone: [ | types found |
			found := false.
			types := (individual withAllChildren collect: #class) asSet.
			[ found ] whileFalse: [ source := self newTerminal.
				found := types includes: source class ].
			individual withAllChildren detect: [ :ch | ch isKindOf: source class ] ifNone: [ self halt ].
		].
	nodeToMutate evaluationBlock: source evaluationBlock.
	nodeToMutate printBlock: source printBlock.
	nodeToMutate type: source type.
]

{ #category : #hooks }
GPPlayConfiguration >> newFunction [ 
	| node |
	node := grammar expandFrom: #E.
	node evaluationBlock: [ :n :ctx | grammar generateASTFrom: n.
		n ast ];
		printBlock: [ :n :ctx | n ast formattedCode ].
	^ node
]

{ #category : #hooks }
GPPlayConfiguration >> newTerminal [
	^ self newFunction 
]

{ #category : #accessing }
GPPlayConfiguration >> populationSize [ 
	^ 20
]
