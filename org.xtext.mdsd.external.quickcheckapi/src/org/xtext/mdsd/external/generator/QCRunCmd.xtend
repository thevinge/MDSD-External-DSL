package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.UpdateAction
import org.xtext.mdsd.external.quickCheckApi.NoAction
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.PostConjunction
import org.xtext.mdsd.external.quickCheckApi.PostDisjunction
import org.xtext.mdsd.external.quickCheckApi.GET
import org.xtext.mdsd.external.quickCheckApi.DELETE
import org.xtext.mdsd.external.quickCheckApi.PATCH
import org.xtext.mdsd.external.quickCheckApi.PUT
import org.xtext.mdsd.external.quickCheckApi.POST
import org.xtext.mdsd.external.quickCheckApi.Body
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.BodyCondition
import org.xtext.mdsd.external.quickCheckApi.CodeCondition
import org.xtext.mdsd.external.quickCheckApi.RequestOp
import org.xtext.mdsd.external.quickCheckApi.URLDefRef
import org.xtext.mdsd.external.quickCheckApi.URL
import org.xtext.mdsd.external.quickCheckApi.Method

class QCRunCmd {
	private String requestName;
	private int declarationCounter = 0;
	
	def initRun_cmd(Test test ) {
		'''
		let run_cmd cmd state sut = match cmd with
			�FOR request : test.requests�
			�{declarationCounter = 0; ""}�
			�{requestName = request.name; ""}�
			| �QCUtils.firstCharToUpperCase(request.name)� �request.action.determineIndex� if (checkInvariant state sut) then �request.compileRunCmd� else false
			�ENDFOR�
		'''
	}
	
	def CharSequence determineIndex(Action action){
		var actionOp = action.actionOp
		if (actionOp instanceof DeleteAction || actionOp instanceof UpdateAction || actionOp instanceof NoAction){
			'''ix ->'''
		} else {
			'''json ->'''
		}
	}
	
	def CharSequence createHttpCall(Request request) {
		if (request.url.CheckRequestID) {			
			'''
				let code,content = Http.�request.method.compileMethod� �QCUtils.firstCharLowerCase(request.name)�URL�IF !isGetMethod(request.method)� �IF request.body !== null�json�ENDIF��ENDIF� in
			'''
		} else {
			'''
			let id = lookupSutItem ix !sut in
				let code,content = Http.�request.method.compileMethod� (�QCUtils.firstCharLowerCase(request.name)�URL^"/"^id)�IF !isGetMethod(request.method)� �IF request.body !== null�json�ENDIF��ENDIF� in
			'''
		}
		
	}
	
	def boolean isGetMethod(Method method){
		return (GET.isAssignableFrom(method.class))
	}
	
	
	def dispatch boolean CheckRequestID(URL url){
		return (url.requestID === null)
	}
	
	def dispatch boolean CheckRequestID(URLDefRef url){
		return (url.ref.url.CheckRequestID)
	}	
	
	def dispatch CharSequence compileMethod(GET get) {
		'''get'''
	}
	def dispatch CharSequence compileMethod(POST get) {
		'''post'''
	}
	def dispatch CharSequence compileMethod(PUT get) {
		'''put'''
	}
	def dispatch CharSequence compileMethod(PATCH get) {
		'''patch'''
	}
	def dispatch CharSequence compileMethod(DELETE get) {
		'''delete'''
	}
	
	
	def CharSequence compileRunCmd(Request request){
		'''
		
		�request.createHttpCall�
		�request.action.actionOp.compileAction�
		�request.postconditions.compilePostCondition�
		'''
	}
	
	def dispatch CharSequence compilePostCondition(PostConjunction and) {
		'''
		(�and.left.compilePostCondition�) && (�and.right.compilePostCondition�)
		'''
	}
	
	def dispatch CharSequence compilePostCondition(PostDisjunction or) {
		'''(�or.left.compilePostCondition�) || (�or.right.compilePostCondition�)'''
	}
	
	def dispatch CharSequence compilePostCondition(CodeCondition condition) {
		'''�condition.requestOp.compileRequestOp� (code == �condition.statusCode.code�)'''
	}
	
	def dispatch CharSequence compilePostCondition(BodyCondition condition) {
		if(condition.requestValue.body !== null){
			declarationCounter++
			'''�condition.requestOp.compileRequestOp� (String.compare (Yojson.Basic.to_string �QCNames.LocalPostConditionJsonDef(requestName) + declarationCounter + "()"�) (Yojson.Basic.to_string content) == 0)'''
		} else if (condition.requestValue.body === null){
		'''
		let extractedState = lookupItem ix state in
			let id = lookupSutItem ix !sut in
				let stateJson = Yojson.Basic.from_string extractedState in
					let combined = combine_state_id stateJson id in
						�condition.requestOp.compileRequestOp� (String.compare (Yojson.Basic.to_string combined) (Yojson.Basic.to_string content) == 0)
		'''
		}
	}
	
	def CharSequence compileRequestOp(RequestOp op){
		if(op.notOp === null || op.notOp == ""){
			''''''
		} else {
			'''not '''
		}
	}
	
	
	def dispatch CharSequence compileAction(CreateAction action) {
		'''
		let id = extractIdFromContent content in
			sut := !sut@[id];
		'''
	}
	def dispatch CharSequence compileAction(DeleteAction action) {
		'''
	    let pos = getPos ix !sut in
	    	sut := remove_item pos !sut;
		'''
	}
	def dispatch CharSequence compileAction(UpdateAction action) {
		// Doesn't update sut so should not do anything
		''''''
	}
	def dispatch CharSequence compileAction(NoAction action) {
		// Doesn't update sut so should not do anything
		''''''
	}	
}