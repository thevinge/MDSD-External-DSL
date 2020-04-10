package org.xtext.mdsd.external.generator

import org.eclipse.emf.common.util.EList
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Method
import java.util.List
import java.util.ArrayList
import org.xtext.mdsd.external.quickCheckApi.POST
import org.xtext.mdsd.external.quickCheckApi.Preproposition

class QCUtils {
	

	
	def static List<Request> filterbyMethod(EList<Request> requests, Class<? extends Method> method){
		val filtered = new ArrayList
		for (request : requests) {
			if (method.isAssignableFrom(request.method.class)) {
				filtered.add(request)
			}
		}
		filtered
	}
	
	def static toUpperCaseFunction(String s) {
		 s.substring(0,1).toUpperCase + s.substring(1)
	}
	
	
	def static hasNotEmptyPreCondition(Request request){
		
	}
	
	private def dispatch CharSequence name(Preproposition proposition) {
		
	}
}