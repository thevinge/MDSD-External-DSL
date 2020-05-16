package org.xtext.mdsd.external.generator

import java.util.ArrayList
import org.xtext.mdsd.external.quickCheckApi.IdentifierValue
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.ExcludeValue
import org.xtext.mdsd.external.quickCheckApi.NameStringGen
import org.xtext.mdsd.external.quickCheckApi.IntGen
import org.xtext.mdsd.external.quickCheckApi.RandomStringGen

import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.CustomValue

class QCJsonIDExtractor {
		

	 def static CharSequence InitExtractIdImpl(){
		'''
        let extractIdFromContent id json = jsonElementExtractor id json
		'''
	}
	
	def static dispatch CharSequence compileJsonID(JsonDefRef json){
		
		json.ref.json.compileJsonID.toString.replaceAll("(\\;{1,})","")
	}
	
	def static dispatch CharSequence compileJsonID(Json json){
		json.data.compileJsonID.toString.replaceAll("(\\;{1,})","")
	}
	
	def static dispatch CharSequence compileJsonID(JsonObject json){
		'''«FOR pair : json.jsonPairs SEPARATOR ";"»«pair.compileJsonID»«ENDFOR»'''
	}
	
	def static dispatch CharSequence compileJsonID(JsonList json){
		'''«FOR value : json.jsonValues SEPARATOR ";"»«value.compileJsonID»«ENDFOR»'''
	}
	
	def static dispatch CharSequence compileJsonID(JsonPair json){
		json.value.compileJsonID
	}
	
	def static dispatch CharSequence compileJsonID(IntValue json){
		''''''
	}
	
	def static dispatch CharSequence compileJsonID(StringValue json){
		''''''
	}
	
	def static dispatch CharSequence compileJsonID(NestedJsonValue json){
		'''«json.value.compileJsonID»'''
	}
	
	def static dispatch CharSequence compileJsonID(ListJsonValue json){
		'''«json.value.compileJsonID»'''
	}
	
	
	def static dispatch CharSequence compileJsonID(CustomValue json){
		'''«json.value.compileCustomValue»'''
	}
	
	def static dispatch CharSequence compileCustomValue(RandomStringGen value){
		''''''
	}
	
	def static dispatch CharSequence compileCustomValue(IntGen value){
		''''''
	}
	
	def static dispatch CharSequence compileCustomValue(NameStringGen value){
		''''''
	}
	
	def static dispatch CharSequence compileCustomValue(ExcludeValue value){
		''''''
	}
	
	def static dispatch CharSequence compileCustomValue(ReuseValue value){
		''''''
	}
	
	def static dispatch CharSequence compileCustomValue(IdentifierValue value){
		'''«value.name»'''
	}
}
	
	