package org.xtext.mdsd.external.generator

import java.util.ArrayList
import static extension org.eclipse.xtext.EcoreUtil2.*
import org.xtext.mdsd.external.quickCheckApi.BodyCondition
import org.xtext.mdsd.external.quickCheckApi.CodeCondition
import org.xtext.mdsd.external.quickCheckApi.CustomValue
import org.xtext.mdsd.external.quickCheckApi.ExcludeValue
import org.xtext.mdsd.external.quickCheckApi.GenRef
import org.xtext.mdsd.external.quickCheckApi.IdentifierValue
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.NestedJsonDef
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.PostConjunction
import org.xtext.mdsd.external.quickCheckApi.PostDisjunction
import org.xtext.mdsd.external.quickCheckApi.Postproposition
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.util.QCGenUtils
import org.xtext.mdsd.external.util.QCNames
import org.xtext.mdsd.external.util.QCTypeInfer
import org.xtext.mdsd.external.util.QCTypeInfer.JsonValueType

import static extension org.xtext.mdsd.external.generator.QCGenerator.*
import static extension org.xtext.mdsd.external.util.QCJsonReuse.*
import static extension org.xtext.mdsd.external.generator.QCJsonIDExtractor.*
class QCJsonCompiler {
	
	
	
	def static dispatch CharSequence compileJson(JsonDefRef json){
		
		json.ref.json.compileJson.trim
	}
	
	def static dispatch CharSequence compileJson(Json json){
		json.data.compileJson.trim
	}
	
	def static dispatch CharSequence compileJson(JsonObject json){
		'''`Assoc[«FOR pair : json.jsonPairs SEPARATOR ";"»«pair.compileJson»«ENDFOR»]'''
	}
	
	def static dispatch CharSequence compileJson(JsonList json){
		'''`List[«FOR value : json.jsonValues SEPARATOR ";"»«value.compileJson»«ENDFOR»]'''
	}
	
	def static dispatch CharSequence compileJson(JsonPair json){
		if(json.value instanceof CustomValue){
			if ((json.value as CustomValue).value instanceof ExcludeValue || (json.value as CustomValue).value instanceof IdentifierValue){
				return ''''''
			} 
		}
		'''("«json.key.value»",«json.value.compileJson»)'''
	}
	
	def static dispatch CharSequence compileJson(IntValue json){
		'''`Int «json.value»'''
	}
	
	def static dispatch CharSequence compileJson(StringValue json){
		'''`String "«json.value»"'''
	}
	
	def static dispatch CharSequence compileJson(NestedJsonValue json){
		'''«json.value.compileJson»'''
	}
	
	def static dispatch CharSequence compileJson(ListJsonValue json){
		'''«json.value.compileJson»'''
	}
	
	def static dispatch CharSequence compileJson(NestedJsonDef json){
		'''«json.value.json.compileJson»'''
	}
	
	
	def static dispatch CharSequence compileJson(CustomValue json){
		'''«json.value.compileCustomValue»'''
	}
	
	def static dispatch CharSequence compileCustomValue(ExcludeValue gen){
		''''''
	}
	
	def static dispatch CharSequence compileCustomValue(GenRef gen){
		switch (QCGenUtils.getGeneratorType(gen.ref.gen)) {
			case Int: {
				return '''`Int («gen.ref.name» ())'''
			}
			case Text: {
				return '''`String («gen.ref.name» ())'''
			}
			case Mixed: {
				return '''`String («gen.ref.name» ())'''
			}
			default: {
			}
		}
	}
	
	def static dispatch CharSequence compileCustomValue(ReuseValue value){ 
		val pair = value.getContainerOfType(JsonPair)
		
		switch (QCTypeInfer.inferType(value)) {
			case JsonValueType.STRING: {
				'''`String (Hashtbl.find tbl "«pair.key.value»")'''
			}
			case JsonValueType.INT: {
				'''`Int (int_of_string (Hashtbl.find tbl "«pair.key.value»"))'''
			}
			default: {
				'''`String (Hashtbl.find tbl "«pair.key.value»")'''
			}
		}
		
	}
	
	def static dispatch CharSequence compileCustomValue(IdentifierValue gen){
		''''''
	}
	
	def static CharSequence trim(CharSequence json){
		json.toString.replaceAll("(\\;{2,})",";").replace(",,",",")
					.replace("{;","{")
					.replace("[;","[")
					.replace(";]","]")
					.replace(";}","}")
					
	}






	private static ArrayList<QCJsonDef> jsonBodies
	private static int declarationCounter
	
	def static ArrayList<QCJsonDef> compileConditionBodies(Postproposition cond){
		jsonBodies = new ArrayList
		declarationCounter = 0
		cond.compilePostCondition
		jsonBodies
	}

	private def static dispatch void compilePostCondition(PostConjunction and) {
		and.left.compilePostCondition 
		and.right.compilePostCondition
	}
	
	private def static dispatch void compilePostCondition(PostDisjunction or) {
		or.left.compilePostCondition
		or.right.compilePostCondition
	}
	
	private def static dispatch void compilePostCondition(CodeCondition condition) {
		
	}
	
	private def static dispatch void compilePostCondition(BodyCondition condition) {
		if(condition.requestValue.body !== null){
			declarationCounter++  
			var QCJsonDef jsondef = new QCJsonDef(QCNames.LocalPostConditionJsonDef() + declarationCounter, defType.dtCondition)
		 	jsondef.processedJson = condition.requestValue.body.compileJson
		 	jsondef.generators = condition.requestValue.body.getAllGenerators
		 	
		 	jsondef.reuseVars = condition.requestValue.body.reuseKeys
		 	jsondef.IdentifierKey = condition.requestValue.body.compileJsonID.toString
		 	jsonBodies.add(jsondef)
		} 
	}				 
}