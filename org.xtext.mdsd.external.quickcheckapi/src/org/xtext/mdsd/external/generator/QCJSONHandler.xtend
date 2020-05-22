package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.util.QCJsonReuse

class QCJSONHandler {
		
	def CharSequence InitJsonVariables(Test test){
		for (request : test.requests) {
			QCRequestProcess.processRequest(request)
		}
		'''
		«initJsonHelper»
		«initDefaultGen»
		«test.customGen»
		«compileJsonVaribles»
		'''
	}
	
	private def CharSequence compileJsonVaribles(){

		QCRequestProcess.compileAllJsonDeclarations()
	}
	private def dispatch CharSequence compileReuseJson(Json json){
		
		'''«IF QCJsonReuse.isReuseJson(json)»tbl«ELSE»()«ENDIF»'''
	}

	
	private def dispatch CharSequence compileReuseJson(JsonDefRef json){
		
		json.ref.json.compileReuseJson
	}
	
	
	
	
	private def CharSequence initJsonHelper(){
		'''
		let fromJsonToStr json = Yojson.Basic.to_string json
		let fromStrToJson str = Yojson.Basic.from_string str
		'''
	}
	
	private def CharSequence initDefaultGen(){
		'''
		let defaultNameGen () = Gen.generate1( Gen.oneof[Gen.return "Jens"; Gen.return "Mads"; Gen.return "Andreas"; Gen.return "John"; Gen.return "Nikolaj";])		
		let defaultStringGen() = Gen.generate1 (Gen.string_size (Gen.int_range 3 4))
		
		«QCRequestProcess.compileAllGenDeclarations»
		'''
	}
	
	private def CharSequence customGen(Test test){
		'''

		'''
	}
	
	
	
	
	

	
}