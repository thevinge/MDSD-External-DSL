package org.xtext.mdsd.external.util

import java.util.HashMap
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
import org.xtext.mdsd.external.quickCheckApi.NameStringGen
import org.xtext.mdsd.external.quickCheckApi.NestedJsonDef
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.StringValue

class QCJsonReuse {
	
	public static HashMap<String,String> reuseKeys
	
	
	def static void resetKeys(){
		reuseKeys = new HashMap
	}
	
	
	def static dispatch boolean isReuseJson(JsonDefRef json){
		resetKeys
		json.ref.json.compileIsReuseJson
	}
	
	def static dispatch boolean isReuseJson(Json json){
		resetKeys
		json.data.compileIsReuseJson
	}
	
	
	def static dispatch boolean compileIsReuseJson(JsonDefRef json){
		
		json.ref.json.compileIsReuseJson
	}
	
	def static dispatch boolean compileIsReuseJson(Json json){
		
		json.data.compileIsReuseJson
	}
	
	
	def static dispatch boolean compileIsReuseJson(JsonObject json){
		var result = false
		for (pair : json.jsonPairs) {
			if (pair.compileIsReuseJson){

				result = true
			}
		}
		result
	}
	
	def static dispatch boolean compileIsReuseJson(JsonList json){
		for (value : json.jsonValues) {
			if (value.compileIsReuseJson){
				return true
			}
		}
		false
	}
	
	def static dispatch boolean compileIsReuseJson(JsonPair json){
		if (json.value.compileIsReuseJson){
			var pairValue = json.value
			if (pairValue instanceof CustomValue){
				var custom = pairValue.value
				if (custom instanceof ReuseValue){
					reuseKeys.put(json.key.value, custom.key.value)
				}
			}
			
			return true
		} else {
			false
		}
		
	}
	
	def static dispatch boolean compileIsReuseJson(IntValue json){
		false
	}
	
	def static dispatch boolean compileIsReuseJson(StringValue json){
		false
	}
	
	def static dispatch boolean compileIsReuseJson(NestedJsonValue json){
		json.value.compileIsReuseJson
	}
	
	def static dispatch boolean compileIsReuseJson(ListJsonValue json){
		json.value.compileIsReuseJson
	}
	
	def static dispatch boolean compileIsReuseJson(NestedJsonDef json){
		json.value.json.compileIsReuseJson
	}
	
	def static dispatch boolean compileIsReuseJson(CustomValue json){
		json.value.compileIsReuseJson
	}
	
	def static dispatch boolean compileIsReuseJson(NameStringGen gen){
		false
	}
	
	def static dispatch boolean compileIsReuseJson(GenRef gen){
		false
	}
	
	def static dispatch boolean compileIsReuseJson(ExcludeValue value){
		false
	}
	
	def static dispatch boolean compileIsReuseJson(ReuseValue value){
		true
	}
	
	def static dispatch boolean compileIsReuseJson(IdentifierValue value){
		false
	}
	
	
	
	
	
	
	
}
