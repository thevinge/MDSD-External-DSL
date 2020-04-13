package org.xtext.mdsd.external.generator

class QCModelSystem {
		
	def CharSequence initModelSystem() {
		'''
		let init_state = []
		let init_sut() = ref []
		let cleanup _  =  afterTestcleanup
		'''
		// TODO Require Cleanup HTTP-endpoint in DSL
	}
}