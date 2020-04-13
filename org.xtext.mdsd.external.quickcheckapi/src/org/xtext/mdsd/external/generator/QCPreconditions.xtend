package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.Preproposition

class QCPreconditions {
	def initPreconditions(Test test ) {
		'''
		let precond cmd state = match cmd with
		    «FOR request : test.requests»
		    | «QCUtils.toUpperCaseFunction(request.name)»«IF QCUtils.requireIndex(request)» ix -> (List.length state > 0) «ELSE» -> true«ENDIF»
		    «ENDFOR»
		'''
	}
	
	def dispatch CharSequence compilePrecondition(Preproposition proposition) {
		'''
		«proposition.left.compilePrecondition» «proposition.right.compilePrecondition»
		'''
	}	
}
	
	