package org.xtext.mdsd.external.generator.ocaml

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.PreConjunction
import org.xtext.mdsd.external.quickCheckApi.PreDisjunction
import org.xtext.mdsd.external.quickCheckApi.EmptyCondition
import org.xtext.mdsd.external.quickCheckApi.ContainsCondition
import org.xtext.mdsd.external.generator.QCUtils

class QCPreconditions {
	def initPreconditions(Test test ) {
		'''
			let precond cmd state = match cmd with
			    �FOR request : test.requests�
			    	| �QCUtils.firstCharToUpperCase(request.name)��IF QCUtils.requireIndex(request)� ix -> (List.length state > 0) �ELSE� json -> true�ENDIF� 
			    		�IF request.preconditions !== null� && (�request.preconditions.compilePrecondition�)�ENDIF�
			    �ENDFOR�
		'''
	}
	
	def dispatch CharSequence compilePrecondition(PreDisjunction proposition) {
		'''(�proposition.left.compilePrecondition�) || (�proposition.right.compilePrecondition�)'''
	}
	
	def dispatch CharSequence compilePrecondition(PreConjunction proposition) {
		'''(�proposition.left.compilePrecondition�) && (�proposition.right.compilePrecondition�)'''
	}
	
	def dispatch CharSequence compilePrecondition(ContainsCondition condition){
		'''inSpace (�condition.value�) state�IF condition.notOp.toLowerCase === "not"� = false�ENDIF�'''	
	}
	def dispatch CharSequence compilePrecondition(EmptyCondition condition){
		'''isEmpty state�IF condition.notOp?.compareTo("not") === 0� = false�ENDIF�'''
	}

}
	
	