package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.generator.QCUtils
class QCArbCmd {
	
	def initArb_cmd(Test test) {
		
		'''
		let arb_cmd state = 
		(*If nothing is in the state we cannot fetch or delete anything, therefore we ensure that we will only create in this case*)
		  if state = [] then
		    QCheck.make ~print:show_cmd
		    (Gen.oneof [
		    «FOR request: QCUtils.filterRequireNoIndex(test.requests) SEPARATOR ";"» 
		    (Gen.return «QCUtils.toUpperCaseFunction(request.name)»)
		    «ENDFOR»
		    ])
		    
		  else
		    QCheck.make ~print:show_cmd
		      (Gen.oneof [
			      		  «FOR request: test.requests SEPARATOR ";"»
			      		  «IF QCUtils.requireIndex(request) » 
			      		  Gen.map (fun i -> «QCUtils.toUpperCaseFunction(request.name)» i) Gen.small_int
			      		  «ELSEIF QCUtils.requireType(request)»
			      		  Gen.map (fun c -> Post c) «test.model.modelUnderTest.name»_generator
			      		  «ELSE» 
			      		  (Gen.return «QCUtils.toUpperCaseFunction(request.name)»)
			      		  «ENDIF»
						  «ENDFOR»
		                 ])
		'''
	}
	
	
	
	
}