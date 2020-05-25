package org.xtext.mdsd.external.util

import com.google.common.collect.Lists
import java.util.ArrayList
import org.eclipse.emf.ecore.EObject
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.Body
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.CustomValue
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.GenRef
import org.xtext.mdsd.external.quickCheckApi.Generator
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.JsonRef
import org.xtext.mdsd.external.quickCheckApi.NoAction
import org.xtext.mdsd.external.quickCheckApi.Postproposition
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.UpdateAction
import org.xtext.mdsd.external.util.json.QCJsonPairUtil

import static extension org.eclipse.xtext.EcoreUtil2.*

class QCTypeInfer {

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
			var stringFound = false
			var intFound = false
			val customValues = grouped.filter[k,v| k instanceof CustomValue]
			val filtered = customValues.filter[k, v|(k as CustomValue).value instanceof GenRef].keySet
			if (!filtered.empty) {
				val generatorReturnType = QCGenUtils.getGeneratorType(((filtered.get(0) as CustomValue).value as GenRef).getGen)
				switch (generatorReturnType) {
					case Text: {
						stringFound = true
					}
					case Int: {
						intFound = true
					}
					case Mixed: {
						intFound = true
						stringFound = true
					}
					default: {
						stringFound = true
					}
				}
			}
			stringFound?  stringFound = stringFound :  stringFound= grouped.keySet.exists[it instanceof StringValue]
			intFound?  intFound = intFound :  intFound = grouped.keySet.exists[it instanceof IntValue]
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
		action.checkAction
	}

	private static def getPairs(JsonRef json) {
		val pairs = QCJsonPairUtil.getAllJsonPairs(json).filter[ it.key.value.equals(inferKey.key.value)]
		val newList = Lists.newArrayList(pairs)
		newList
	}

	private static def dispatch checkAction(CreateAction action) {
		var request = action.getContainerOfType(Request)
		val pairs = request?.body?.value.pairs
		pairs
	}

	private static def dispatch checkAction(UpdateAction action) {
		var test = action.getContainerOfType(Test)
		val pairs = test.allPairs
		pairs
	}
	
	private def static ArrayList<JsonPair> getAllPairs(Test test) {
		val ArrayList<JsonPair> pairs = new ArrayList
		for (request : test.requests) {
			pairs.addAll(request.body?.value.pairs)
		
				if (request.action instanceof UpdateAction) {
					pairs.addAll((request.action as UpdateAction).value.pairs)
				}
		
				if (request.action instanceof CreateAction) {
					pairs.addAll((request.action as CreateAction).value.pairs)
				}
		}
	
		pairs.size
		pairs
	}

	private static def dispatch checkAction(DeleteAction action) {
		var test = action.getContainerOfType(Test)
		test.allPairs
	}

	private static def dispatch checkAction(NoAction action) {
		new ArrayList
	}

	private static def dispatch getInferPair(Body action) {
		new ArrayList
	}

	private static def dispatch getInferPair(Postproposition action) {
		var test = action.getContainerOfType(Test)
		test.allPairs
	}

	private static def Generator getGen(GenRef ref) {
		ref.ref.gen
	}

}
