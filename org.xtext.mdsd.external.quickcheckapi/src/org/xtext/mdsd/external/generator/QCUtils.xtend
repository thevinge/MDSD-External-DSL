package org.xtext.mdsd.external.generator

import org.eclipse.emf.common.util.EList
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Method
import java.util.List
import java.util.ArrayList

class QCUtils {
	

	
	def List<Request> filterbyMethod(EList<Request> requests, Class<? extends Method> method){
		val filtered = new ArrayList
		for (request : requests) {
			if (request.method.class == method.class) {
				filtered.add(request)
			}
		}
		filtered
	}
	
	def static toUpperCaseFunction(String s) {
		 s.substring(0,1).toUpperCase + s.substring(1)
	}
}