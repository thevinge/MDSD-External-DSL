package org.xtext.mdsd.external.generator.ocaml

import org.xtext.mdsd.external.quickCheckApi.ContainsCondition
import org.xtext.mdsd.external.quickCheckApi.EmptyCondition
import org.xtext.mdsd.external.quickCheckApi.PreConjunction
import org.xtext.mdsd.external.quickCheckApi.PreDisjunction
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.util.QCUtils

import static extension org.xtext.mdsd.external.util.QCUtils.*

class QCPreconditions {
	def initPreconditions(Test test ) {
		'''
			let precond cmd state = match cmd with
			    «FOR request : test.requests»
			    	| «request.name.firstCharToUpperCase» «request.determineArguments» «IF QCUtils.requireIndex(request)» (List.length state > 0) «ELSE» true«ENDIF» 
			    		«IF request.preconditions !== null» && («request.preconditions.compilePrecondition»)«ENDIF»
			    «ENDFOR»
		'''
	}
	
	def CharSequence determineArguments(Request request){
		if (QCUtils.requireIndex(request)) {
			if (request.body !== null) {
				''' (ix, cmdJson) ->'''
			} else {
				''' ix ->'''
			}
			
		} else {
			if (request.body !== null) {
				''' json ->'''
			} else {
				''' ->'''
			}
			
		}
	
	}
	
	def dispatch CharSequence compilePrecondition(PreDisjunction proposition) {
		'''(«proposition.left.compilePrecondition») || («proposition.right.compilePrecondition»)'''
	}
	
	def dispatch CharSequence compilePrecondition(PreConjunction proposition) {
		'''(«proposition.left.compilePrecondition») && («proposition.right.compilePrecondition»)'''
	}
	
	def dispatch CharSequence compilePrecondition(ContainsCondition condition){
		'''inSpace («condition.value») state«IF condition.notOp.toLowerCase === "not"» = false«ENDIF»'''	
	}
	def dispatch CharSequence compilePrecondition(EmptyCondition condition){
		'''isEmpty state«IF condition.notOp?.compareTo("not") === 0» = false«ENDIF»'''
	}

}
	
	