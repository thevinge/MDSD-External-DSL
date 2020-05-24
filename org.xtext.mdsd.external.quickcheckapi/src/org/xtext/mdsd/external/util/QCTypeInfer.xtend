package org.xtext.mdsd.external.util

import com.google.inject.Inject
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.UpdateAction
import org.xtext.mdsd.external.util.json.QCJsonPairUtil

import static extension org.eclipse.xtext.EcoreUtil2.*

class QCTypeInfer {

	@Inject extension QCOriginResolver
	
	enum JsonValueType{
		STRING,
		INT,
		NON_INFERRED
	}

	private ReuseValue inferKey
	def inferType(ReuseValue context) {
		inferKey = context
		var origin = context.JsonOrigin
		switch (origin.origin) {
			case NON_REFERRED: {
				var test = context.getContainerOfType(Test)
				
			}
			case ACTION: {
				if (!origin.references.empty) {
					val action = origin.references.get(0) as Action
					action.infer
				} 
			}
			case BODY_CONDITION: {
				if (!origin.references.empty) {
					var test = origin.references.get(0).getContainerOfType(Test)
					
				}

			}
			case BODY: {
				if (!origin.references.empty) {
					var test = origin.references.get(0).getContainerOfType(Test)
					
				}
			}
			default: {
			}
		}
	}
	
	def private dispatch infer(CreateAction action) {
		val pairs = action.inferPair
		if (pairs.size > 0) {
			val grouped = pairs.groupBy[it.value]
			val stringFound = grouped.keySet.exists[it instanceof StringValue]
			val intFound = grouped.keySet.exists[it instanceof IntValue]
			if (stringFound && intFound) {
				return JsonValueType.STRING
			} else if (stringFound) {
				return JsonValueType.STRING
			} else if (intFound){
				return JsonValueType.INT
			}
		} else {
			return JsonValueType.NON_INFERRED
		}
	}

	def private dispatch  infer(UpdateAction action) {
		var request = action.getContainerOfType(Request)
		var test = request.getContainerOfType(Test)
		
	}
	
	def private dispatch  infer(DeleteAction action) {
		var request = action.getContainerOfType(Request)
		var test = request.getContainerOfType(Test)
		
	}
	
	private def getInferPair(Action action){
		var request = action.getContainerOfType(Request)
		val pairs = QCJsonPairUtil.getAllJsonPairs(request?.body?.value)
		pairs.filter[it.key.value === inferKey.key.value && (it instanceof StringValue || it instanceof IntValue)]
	}
	
}
