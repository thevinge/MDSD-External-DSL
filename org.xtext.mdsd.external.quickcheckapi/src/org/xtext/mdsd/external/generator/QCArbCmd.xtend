package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.generator.QCUtils
class QCArbCmd {
	
	def initArb_cmd(Test test ) {
		
		'''
		let arb_cmd state = 
		  let int_gen = Gen.oneof [Gen.small_int] in
		  if state = [] then
		    QCheck.make ~print:show_cmd
		    (Gen.oneof [
		    «FOR request: QCUtils.filterRequireNoIndex(test.requests) SEPARATOR ";"» 
		    (Gen.return («QCUtils.firstCharToUpperCase(request.name)» "«QCUtils.compileJson(request.body.value)»"))
		    «ENDFOR»
		    ])
		    
		  else
		    QCheck.make ~print:show_cmd
		      (Gen.oneof [
			      		  «FOR request: test.requests SEPARATOR ";"»
			      		  «IF QCUtils.requireIndex(request) » 
			      		  Gen.map (fun i -> «QCUtils.firstCharToUpperCase(request.name)» i) int_gen
			      		  «ELSE» 
			      		  (Gen.return («QCUtils.firstCharToUpperCase(request.name)» "«QCUtils.compileJson(request.body.value)»"))
			      		  «ENDIF»
						  «ENDFOR»
		                 ])
		'''
	}
	
	
	
}