package org.xtext.mdsd.external.generator

import java.util.HashMap
import org.xtext.mdsd.external.quickCheckApi.Request

class QCRequestProcess {
	
	private static HashMap<String,QCRequest> processedRequests;
	
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
}