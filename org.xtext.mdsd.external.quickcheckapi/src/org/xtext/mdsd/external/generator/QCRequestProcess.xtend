package org.xtext.mdsd.external.generator

import java.util.HashMap
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Test

class QCRequestProcess {
	
	static HashMap<String,QCRequest> processedRequests;
	
	def static void init(){
		processedRequests = new HashMap
	}
	
	def static processRequest(Request request){
		var QCRequest qc = new QCRequest
		qc.processRequest(request)
		processedRequests.put(request.name, qc)
	}
	
	def static QCRequest get(String requestName){
		processedRequests.get(requestName)
	}
	
	def static CharSequence compileAllJsonDeclarations(){
		'''
		«FOR request : processedRequests.values»
			«request.bodyJsonDef?.declaration»
			«request.stateJsonDef?.declaration»
			«FOR jsonDef : request.postCondJsonDefs»
				«jsonDef.declaration»
			«ENDFOR»
		«ENDFOR»
		'''
	}
	
	def static CharSequence compileAllGenDeclarations(){
		val HashMap<String,String> gens = new HashMap
		for (request : processedRequests.values) {
			
			addGens(gens,request.bodyJsonDef)
			addGens(gens,request.stateJsonDef)
			for (jsonDef : request.postCondJsonDefs) {
				addGens(gens,jsonDef)
			}			
		}
		
		'''
		«FOR gen : gens.entrySet»
			let «gen.key»() =«gen.value»
		«ENDFOR»
		'''
	}
	
	private static def addGens(HashMap<String,String> gens, QCJsonDef jsonDef){
		if(jsonDef !== null){
			gens.putAll(jsonDef.generators)
		}
	}
}