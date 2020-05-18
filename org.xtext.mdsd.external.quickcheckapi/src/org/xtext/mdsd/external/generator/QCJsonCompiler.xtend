package org.xtext.mdsd.external.generator

import java.util.ArrayList
import org.xtext.mdsd.external.quickCheckApi.BodyCondition
import org.xtext.mdsd.external.quickCheckApi.CodeCondition
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.CustomValue
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.ExcludeValue
import org.xtext.mdsd.external.quickCheckApi.IdentifierValue
import org.xtext.mdsd.external.quickCheckApi.IntGen
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.NameStringGen
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.NoAction
import org.xtext.mdsd.external.quickCheckApi.PostConjunction
import org.xtext.mdsd.external.quickCheckApi.PostDisjunction
import org.xtext.mdsd.external.quickCheckApi.Postproposition
import org.xtext.mdsd.external.quickCheckApi.RandomStringGen
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.quickCheckApi.UpdateAction

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
		'''("«json.key»",«json.value.compileJson»)'''
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
	
	
	def static dispatch CharSequence compileJson(CustomValue json){
		'''«json.value.compileCustomValue»'''
	}
	
	def static dispatch CharSequence compileCustomValue(RandomStringGen gen){
		'''`String (defaultStringGen())'''
	}
	
	def static dispatch CharSequence compileCustomValue(IntGen gen){
		''''''
	}
	
	def static dispatch CharSequence compileCustomValue(NameStringGen gen){
		'''`String (defaultNameGen ())'''
	}
	
	def static dispatch CharSequence compileCustomValue(ExcludeValue gen){
		''''''
	}
	
	def static dispatch CharSequence compileCustomValue(ReuseValue gen){
		'''`String (Hashtbl.find tbl "«gen.name»")'''
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
		 	jsondef.processedJson = QCJsonCompiler.compileJson(condition.requestValue.body)
		 	
		 	QCJsonReuse.isReuseJson(condition.requestValue.body)
		 	jsondef.reuseVars = QCJsonReuse.reuseKeys
		 	jsondef.IdentifierKey = QCJsonIDExtractor.compileJsonID(condition.requestValue.body).toString
		 	jsonBodies.add(jsondef)
		} 
	}






	def static dispatch CharSequence compileJsonAction(CreateAction action){
		action.value.compileJson
	}
	
	def static dispatch CharSequence compileJsonAction(UpdateAction action){
		action.value.compileJson
	}
	
	def static dispatch CharSequence compileJsonAction(DeleteAction action){
		action.value.compileJson
	}
	def static dispatch CharSequence compileJsonAction(NoAction action){
		''''''
	}




				 
}