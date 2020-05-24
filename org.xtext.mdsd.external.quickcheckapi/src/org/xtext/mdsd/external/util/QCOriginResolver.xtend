package org.xtext.mdsd.external.util

import com.google.common.collect.Lists
import com.google.inject.Inject
import java.util.ArrayList
import org.eclipse.emf.ecore.EObject
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.Body
import org.xtext.mdsd.external.quickCheckApi.Postproposition
import org.xtext.mdsd.external.quickCheckApi.Request

import static extension org.eclipse.xtext.EcoreUtil2.*

class QCOriginResolver {

	@Inject extension QCRefResolver

	enum QCJsonOrigin {
		NON_REFERRED,
		ACTION,
		BODY_CONDITION,
		BODY
	}

	def QCOrigin JsonOrigin(EObject context) {
		var ArrayList<EObject> refs
		if (context.getContainerOfType(Request) === null) {
			// JSON Definition is declared as variable, and the problem is to find the reference to said JSON definition.	
			refs = context.getReferencesToMe(true)
		} else {
			// JSON Definition is declared inline.
			refs = context.getReferencesToMe(false)
		}

		if (!refs.empty) {
			val actionRef = refs.exists[it instanceof Action]
			val bodyRef = refs.exists[it instanceof Body]
			val bodyConditionRef = refs.exists[it instanceof Postproposition]
			if (actionRef && bodyRef) {
				return new QCOrigin(QCJsonOrigin.ACTION, refs)
			} else if (actionRef) {
				return new QCOrigin(QCJsonOrigin.ACTION, Lists.newArrayList(refs.filter[it instanceof Action]))
			} else if (bodyRef) {
				return new QCOrigin(QCJsonOrigin.BODY, Lists.newArrayList(refs.filter[it instanceof Body]))
			} else if (bodyConditionRef) {
				return new QCOrigin(QCJsonOrigin.BODY_CONDITION, Lists.newArrayList(refs.filter [
					it instanceof Postproposition
				]))
			}
			return new QCOrigin(QCJsonOrigin.NON_REFERRED, refs)
		} else {
			// Never referred to declaration
			return new QCOrigin(QCJsonOrigin.NON_REFERRED, refs)
		}
	}

//	def QCOrigin JsonOrigin(EObject context) {
//		if (context.getContainerOfType(Request) === null) {
//			// JSON Definition is declared as variable, and the problem is to find the reference to said JSON definition.	
//			val refs = context.getReferencesToMe(true)	
//			if (!refs.empty) {
//				val actionRef = refs.exists[it instanceof Action]
//				val bodyRef = refs.exists[it instanceof Body]
//				if (actionRef && bodyRef) {
//					return new QCOrigin(QCJsonOrigin.ACTION, refs)
//				} else if (actionRef) {				
//					return new QCOrigin(QCJsonOrigin.ACTION, Lists.newArrayList(refs.filter[it instanceof Action]) )
//				} else if (bodyRef) {
//					return new QCOrigin(QCJsonOrigin.BODY, Lists.newArrayList(refs.filter[it instanceof Body]) )
//				}
//				return new QCOrigin(QCJsonOrigin.NON_REFERRED, refs)
//			} else {
//				// Never referred to declaration
//				return new QCOrigin(QCJsonOrigin.NON_REFERRED, refs)
//			}
//		} else {
//			// JSON Definition is declared inline.
//			if (context.getContainerOfType(Action) !== null) {
//				val refs = context.getReferencesToMe(false)
//				return new QCOrigin(QCJsonOrigin.ACTION, new ArrayList)
//			} else if (context.getContainerOfType(BodyCondition) !== null) {
//				return new QCOrigin(QCJsonOrigin.BODY_CONDITION, new ArrayList)
//			} else if (context.getContainerOfType(Body) !== null) {
//				return new QCOrigin(QCJsonOrigin.BODY, new ArrayList)
//			}
//		}
//	}
//	
}
