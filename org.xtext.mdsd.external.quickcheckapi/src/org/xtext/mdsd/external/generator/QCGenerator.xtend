package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Model
import org.xtext.mdsd.external.quickCheckApi.StringData
import org.xtext.mdsd.external.quickCheckApi.IntData
import org.xtext.mdsd.external.quickCheckApi.BooleanData
import org.xtext.mdsd.external.quickCheckApi.UserData

class QCGenerator {
	
	def CharSequence compile(Model model) {
		'''
		let «QCUtils.firstCharLowerCase(model.name)»_generator = Gen.map (fun () -> {«FOR feature: model.features SEPARATOR ";"»
														«IF !(feature.typeData instanceof UserData)»
														«feature.name» = Gen.generate1 Gen.«feature.typeData.compileDataType»
														«ELSE»
															«IF feature.limit !== null»
															«feature.name» = Gen.generate1 (Gen.list_size (Gen.return «feature.limit.value») «feature.typeData.compileDataType»_generator)
															«ELSE»
															«feature.name» = Gen.generate1 (Gen.list_size (Gen.return 5) «feature.typeData.compileDataType»_generator)
															«ENDIF»
														«ENDIF»
		«ENDFOR»
		}) Gen.unit;;
		'''
	}
	
	def dispatch CharSequence compileDataType(StringData s) {
		'''string'''
	} 
	
	def dispatch CharSequence compileDataType(IntData i) {
		'''int'''
	} 
	
	def dispatch CharSequence compileDataType(BooleanData b) {
		'''bool'''
	} 
	
	def dispatch CharSequence compileDataType(UserData u) {
		u.type.name
	} 
}
