package org.xtext.mdsd.external.util

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.Body
import org.xtext.mdsd.external.quickCheckApi.BodyCondition
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.JsonDefinition
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.UpdateAction

import static extension org.eclipse.xtext.EcoreUtil2.*
import org.eclipse.xtext.EcoreUtil2

class QCOrigin {

	enum QCJsonOrigin {
		NON_REFERRED,
		ACTION,
		BODY_CONDITION,
		BODY
	}

	def QCJsonOrigin JsonOrigin(EObject context) {

		if (context.getContainerOfType(Request) === null) {
			// JSON Definition is declared as var.
//			val test = context.getContainerOfType(Test)
//			val jsonDef = context.getContainerOfType(JsonDefinition)
//			test.requests.filter[it.body?.value === jsonDef || it.action.jsonDef === jsonDef]
//			val a = EcoreUtil2.getAllContentsOfType(jsonDef, Test)
//			
			
			// Never referred to declaration
			return QCJsonOrigin.NON_REFERRED
		} else {
			// JSON Definition is declared inline.
			if (context.getContainerOfType(Action) !== null) {
				return QCJsonOrigin.ACTION
			} else if (context.getContainerOfType(BodyCondition) !== null) {
				return QCJsonOrigin.BODY_CONDITION
			} else if (context.getContainerOfType(Body) !== null) {
				return QCJsonOrigin.BODY
			}
		}
	}
	
	
	private def dispatch jsonDef(CreateAction action){
		action.value
	}
	
	private def dispatch jsonDef(DeleteAction action){
		action.value
	}
	
	private def dispatch jsonDef(UpdateAction action){
		action.value
	}
}
