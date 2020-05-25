package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Model
import org.xtext.mdsd.external.quickCheckApi.StringData
import org.xtext.mdsd.external.quickCheckApi.IntData
import org.xtext.mdsd.external.quickCheckApi.BooleanData
import org.xtext.mdsd.external.quickCheckApi.UserData

class QCModel {
	
	def CharSequence compileModel(Model model) {
		'''
		type «model.name» = {
			«FOR feature:model.features»
			«feature.name»: «feature.typeData.compileDataType»«IF feature.listof» list«ENDIF»;
			«ENDFOR»
		}
		'''
	}
	
	def dispatch CharSequence compileDataType(StringData data) {
		'''string'''
	}
	def dispatch CharSequence compileDataType(IntData data) {
		'''int'''
	}
	def dispatch CharSequence compileDataType (BooleanData data) {
		'''bool'''
	}
	def dispatch CharSequence compileDataType (UserData data) {
		'''«data.type.name»'''
	}
	
}