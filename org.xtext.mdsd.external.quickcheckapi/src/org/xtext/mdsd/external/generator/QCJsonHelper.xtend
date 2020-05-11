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

class QCJsonHelper {
	def static dispatch CharSequence compileJson(JsonDefRef json){
		json.ref.json.compileJson
	}
	
	def static dispatch CharSequence compileJson(Json json){
		json.data.compileJson
	}
	
	def static dispatch CharSequence compileJson(JsonObject json){
		'''`Assoc[«FOR pair : json.jsonPairs SEPARATOR ";"»«pair.compileJson»«ENDFOR»]'''
	}
	
	def static dispatch CharSequence compileJson(JsonList json){
		'''`List[«FOR value : json.jsonValues SEPARATOR ";"»«value.compileJson»«ENDFOR»]'''
	}
	
	def static dispatch CharSequence compileJson(JsonPair json){
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
		''''''
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
}