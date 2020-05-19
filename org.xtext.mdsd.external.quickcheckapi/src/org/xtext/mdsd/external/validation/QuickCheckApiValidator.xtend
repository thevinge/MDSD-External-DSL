/*
 * generated by Xtext 2.20.0
 */
package org.xtext.mdsd.external.validation

import org.eclipse.xtext.validation.Check
import org.xtext.mdsd.external.generator.QCConditionUtils
import org.xtext.mdsd.external.generator.QCJsonUtils
import org.xtext.mdsd.external.generator.QCUtils
import org.xtext.mdsd.external.quickCheckApi.BodyCondition
import org.xtext.mdsd.external.quickCheckApi.Builder
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.EmptyCondition
import org.xtext.mdsd.external.quickCheckApi.IdentifierValue
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.QuickCheckApiPackage
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.URLRef
import org.xtext.mdsd.external.quickCheckApi.UpdateAction

import static extension org.eclipse.xtext.EcoreUtil2.*

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class QuickCheckApiValidator extends AbstractQuickCheckApiValidator {
	
	@Check
	def checkDuplicateTestname(Builder builder){
		val duplicates = builder.tests.groupBy[it.name].filter[k,v| v.size >= 2]
		 if (duplicates.size > 0){
		 	duplicates.forEach[k, v|v.forEach[error("Test name duplicate",it, QuickCheckApiPackage.Literals.TEST__NAME)]]
		 	
		 }
	}
	
	@Check
	def checkDuplicateDefinitions(Test test){
		val duplicates = test.definitions.groupBy[it.name].filter[k,v| v.size >= 2]
		if (duplicates.size > 0){
		 	duplicates.forEach[k, v|v.forEach[error("Definition name duplicate",it, QuickCheckApiPackage.Literals.VAR_DEFINITION__NAME)]]
		 }
	}
	
	
	@Check
	def checkPostCondition(BodyCondition condition){
		if (condition.requestValue.body !== null){
			if(QCJsonUtils.jsonContainsType(condition.requestValue.body,IdentifierValue)){
				val request = condition.getContainerOfType(Request)
				if(request.preconditions !== null){
					if (QCConditionUtils.preconditionContainsType(request.preconditions, false, EmptyCondition)){
						error("Identifier not allowed with current precondition 'Empty'", condition, QuickCheckApiPackage.eINSTANCE.bodyCondition_RequestValue)
					}
				}
			}
		}
	}	
	
	
	@Check
	def checkURL(URLRef url){
		if(!QCUtils.CheckNoRequestID(url)){
			val request = url.getContainerOfType(Request)
			if(request !== null){
				if (QCConditionUtils.preconditionContainsType(request.preconditions, false, EmptyCondition)){
					error("@Id not allowed with current precondition 'Empty'", url, QuickCheckApiPackage.eINSTANCE.URLRef_RequestID)
				}
			}
		}
		
	}	
	
	
	@Check
	def checkMultipleIdentifiers(JsonObject json){
		val filtered = QCJsonUtils.jsonAllOfType(json, IdentifierValue)
		if(filtered.filter[k,v| v.size > 1].size > 1 || filtered.size > 1){
			filtered.forEach[k,v| v.forEach[error("Only one identifier allowed", it, QuickCheckApiPackage.Literals.CUSTOM_VALUE__VALUE)]]
		}
	}
	
	
	@Check
	def checkForJsonList(JsonList json){
		error("Current Implementation of the DSL does not handle Json List due to limitation in OCaml", json, QuickCheckApiPackage.eINSTANCE.jsonList_JsonValues)
	}
	
	
	@Check
	def checkIfReuseAllowed(CreateAction action){
		val reuseJson = QCJsonUtils.jsonAllOfType(action.value, ReuseValue)
		if (reuseJson.size > 0) {
			val request = action.getContainerOfType(Request)
			val allKeys = QCJsonUtils.jsonAllOfType(request?.body?.value)
			reuseJson.filter[jsonKey, jsonObjs| jsonObjs.map[(it as ReuseValue).name].filter[!allKeys.containsKey(it)].size > 0]
			.forEach[jsonKey, json|json.forEach[{
				error('''Reuse is not allowed, when Body does not contain the key {�(it as ReuseValue).name�}''',
					it, QuickCheckApiPackage.eINSTANCE.reuseValue_Name
				)
			}]]
		}		
	}
	
	@Check
	def checkIfReuseAllowed(UpdateAction action){
		val reuseJson = QCJsonUtils.jsonAllOfType(action.value, ReuseValue)
		if (reuseJson.size > 0) {
			val test = action.getContainerOfType(Test)
			val allCreateActions = test.getAllContentsOfType(CreateAction)
			reuseJson.filter[jsonKey, jsonObjs| jsonObjs.map[(it as ReuseValue).name].filter[ reuseKey | allCreateActions.exists[{
				val CreateJsonKeys = QCJsonUtils.jsonAllOfType(it.value)
				!CreateJsonKeys.containsKey(reuseKey)
			}]].size > 0]
			.forEach[jsonKey, json|json.forEach[{
				error('''Reuse is not allowed, when no requests in test {�test.name�} creates a key {�(it as ReuseValue).name�}''',
					it, QuickCheckApiPackage.eINSTANCE.reuseValue_Name
				)
			}]]
		}		
	}
}
