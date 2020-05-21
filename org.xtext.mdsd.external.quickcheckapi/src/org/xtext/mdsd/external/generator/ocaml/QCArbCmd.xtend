package org.xtext.mdsd.external.generator.ocaml

import org.xtext.mdsd.external.generator.QCRequestProcess
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.util.QCUtils

class QCArbCmd {

	
	def initArb_cmd(Test test ) {
		
		'''
			let arb_cmd state = 
			  let int_gen = Gen.oneof [Gen.small_int] in
			  if state = [] then
			    QCheck.make ~print:show_cmd
			    (Gen.oneof [
			    «FOR request: QCUtils.filterRequireNoIndex(test.requests) SEPARATOR ";"» 
			    	(Gen.return («QCUtils.firstCharToUpperCase(request.name)» («QCRequestProcess.get(request.name).bodyJsonDef.declarationUse»)))
			    «ENDFOR»
			    ])
			    
			  else
			    QCheck.make ~print:show_cmd
			      (Gen.oneof [
			       		  «FOR request: test.requests SEPARATOR ";"»
			       		  	«IF QCUtils.requireIndex(request) » 
			       		  		Gen.map (fun i -> «QCUtils.firstCharToUpperCase(request.name)» i) int_gen
			       		  	«ELSE» 
			       		  		(Gen.return («QCUtils.firstCharToUpperCase(request.name)» («QCRequestProcess.get(request.name).bodyJsonDef.declarationUse»)))
			       		  	«ENDIF»
			      «ENDFOR»
			      ])
		'''
	}
		
}
