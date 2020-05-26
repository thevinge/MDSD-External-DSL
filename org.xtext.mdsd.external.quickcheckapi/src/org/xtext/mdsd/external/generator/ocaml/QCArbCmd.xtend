package org.xtext.mdsd.external.generator.ocaml

import org.xtext.mdsd.external.generator.QCRequestProcess
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.util.QCUtils

import static extension org.xtext.mdsd.external.util.QCUtils.*

class QCArbCmd {

	
	def initArb_cmd(Test test ) {
		
		'''
			«test.compileJsonValueTables»
			let arb_cmd state = 
			  let int_gen = Gen.oneof [Gen.small_int] in
			  if state = [] then
			    QCheck.make ~print:show_cmd
			    (Gen.oneof [
			    «FOR request: filterRequireNoIndex(test.requests) SEPARATOR ";"» 
			    	«request.compileGen»
			    «ENDFOR»
			    ])
			    
			  else
			    QCheck.make ~print:show_cmd
			      (Gen.oneof [
			       		  «FOR request: test.requests SEPARATOR ";"»
			       		  «request.compileGen»
			      «ENDFOR»
			      ])
		'''
	}
	
	private def compileGen(Request request){
		'''
		«IF QCUtils.requireIndex(request) » 
			«IF request.body !== null»
			Gen.map (fun i -> («request.compileStateLookup»«request.name.firstCharToUpperCase» (i, «QCRequestProcess.get(request.name).bodyJsonDef.declarationUse»))) int_gen
			«ELSE»
			Gen.map (fun i -> «(request.name.firstCharToUpperCase)» i) int_gen
			«ENDIF»
			
	  	«ELSE» 
	  		«IF request.body !== null»
			(Gen.return («request.name.firstCharToUpperCase» («QCRequestProcess.get(request.name).bodyJsonDef.declarationUse»)))
	  		«ELSE»
	  		(Gen.return («request.name.firstCharToUpperCase» ))
	  		«ENDIF»
	  	«ENDIF»
		'''.toString.trim
	}
	
	def CharSequence compileJsonValueTables(Test test){
		'''
		«FOR request : test.requests»
			«QCRequestProcess.get(request.name).bodyJsonDef?.valueTableDeclaration»
			«QCRequestProcess.get(request.name).stateJsonDef?.valueTableDeclaration»
			«FOR jsonDef : QCRequestProcess.get(request.name).postCondJsonDefs»
				«jsonDef.valueTableDeclaration»
			«ENDFOR»
		«ENDFOR»
		'''
	}
	
	def CharSequence compileStateLookup(Request request){
		if (QCRequestProcess.get(request.name).bodyJsonDef.usesReuseArguments) {
			'''let json = lookupItem i state in '''
		} else {
			''''''
		}
		
	}
}
