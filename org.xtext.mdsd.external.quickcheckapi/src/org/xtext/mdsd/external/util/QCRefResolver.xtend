package org.xtext.mdsd.external.util

import java.util.ArrayList
import org.eclipse.emf.ecore.EObject
import org.xtext.mdsd.external.quickCheckApi.Body
import org.xtext.mdsd.external.quickCheckApi.BodyCondition
import org.xtext.mdsd.external.quickCheckApi.CodeCondition
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.JsonRef
import org.xtext.mdsd.external.quickCheckApi.NoAction
import org.xtext.mdsd.external.quickCheckApi.PostConjunction
import org.xtext.mdsd.external.quickCheckApi.PostDisjunction
import org.xtext.mdsd.external.quickCheckApi.Postproposition
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.UpdateAction

import static extension org.eclipse.emf.ecore.util.EcoreUtil.*
import static extension org.eclipse.xtext.EcoreUtil2.*

class QCRefResolver {

	private static ArrayList<EObject> references

	def static ArrayList<EObject> getReferencesToMe(EObject context, boolean resolve) {

		val jsonRef = context.resolveJsonRef
		references = new ArrayList
		val test = jsonRef.getContainerOfType(Test)
		for (request : test.requests) {
			if (resolve) {
				request.resolveAll
			}
			if (request.action?.actionResolver === jsonRef) {
				references.add(request.action)
			}
			if (request.body?.bodyResolver === jsonRef) {
				references.add(request.body)
			}
			val bodyConditions = request.postconditions.bodyConditionResolver
			if (bodyConditions.exists[it.ConditionJsonRefResolver === jsonRef]) {
				references.add(request.postconditions)
			}
		}
		references
	}

	private static def JsonRef resolveJsonRef(EObject context) {
		var jsonDef = context.getContainerOfType(JsonDefRef)
		if (jsonDef !== null) {
			return jsonDef
		} else {
			var json = context
			var next = true
			while (next) {
				if (json.eContainer instanceof Json) {
					json = json.eContainer
				} else {
					next = false
				}
			}
			return json as Json
		}
	}

	private static def JsonRef bodyResolver(Body body) {
		if (body.value !== null) {
			return body.value
		} else {
			null
		}
	}

	private static def dispatch JsonRef actionResolver(CreateAction action) {
		if (action?.value instanceof JsonDefRef) {
			(action.value as JsonDefRef).ref.json
		} else {
			action?.value
		}

	}

	private static def dispatch JsonRef actionResolver(DeleteAction action) {
		if (action?.value instanceof JsonDefRef) {
			(action.value as JsonDefRef).ref.json
		} else {
			action?.value
		}
	}

	private static def dispatch JsonRef actionResolver(UpdateAction action) {
		if (action?.value instanceof JsonDefRef) {
			(action.value as JsonDefRef).ref.json
		} else {
			action?.value
		}
	}

	private static def dispatch JsonRef actionResolver(NoAction action) {
		null
	}
	
	private static def JsonRef ConditionJsonRefResolver(JsonRef json) {
		if (json instanceof JsonDefRef) {
			(json as JsonDefRef).ref.json
		} else {
			json
		}
	}
	

	private static ArrayList<JsonRef> jsonBodies

	private def static ArrayList<JsonRef> bodyConditionResolver(Postproposition cond) {
		jsonBodies = new ArrayList
		cond.resolvePostCondition
		jsonBodies
	}

	private static def dispatch void resolvePostCondition(PostConjunction and) {
		and.left?.resolvePostCondition
		and.right?.resolvePostCondition
	}

	private static def dispatch void resolvePostCondition(PostDisjunction or) {
		or.left?.resolvePostCondition
		or.right?.resolvePostCondition
	}

	private static def dispatch void resolvePostCondition(BodyCondition condition) {
		if (condition.requestValue.body !== null) {
			jsonBodies.add(condition.requestValue.body)
		}
	}

	private static def dispatch void resolvePostCondition(CodeCondition condition) {}
}
