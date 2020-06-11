package org.xtext.mdsd.external.generator.ocaml

import org.xtext.mdsd.external.generator.QCJsonExcluder
import org.xtext.mdsd.external.generator.QCJsonIDExtractor
import org.xtext.mdsd.external.generator.QCRequestProcess
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.BodyCondition
import org.xtext.mdsd.external.quickCheckApi.CodeCondition
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.DELETE
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.GET
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.Method
import org.xtext.mdsd.external.quickCheckApi.NoAction
import org.xtext.mdsd.external.quickCheckApi.PATCH
import org.xtext.mdsd.external.quickCheckApi.POST
import org.xtext.mdsd.external.quickCheckApi.PUT
import org.xtext.mdsd.external.quickCheckApi.PostConjunction
import org.xtext.mdsd.external.quickCheckApi.PostDisjunction
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.RequestOp
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.UpdateAction
import org.xtext.mdsd.external.util.QCUtils
import org.eclipse.emf.common.util.EList
import static org.eclipse.emf.ecore.util.EcoreUtil.*

import static extension org.eclipse.xtext.EcoreUtil2.*
import static extension org.xtext.mdsd.external.util.QCNames.*
import static extension org.xtext.mdsd.external.util.QCUtils.*

class QCRunCmd {
	private int declarationCounter = 0;
	private Request currentRequest;
	
	private QCJsonExcluder excluder = new QCJsonExcluder;

	
	def initRun_cmd(Test test ) {
		'''
		let run_cmd cmd state sut = match cmd with
			�test.iterateRequests�
		'''
		
	}
	
	def CharSequence iterateRequests(Test test){
		var result = ''''''	
		for (request : test.requests){
			declarationCounter = 0
			currentRequest = request
			result +=
			'''
			| �request.name.firstCharToUpperCase� �request.action.determineArguments� �request.compileRunCmd�
			'''
		}
		result
	}
	
	def CharSequence determineArguments(Action action){
		val request = action.getContainerOfType(Request)
		if (QCUtils.requireIndex(request)) {
			if (request.body !== null) {
				''' (ix, cmdJson) ->'''
			} else {
				''' ix ->'''
			}
			
		} else {
			if (request.body !== null) {
				''' json ->'''
			} else {
				''' ->'''
			}
		}
	
	}
	
	def CharSequence determineParameter(Request request){
		if (QCUtils.requireIndex(request)) {
			if (request.body !== null) {
				'''cmdJson'''
			} else {
				'''""'''
			}	
		} else {
			if (request.body !== null) {
					'''json'''
			} else {
				'''""'''
			}
		}
	}
	
	def CharSequence createHttpCall(Request request) {
		if (QCUtils.CheckNoRequestID(request.url)) {			
			'''
			let code,content = Http.�request.method.compileMethod� �request.name.urlName� �request.determineParameter� in
			'''
		} else {
			'''
			let id = lookupSutItem ix !sut in
				let code,content = Http.�request.method.compileMethod� (�request.name.urlName�^"/"^id) �request.determineParameter� in
			'''
		}
		
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
		�request.action.compileAction�
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
		val qcRequest = QCRequestProcess.get(currentRequest.name)
		if(condition.requestValue.body !== null){
			'''
			�IF qcRequest.postCondJsonDefs.get(declarationCounter).IdentifierKey.isEmpty�
			let json = lookupItem ix state in
				�condition.requestOp.compileRequestOp� (String.compare (�currentRequest.name.nextJsonDefUse()�) (�condition.requestValue.body.compileExcluder� content) == 0)
			�ELSE�
			let json = lookupItem ix state in
				let json = fromJsonToStr (combine_state_id (fromStrToJson json) "�qcRequest.postCondJsonDefs.get(declarationCounter).IdentifierKey�" id) in
				let combined = �currentRequest.name.nextJsonDefUse()� in
				�condition.requestOp.compileRequestOp� (String.compare (combined) (�condition.requestValue.body.compileExcluder� content) == 0)
			�ENDIF�
			'''
		} else if (condition.requestValue.body === null){
		'''
		let extractedState = lookupItem ix state in
			let id = lookupSutItem ix !sut in
				let stateJson = Yojson.Basic.from_string extractedState in
					let combined = combine_state_id stateJson "" id in
						�condition.requestOp.compileRequestOp� (String.compare (Yojson.Basic.to_string combined) (Yojson.Basic.to_string content) == 0)
		'''
		}
	}
	
	def dispatch CharSequence compileExcluder(Json json){
		'''jsonExcluder � excluder.compileJsonExclusionList(json)�'''
	}
	
	def dispatch CharSequence compileExcluder(JsonDefRef json){
		'''jsonExcluder �excluder.compileJsonExclusionList(json.ref.json)�'''
	}
	
	def CharSequence nextJsonDefUse(String name){
		
		val defName = QCRequestProcess.get(name).postCondJsonDefs.get(declarationCounter).declarationUse
		//next? declarationCounter++ : declarationCounter = declarationCounter
		defName
	}
	
	def CharSequence compileRequestOp(RequestOp op){
		if(op.notOp === null || op.notOp == ""){
			''''''
		} else {
			'''not '''
		}
	}
	
	
	def dispatch CharSequence compileAction(CreateAction action) {
//		 QCJsonIDExtractor.compileJsonID(action.value)
		'''
		let id = extractIdFromContent "�QCRequestProcess.get(currentRequest.name).stateJsonDef.IdentifierKey�" content in
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