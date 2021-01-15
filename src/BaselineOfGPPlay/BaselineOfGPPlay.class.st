Class {
	#name : #BaselineOfGPPlay,
	#superclass : #BaselineOf,
	#category : #BaselineOfGPPlay
}

{ #category : #baselines }
BaselineOfGPPlay >> baseline: spec [

	 <baseline>
	 spec for: #common do: [ 
		 spec
			 package: 'GPPlay' ]
]
