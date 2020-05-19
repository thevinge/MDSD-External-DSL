package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.CustomValue
import org.xtext.mdsd.external.quickCheckApi.IntGen
import org.xtext.mdsd.external.quickCheckApi.RandomStringGen
import org.xtext.mdsd.external.quickCheckApi.NameStringGen
import org.xtext.mdsd.external.quickCheckApi.ExcludeValue
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.IdentifierValue
import java.util.HashMap

class QCJsonReuse {
	
	public static HashMap<String,String> reuseKeys
	
	
	def static void resetKeys(){
		reuseKeys = new HashMap
	}
	
	
	def static dispatch boolean isReuseJson(JsonDefRef json){
		resetKeys
		json.ref.json.isReuseJson
	}
	
	def static dispatch boolean isReuseJson(Json json){
		resetKeys
		json.data.isReuseJson
	}
	
	def static dispatch boolean isReuseJson(JsonObject json){
		var result = false
		for (pair : json.jsonPairs) {
			if (pair.isReuseJson){

				result = true
			}
		}
		result
	}
	
	def static dispatch boolean isReuseJson(JsonList json){
		for (value : json.jsonValues) {
			if (value.isReuseJson){
				return true
			}
		}
		false
	}
	
	def static dispatch boolean isReuseJson(JsonPair json){
		if (json.value.isReuseJson){
			var pairValue = json.value
			if (pairValue instanceof CustomValue){
				var custom = pairValue.value
				if (custom instanceof ReuseValue){
					reuseKeys.put(json.key, custom.name)
				}
			}
			
			return true
		} else {
			false
		}
		
	}
	
	def static dispatch boolean isReuseJson(IntValue json){
		false
	}
	
	def static dispatch boolean isReuseJson(StringValue json){
		false
	}
	
	def static dispatch boolean isReuseJson(NestedJsonValue json){
		json.value.isReuseJson
	}
	
	def static dispatch boolean isReuseJson(ListJsonValue json){
		json.value.isReuseJson
	}
	
	
	def static dispatch boolean isReuseJson(CustomValue json){
		json.value.isReuseJson
	}
	
	def static dispatch boolean isReuseJson(RandomStringGen value){
		false
	}
	
	def static dispatch boolean isReuseJson(IntGen value){
		false
	}
	
	def static dispatch boolean isReuseJson(NameStringGen gen){
		false
	}
	
	def static dispatch boolean isReuseJson(ExcludeValue value){
		false
	}
	
	def static dispatch boolean isReuseJson(ReuseValue value){
		true
	}
	
	def static dispatch boolean isReuseJson(IdentifierValue value){
		false
	}
	
	
	
	
	
	
	
}