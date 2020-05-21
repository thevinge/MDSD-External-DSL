/*
 * generated by Xtext 2.20.0
 */
package org.xtext.mdsd.external.scoping

import java.util.ArrayList
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.xtext.mdsd.external.generator.QCJsonOrigin
import org.xtext.mdsd.external.generator.QCJsonUtils
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.BodyCondition
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.JsonKey
import org.xtext.mdsd.external.quickCheckApi.JsonRef
import org.xtext.mdsd.external.quickCheckApi.QuickCheckApiPackage
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.UpdateAction

import static extension org.eclipse.xtext.EcoreUtil2.*

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class QuickCheckApiScopeProvider extends AbstractQuickCheckApiScopeProvider {

	override getScope(EObject context, EReference reference) {
		switch reference {
			case QuickCheckApiPackage.Literals.REUSE_VALUE__KEY:
				context.reuseScope
			default:
				super.getScope(context, reference)
		}
	}

	def private IScope getReuseScope(EObject context) {

		switch (context.JsonOrigin) {
			case NON_REFERRED: {
				var test = context.getContainerOfType(Test)
				Scopes.scopeFor(test.allJsonKeys, QualifiedName.wrapper[name], IScope.NULLSCOPE)
			}
			case ACTION: {
				var currentAction = context.getContainerOfType(Action)
				switch (currentAction) {
					case currentAction instanceof CreateAction:
						return (currentAction as CreateAction).actionScope
					case currentAction instanceof UpdateAction:
						return (currentAction as UpdateAction).actionScope
					case currentAction instanceof DeleteAction:
						return (currentAction as DeleteAction).actionScope
					default:
						return IScope.NULLSCOPE
				}

			}
			case BODY_CONDITION: {
				var test = context.getContainerOfType(Test)
				Scopes.scopeFor(test.allJsonKeys, QualifiedName.wrapper[name], IScope.NULLSCOPE)
			}
			default: {
				return IScope.NULLSCOPE
			}
		}

	}

	def private dispatch IScope getActionScope(CreateAction action) {
		var request = action.getContainerOfType(Request)
		Scopes.scopeFor(request?.body?.value.getJsonKeys, QualifiedName.wrapper[name], IScope.NULLSCOPE)
	}

	def private dispatch IScope getActionScope(UpdateAction action) {
		var request = action.getContainerOfType(Request)
		var test = request.getContainerOfType(Test)
		Scopes.scopeFor(test.allJsonKeys, QualifiedName.wrapper[name], IScope.NULLSCOPE)
	}
	
	def private dispatch IScope getActionScope(DeleteAction action) {
		var request = action.getContainerOfType(Request)
		var test = request.getContainerOfType(Test)
		Scopes.scopeFor(test.allJsonKeys, QualifiedName.wrapper[name], IScope.NULLSCOPE)
	}

	private def Iterable<JsonKey> getJsonKeys(JsonRef json) {
		var ArrayList<JsonKey> list = new ArrayList
		if (json === null) {
			return list
		}
		QCJsonUtils.getAllJsonPairs(json).map[it.key]
	}

	private def static String name(JsonKey key) {
		key.value
	}

	private def ArrayList<JsonKey> allJsonKeys(Test test) {
		val ArrayList<JsonKey> allKeys = new ArrayList
		test.requests.forEach [
			{
				if (it.body?.value !== null) {
					allKeys.addAll(it.body.value.jsonKeys)
				}

				if (it.action instanceof UpdateAction) {
					allKeys.addAll((it.action as UpdateAction).value.jsonKeys)
				}
			}
		]
		allKeys
	}

	private def QCJsonOrigin JsonOrigin(EObject context) {
		if (context.getContainerOfType(Request) === null) {
			return QCJsonOrigin.NON_REFERRED
		} else {
			if (context.getContainerOfType(Action) !== null) {
				return QCJsonOrigin.ACTION
			} else if (context.getContainerOfType(BodyCondition) !== null) {
				return QCJsonOrigin.BODY_CONDITION
			}
		}
	}
}
