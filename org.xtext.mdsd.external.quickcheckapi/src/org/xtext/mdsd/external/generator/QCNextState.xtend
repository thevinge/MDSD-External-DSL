package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.UpdateAction
import org.xtext.mdsd.external.quickCheckApi.NoAction
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import javax.inject.Inject
import org.xtext.mdsd.external.quickCheckApi.JsonRef

class QCNextState {


	def initNext_State(Test test ) {
		'''
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
			ix -> let newelem = «QCRequestProcess.get(request.name).stateJsonDef.declarationUse» () in
			      let pos = getPos ix state in
			      replaceElem pos state newelem
			'''	
		} else if (action instanceof NoAction){
			'''ix -> state'''
		} else {
			''''''
		}
	}
	
//	private def dispatch String compileJsonDefName(Json json, String requestName){
//		QCNames.LocalStateJsonDef(requestName)
//	}
//	
//	private def dispatch String compileJsonDefName(JsonDefRef json, String requestName){
//		QCNames.JsonDefName(json.ref.name)
//	}
//
//	private def dispatch CharSequence compileReuseJson(Json json, String requestName){
//		if(QCJsonReuse.isReuseJson(json)){
//			'''(«QCNames.LocalStateValueTable(requestName)»(json))'''
//		} else{
//			'''()'''
//		}
//		
//	}
//	
//	private def dispatch CharSequence compileReuseJson(JsonDefRef json, String requestName){
//		if(QCJsonReuse.isReuseJson(json)){
//			'''(«QCNames.LocalStateValueTable(json.ref.name)»(json))'''
//		} else{
//			'''()'''
//		}
//		
//	}


}
	
	