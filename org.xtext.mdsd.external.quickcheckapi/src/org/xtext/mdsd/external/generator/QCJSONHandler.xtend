package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef

class QCJSONHandler {
	
	
	def CharSequence InitJsonVariables(Test test){
		
		'''
		«initJsonHelper»
		«initDefaultGen»
		«test.customGen»
		«test.compileJsonVaribles»
		'''
	}
	
	private def CharSequence compileJsonVaribles(Test test){
		'''
		«FOR defi : QCUtils.filterbyJsonDefinition(test.definitions)»
		let «QCUtils.firstCharLowerCase(defi.name)»JsonDef () = fromJsonToStr («QCJsonHelper.compileJson(defi.json)»)
		«ENDFOR»
		«FOR request : test.requests»
			«IF request.action.value !== null»
				«var json = request.action.value.compileJson»
				«IF json.length > 0»
					let «QCUtils.firstCharLowerCase(request.name)»LocalStateJsonDef () = fromJsonToStr («json»)
				«ENDIF»
			«ENDIF»
			«IF request.body !== null»
				«var json = request.body.value.compileJson»
				«IF json.length > 0»
					let «QCUtils.firstCharLowerCase(request.name)»LocalBodyJsonDef () = fromJsonToStr («json»)
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
		'''
	}
	
	
	private def CharSequence initJsonHelper(){
		'''
		let fromJsonToStr json = Yojson.Basic.to_string json
		'''
	}
	
	private def CharSequence initDefaultGen(){
		'''
		let defaultNameGen () = Gen.generate1( Gen.oneof[Gen.return "Jens"; Gen.return "Mads"; Gen.return "Andreas"; Gen.return "John"; Gen.return "Nikolaj";])		
		'''
	}
	
	private def CharSequence customGen(Test test){
		'''

		'''
	}
	
	private def dispatch CharSequence compileJson(Json json){
		'''«QCJsonHelper.compileJson(json)»'''
		
	}
	private def dispatch CharSequence compileJson(JsonDefRef json){
		''''''
	}
	

	
}