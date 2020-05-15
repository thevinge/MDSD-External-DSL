package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.PostConjunction
import org.xtext.mdsd.external.quickCheckApi.PostDisjunction
import org.xtext.mdsd.external.quickCheckApi.CodeCondition
import org.xtext.mdsd.external.quickCheckApi.BodyCondition
import java.util.ArrayList

class QCJSONHandler {
	
	private ArrayList<String> postCondJsonBodies 
	private String requestName
	private int declarationCounter
	
	def CharSequence InitJsonVariables(Test test){
		postCondJsonBodies = new ArrayList
		declarationCounter = 0
		'''
		«initJsonHelper»
		«initDefaultGen»
		«test.customGen»
		«test.compileJsonVaribles»
		'''
	}
	
	private def CharSequence compileJsonVaribles(Test test){
		for (request : test.requests) {
			if (request.postconditions !== null){
				requestName = request.name
				request.postconditions.compilePostCondition
			}
		}
		'''
		«FOR defi : QCUtils.filterbyJsonDefinition(test.definitions)»
		let «QCNames.JsonDef(defi.name)» () = fromJsonToStr («QCJsonHelper.compileJson(defi.json)»)
		«ENDFOR»
		«FOR request : test.requests»
			«IF request.action.value !== null»
				«var json = request.action.value.compileJson»
				«IF json.length > 0»
					let «QCNames.LocalStateJsonDef(request.name)» () = fromJsonToStr («json»)
				«ENDIF»
			«ENDIF»
			«IF request.body !== null»
				«var json = request.body.value.compileJson»
				«IF json.length > 0»
					let «QCNames.LocalBodyJsonDef(request.name)» () = fromJsonToStr («json»)
				«ENDIF»
			«ENDIF»
		«ENDFOR»	
		«FOR declarationBody : postCondJsonBodies»
			let «declarationBody»
		«ENDFOR»
		'''
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
	
	private def dispatch CharSequence compileJson(Json json){
		'''«QCJsonHelper.compileJson(json)»'''
		
	}
	private def dispatch CharSequence compileJson(JsonDefRef json){
		''''''
	}
	
	def dispatch Object compilePostCondition(PostConjunction and) {
		and.left.compilePostCondition 
		and.right.compilePostCondition
	}
	
	def dispatch Object compilePostCondition(PostDisjunction or) {
		or.left.compilePostCondition
		or.right.compilePostCondition
	}
	
	def dispatch Object compilePostCondition(CodeCondition condition) {
		
	}
	
	def dispatch Object compilePostCondition(BodyCondition condition) {
		if(condition.requestValue.body !== null){
			declarationCounter++
		 	var defDeclaration =  QCNames.LocalPostConditionJsonDef(requestName) + declarationCounter + "() = fromJsonToStr (" + QCJsonHelper.compileJson(condition.requestValue.body) + ")"
		 	postCondJsonBodies.add(defDeclaration)
		} 
	}
	

	
}