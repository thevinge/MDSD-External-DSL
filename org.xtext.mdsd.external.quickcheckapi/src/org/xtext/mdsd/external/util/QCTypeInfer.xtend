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
		var origin = inferKey.JsonOrigin
		switch (origin.origin) {
			case NON_REFERRED: {
			}
			case ACTION: {
				var currentAction = inferKey.getContainerOfType(Action)
				currentAction.infer

			}
			case BODY_CONDITION: {
			}
			default: {
			}
		}
	}
	
	def private dispatch infer(CreateAction action) {
//		val pairs = action.inferPair
//		if (pairs.size > 0) {
//			pairs.groupBy[it.value.]
//		} else {
//			return JsonValueType.NON_INFERRED
//		}
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
