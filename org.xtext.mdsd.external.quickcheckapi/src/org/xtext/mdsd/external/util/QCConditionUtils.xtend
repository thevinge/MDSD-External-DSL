package org.xtext.mdsd.external.util

import org.xtext.mdsd.external.quickCheckApi.ContainsCondition
import org.xtext.mdsd.external.quickCheckApi.EmptyCondition
import org.xtext.mdsd.external.quickCheckApi.PreConjunction
import org.xtext.mdsd.external.quickCheckApi.PreDisjunction
import org.xtext.mdsd.external.quickCheckApi.Preproposition

class QCConditionUtils {
	
	def static dispatch boolean preconditionContainsType(PreDisjunction proposition, boolean notOp, Class<? extends Preproposition> cls) {
		proposition?.left?.preconditionContainsType(notOp, cls) || proposition?.right?.preconditionContainsType(notOp, cls)
	}
	
	def static dispatch boolean preconditionContainsType(PreConjunction proposition, boolean notOp, Class<? extends Preproposition> cls) {
		proposition?.left?.preconditionContainsType(notOp, cls) || proposition?.right?.preconditionContainsType(notOp, cls)
	}
	
	def static dispatch boolean preconditionContainsType(ContainsCondition condition, boolean notOp, Class<? extends Preproposition> cls){
		if(cls.isAssignableFrom(condition?.class)){
			if(condition?.notOp === null){
				return ((notOp ? "not" :"") === "")
			} else {
				return ((notOp ? "not" :"") === "not")
			}
		}
		false
	}
	def static dispatch boolean preconditionContainsType(EmptyCondition condition, boolean notOp, Class<? extends Preproposition> cls){
		if(cls.isAssignableFrom(condition?.class)){
			if(condition?.notOp === null){
				return ((notOp ? "not" :"") === "")
			} else {
				return ((notOp ? "not" :"") === "not")
			}
		}
		false
	}
}
