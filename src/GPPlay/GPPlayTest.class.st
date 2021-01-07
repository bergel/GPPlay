Class {
	#name : #GPPlayTest,
	#superclass : #TestCase,
	#instVars : [
		'p'
	],
	#category : #GPPlay
}

{ #category : #tests }
GPPlayTest >> setUp [
	p := GPPlay new
]

{ #category : #tests }
GPPlayTest >> test01 [
	self deny: (p m: Object new)
]

{ #category : #tests }
GPPlayTest >> test02 [
	self assert: (p m: 'hello')
]

{ #category : #tests }
GPPlayTest >> test03 [
	self assert: (p m: #('hello' 'world'))
]
