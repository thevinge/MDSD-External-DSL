package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.CustomValue
import org.xtext.mdsd.external.quickCheckApi.RandomStringGen
import org.xtext.mdsd.external.quickCheckApi.IntGen
import org.xtext.mdsd.external.quickCheckApi.NameStringGen
import org.xtext.mdsd.external.quickCheckApi.ExcludeValue
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.IdentifierValue

class QCJsonHelper {
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
		''''''
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
					 
	
	
	
	
//	def static dispatch boolean isExclusionJson(JsonDefRef json){
//		json.ref.json.isExclusionJson
//	}
//	
//	def static dispatch boolean isExclusionJson(Json json){
//		json.data.isExclusionJson
//	}
//	
//	def static dispatch boolean isExclusionJson(JsonObject json){
//		for (pair : json.jsonPairs) {
//			if (pair.isExclusionJson){
//				return true
//			}
//		}
//		false
//	}
//	
//	def static dispatch boolean isExclusionJson(JsonList json){
//		for (value : json.jsonValues) {
//			if (value.isExclusionJson){
//				return true
//			}
//		}
//		false
//	}
//	
//	def static dispatch boolean isExclusionJson(JsonPair json){
//		json.value.isExclusionJson
//	}
//	
//	def static dispatch boolean isExclusionJson(IntValue json){
//		false
//	}
//	
//	def static dispatch boolean isExclusionJson(StringValue json){
//		false
//	}
//	
//	def static dispatch boolean isExclusionJson(NestedJsonValue json){
//		json.value.isExclusionJson
//	}
//	
//	def static dispatch boolean isExclusionJson(ListJsonValue json){
//		json.value.isExclusionJson
//	}
//	
//	
//	def static dispatch boolean isExclusionJson(CustomValue json){
//		json.value.isExclusionJson
//	}
//	
//	def static dispatch boolean isExclusionJson(RandomStringGen gen){
//		false
//	}
//	
//	def static dispatch boolean isExclusionJson(IntGen gen){
//		false
//	}
//	
//	def static dispatch boolean isExclusionJson(NameStringGen gen){
//		false
//	}
//	
//	def static dispatch boolean isExclusionJson(ExcludeValue gen){
//		true
//	}
//	
//	def static dispatch boolean isExclusionJson(ReuseValue gen){
//		false
//	}
//	
//	def static dispatch boolean isExclusionJson(IdentifierValue gen){
//		false
//	}
}