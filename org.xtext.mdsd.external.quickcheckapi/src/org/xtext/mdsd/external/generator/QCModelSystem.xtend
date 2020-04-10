package org.xtext.mdsd.external.generator

class QCModelSystem {
		
	def CharSequence initModelSystem() {
		'''
		let init_state = []
		let init_sut() = ref []
		let cleanup _  =  ignore(Http.rawpost ("http://167.172.184.103" ^ "/api/shop/reset") "")
		'''
		// TODO Require Cleanup HTTP-endpoint in DSL
	}
}