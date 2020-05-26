package org.xtext.mdsd.external.generator.ocaml

import org.xtext.mdsd.external.quickCheckApi.Test

class QCModelSystem {
		
	def CharSequence initModelSystem(Test test) {
		'''
			let init_state = []
			let init_sut() = ref []
			let cleanup _  =  «test.afterTestcleanup»
		'''
		// TODO Require Cleanup HTTP-endpoint in DSL
	}
	
	def afterTestcleanup(Test test) {
		if (test.resetHook !== null) {
			'''ignore(Http.rawpost (resetHook) "")'''
		} else {
			'''afterTestcleanup'''
		}
		
	}
	
}
