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
	
	def static dispatch CharSequence compileJson(JsonObject json){
		'''{«FOR pair : json.jsonPairs SEPARATOR ","»«pair.compileJson»«ENDFOR»}'''
	}
	def static dispatch CharSequence compileJson(JsonList json){
		'''[«FOR pair : json.jsonPairs SEPARATOR ","»«pair.compileJson»«ENDFOR»]'''
	}
	def static dispatch CharSequence compileJson(JsonPair json){
		'''\"«json.key»\":«json.value.compileJson»'''
	}
	def static dispatch CharSequence compileJson(IntValue json){
		'''«json.value»'''
	}
	def static dispatch CharSequence compileJson(StringValue json){
		'''\"«json.value»\"'''
	}
	def static dispatch CharSequence compileJson(NestedJsonValue json){
		'''«json.value.compileJson»'''
	}
	def static dispatch CharSequence compileJson(ListJsonValue json){
		'''«json.value.compileJson»'''
	}
	
	
	
	
	
}