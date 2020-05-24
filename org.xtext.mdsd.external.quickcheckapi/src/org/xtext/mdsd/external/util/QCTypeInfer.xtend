package org.xtext.mdsd.external.util

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.Body
import org.xtext.mdsd.external.quickCheckApi.GenRef
import org.xtext.mdsd.external.quickCheckApi.Generator
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.Postproposition
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.util.json.QCJsonPairUtil

import static extension org.eclipse.xtext.EcoreUtil2.*

class QCTypeInfer {

	@Inject extension QCOriginResolver

	enum JsonValueType {
		STRING,
		INT,
		NON_INFERRED
	}

	private static ReuseValue inferKey

	def static JsonValueType inferType(ReuseValue context) {
		inferKey = context
		var origin = QCOriginResolver.JsonOrigin(context)
		origin.references.get(0).infer
	}

	def static private dispatch infer(EObject obj) {
		val pairs = obj.getInferPair
		if (!pairs.empty) {
			val grouped = pairs.groupBy[it.value]
			
			if (grouped.keySet.exists[it instanceof GenRef]) {
				val filtered = grouped.filter[k,v| k instanceof GenRef].keySet
				val generatorReturnType = QCGenUtils.getGeneratorType((filtered.get(0) as GenRef).getGen)
			}
			val stringFound = grouped.keySet.exists[it instanceof StringValue]
			val intFound = grouped.keySet.exists[it instanceof IntValue]
			if (stringFound && intFound) {
				return JsonValueType.STRING
			} else if (stringFound) {
				return JsonValueType.STRING
			} else if (intFound) {
				return JsonValueType.INT
			}
		} else {
			return JsonValueType.NON_INFERRED
		}
	}

	private static def dispatch getInferPair(Action action) {
		var request = action.getContainerOfType(Request)
		val pairs = QCJsonPairUtil.getAllJsonPairs(request?.body?.value)
		pairs.filter[it.key.value === inferKey.key.value]
	}
	
	private static def dispatch getInferPair(Body action) {
		var request = action.getContainerOfType(Request)
		val pairs = QCJsonPairUtil.getAllJsonPairs(request?.body?.value)
		pairs.filter[it.key.value === inferKey.key.value]
	}
	
	private static def dispatch getInferPair(Postproposition action) {
		var request = action.getContainerOfType(Request)
		val pairs = QCJsonPairUtil.getAllJsonPairs(request?.body?.value)
		pairs.filter[it.key.value === inferKey.key.value]
	}
	
	private static def Generator getGen(GenRef ref){
		ref.ref.gen
	}

}
