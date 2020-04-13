package org.xtext.mdsd.external.generator

import org.eclipse.emf.common.util.EList
import org.xtext.mdsd.external.quickCheckApi.Method
import java.util.List
import java.util.ArrayList

import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.Request

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
	
	def static firstCharLowerCase(String s) {
		 s.substring(0,1).toLowerCase + s.substring(1)
	}
	
	def static boolean requireIndex(Request request){
		// If anything else than a CreateAction then True
		 (CreateAction.isAssignableFrom(request.action.actionOp.class) == false)
	}
	
	def static List<Request> filterRequireIndex(EList<Request> requests){
		requests.filterIndex(true)
	}
	
	def static List<Request> filterRequireNoIndex(EList<Request> requests){
		requests.filterIndex(false)
	}
	
	def static List<Request> filterIndex(EList<Request> requests, boolean require){
		val filtered = new ArrayList
		for (request : requests) {
			if (request.requireIndex == require) {
				filtered.add(request)
			}
		}
		filtered
	}
}