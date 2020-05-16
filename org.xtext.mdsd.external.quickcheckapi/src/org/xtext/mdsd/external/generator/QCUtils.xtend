package org.xtext.mdsd.external.generator

import org.eclipse.emf.common.util.EList
import org.xtext.mdsd.external.quickCheckApi.Method
import java.util.List
import java.util.ArrayList

import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.VarDefinition
import org.xtext.mdsd.external.quickCheckApi.JsonDefinition

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
	
	def static List<JsonDefinition> filterbyJsonDefinition(EList<VarDefinition> definitions){
		val filtered = new ArrayList
		for (definition : definitions) {
			if (JsonDefinition.isAssignableFrom(definition.class)) {
				filtered.add(definition as JsonDefinition)
			}
		}
		filtered
	}
	
	def static firstCharToUpperCase(String s) {
		 s.substring(0,1).toUpperCase + s.substring(1)
	}
	
	def static firstCharLowerCase(String s) {
		 s.substring(0,1).toLowerCase + s.substring(1)
	}
	
	def static boolean requireIndex(Request request){
		// If anything else than a CreateAction then True
		if(request.url.requestID === null)
			false
		else if (CreateAction.isAssignableFrom(request.action.class))
			false
		else
			true
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