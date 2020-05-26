package org.xtext.mdsd.external.generator.ocaml

import org.xtext.mdsd.external.generator.QCRequestProcess
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.NoAction
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.UpdateAction
import org.xtext.mdsd.external.util.QCUtils

import static extension org.xtext.mdsd.external.util.QCUtils.*

class QCNextState {


	def initNext_State(Test test ) {
		'''
			
			let next_state cmd state = match cmd with
				«FOR request : test.requests»
					| «request.name.firstCharToUpperCase» «request.compileNextState»
				«ENDFOR»
		'''
	}
	
	def CharSequence compileNextState(Request request){
		request.action.compile(request)
	}
	
	def CharSequence compile(Action action, Request request){
		if (action instanceof CreateAction) {

			'''«request.compileArguments» -> state@[«QCRequestProcess.get(request.name).stateJsonDef.declarationUse»]'''	
		} else if (action instanceof DeleteAction){
			'''
				«request.compileArguments» -> let pos = getPos ix state in
				      (* Returns a list of all items except that which is 'item' found above *)
				      let l = remove_item pos state in
				      l
			      '''
		} else if (action instanceof UpdateAction){
			'''
				«request.compileArguments» -> let pos = getPos ix state in
				      	let json = lookupItem ix state in
				      		let newelem = «QCRequestProcess.get(request.name).stateJsonDef.declarationUse» in
				      			replaceElem pos state newelem
			'''	
		} else if (action instanceof NoAction){
			'''«request.compileArguments» -> state'''
		} else {
			''''''
		}
	}
	
	def CharSequence compileArguments(Request request){
		
			if (QCUtils.requireIndex(request)) {
			if (request.body !== null) {
				''' (ix, cmdJson)'''
			} else {
				''' ix'''
			}
			
		} else {
			if (request.body !== null) {
				''' json'''
			} else {
				''''''
			}
		}
//		if (request.action instanceof CreateAction) {
//			'''json'''	
//		} else if (request.action instanceof DeleteAction){
//			if (request.body !== null) {
//				'''(ix, cmdJson)'''
//			} else {
//				'''ix'''
//			}
//			
//		} else if (request.action instanceof UpdateAction){
//			if (request.body !== null) {
//				'''(ix, cmdJson)'''
//			} else {
//				'''ix'''
//			}
//		} else if (request.action instanceof NoAction){
//			if (request.body !== null) {
//				'''(ix, cmdJson)'''
//			} else {
//				'''ix'''
//			}
//		} else {
//			''''''
//		}
	}
	
	



}
	
	