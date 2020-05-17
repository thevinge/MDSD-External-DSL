package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.PostConjunction
import org.xtext.mdsd.external.quickCheckApi.PostDisjunction
import org.xtext.mdsd.external.quickCheckApi.CodeCondition
import org.xtext.mdsd.external.quickCheckApi.BodyCondition
import java.util.ArrayList
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.UpdateAction
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.NoAction
import javax.inject.Inject
import org.xtext.mdsd.external.quickCheckApi.JsonRef

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
		for (request : test.requests) {
		
			QCRequestProcess.processRequest(request)
		}
		'''
«««		«FOR defi : QCUtils.filterbyJsonDefinition(test.definitions)»
«««		let «QCNames.JsonDefName(defi.name)» «defi.json.compileReuseJson» = fromJsonToStr («QCJsonHelper.compileJson(defi.json)»)
«««		«ENDFOR»
«««		«FOR request : test.requests»
«««			«request.action.compileAction(request)»
«««			«IF request.body !== null»
«««				«var json = request.body.value.compileJson»
«««				«IF json.length > 0»
«««					let «QCNames.LocalBodyJsonDef(request.name)» «request.body.value.compileReuseJson» = fromJsonToStr («json»)
«««				«ENDIF»
«««			«ENDIF»
«««		«ENDFOR»	
		«FOR request : test.requests»
			«QCRequestProcess.get(request.name).bodyJsonDef?.declaration»
			«QCRequestProcess.get(request.name).stateJsonDef?.declaration»
			«FOR jsonDef : QCRequestProcess.get(request.name).postCondJsonDefs»
				«jsonDef.declaration»
			«ENDFOR»
		«ENDFOR»
		'''
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
		'''
	}
	
	private def CharSequence customGen(Test test){
		'''

		'''
	}
	
	
	
	
	

	
}