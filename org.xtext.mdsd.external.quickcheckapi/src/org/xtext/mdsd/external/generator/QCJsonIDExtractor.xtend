package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.CustomValue
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
import org.xtext.mdsd.external.quickCheckApi.NestedJsonDef
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.RandomStringGen
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.StringValue

class QCJsonIDExtractor {
		
	private static String idKey
	def static CharSequence InitExtractIdImpl(){
		'''
        let extractIdFromContent id json = jsonElementExtractor id json
		'''
	}
	
	def static dispatch String compileJsonID(JsonDefRef json){
		idKey = ""
		json.ref.json.compileJsonID
		idKey
	}
	
	def static dispatch String compileJsonID(Json json){
		idKey = ""
		json.data.extractJsonID
		idKey
	}
	
	def static dispatch boolean extractJsonID(JsonObject json){
		for (pair : json.jsonPairs) {
			if (pair.extractJsonID){
				return true
			}
		}
	}
	
	def static dispatch boolean extractJsonID(JsonList json){
		for (value : json.jsonValues) {
			if (value.extractJsonID){
				return true
			}
		}
		false
	}
	
	def static dispatch boolean extractJsonID(JsonPair json){
		if (json.value.extractJsonID){
			idKey.empty? idKey = json.key.value : idKey = idKey
			return true
		} else {
			false
		}
		
	}
	
	def static dispatch boolean extractJsonID(IntValue json){
		false
	}
	
	def static dispatch boolean extractJsonID(StringValue json){
		false
	}
	
	def static dispatch boolean extractJsonID(NestedJsonValue json){
		json.value.extractJsonID
	}
	
	def static dispatch boolean extractJsonID(NestedJsonDef json){
		(json?.value?.json.compileJsonID.length > 0)
	}
	
	def static dispatch boolean extractJsonID(ListJsonValue json){
		json.value.extractJsonID
	}
	
	
	def static dispatch boolean extractJsonID(CustomValue json){
		json.value.extractJsonID
	}
	
	def static dispatch boolean extractJsonID(RandomStringGen value){
		false
	}
	
	def static dispatch boolean extractJsonID(IntGen value){
		false
	}
	
	def static dispatch boolean extractJsonID(NameStringGen gen){
		false
	}
	
	def static dispatch boolean extractJsonID(ExcludeValue value){
		false
	}
	
	def static dispatch boolean extractJsonID(ReuseValue value){
		false
	}
	
	def static dispatch boolean extractJsonID(IdentifierValue value){
		true
	}
}
	
	