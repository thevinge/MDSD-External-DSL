package org.xtext.mdsd.external.generator.ocaml

import org.xtext.mdsd.external.generator.QCRequestProcess
import org.xtext.mdsd.external.generator.QCUtils
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.NoAction
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.UpdateAction

class QCNextState {


	def initNext_State(Test test ) {
		'''
			«compileJsonValueTables(test)»
			
			let next_state cmd state = match cmd with
				«FOR request : test.requests»
					| «QCUtils.firstCharToUpperCase(request.name)» «request.compileNextState»
				«ENDFOR»
		'''
	}
	
	def CharSequence compileNextState(Request request){
		request.action.compile(request)
	}
	
	def CharSequence compile(Action action, Request request){
		if (action instanceof CreateAction) {

			'''json -> state@[«QCRequestProcess.get(request.name).stateJsonDef.declarationUse»]'''	
		} else if (action instanceof DeleteAction){
			'''
				ix -> let pos = getPos ix state in
				      (* Returns a list of all items except that which is 'item' found above *)
				      let l = remove_item pos state in
				      l
			      '''
		} else if (action instanceof UpdateAction){
			'''
				ix -> let pos = getPos ix state in
				      	let json = lookupItem ix state in
				      		let newelem = «QCRequestProcess.get(request.name).stateJsonDef.declarationUse» in
				      			replaceElem pos state newelem
			'''	
		} else if (action instanceof NoAction){
			'''ix -> state'''
		} else {
			''''''
		}
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


}
	
	