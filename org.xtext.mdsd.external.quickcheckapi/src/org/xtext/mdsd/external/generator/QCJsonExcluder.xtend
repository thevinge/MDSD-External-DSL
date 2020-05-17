package org.xtext.mdsd.external.generator

import java.util.ArrayList
import org.xtext.mdsd.external.quickCheckApi.CustomValue
import org.xtext.mdsd.external.quickCheckApi.ExcludeValue
import org.xtext.mdsd.external.quickCheckApi.IdentifierValue
import org.xtext.mdsd.external.quickCheckApi.IntGen
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.NameStringGen
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.RandomStringGen
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.StringValue

class QCJsonExcluder {
	
	private ArrayList<String> exclusionKeys;
	def static CharSequence InitJsonExcluder(){
		'''
		let jsonCleanup json = let ite1 =  global_replace (Str.regexp "{,") "{" json in
		                let ite2 = global_replace (Str.regexp ",}") "}" ite1 in  
		                let ite3 = global_replace (Str.regexp ",]") "]" ite2 in
		                  global_replace (Str.regexp ",,") "," ite3
		
		let excluder mem lst = List.mem mem lst
		
		let jsonExcluder lst json = let jsonlist = Util.to_assoc json in
		    let rec jsonIterate st json = match json with
		      | [] -> st
		      | head::rest ->
		        let rec pairIterate (k,v) = if excluder k lst then "" else  "\"" ^ k ^ "\":" ^ match v with
		          | `Assoc a -> st ^ "{" ^ jsonIterate st a ^ "}";
		          | `Bool b -> st ^ (string_of_bool b); 
		          | `Float f -> st ^  (string_of_float f) ^ "0" ;
		          | `Int i -> st ^ (string_of_int i);
		          | `List jl -> 
		            let rec listIterate l = match l with
		            | [] -> st
		            | a::innerRest -> match a with
		              | `String s -> st ^ "\"" ^ s ^ "\"" ^ "," ^  listIterate innerRest;
		              | `Int i -> st ^  "," ^  (string_of_int i) ^ listIterate innerRest;
		              | `Float f -> st ^  "," ^  (string_of_float f) ^ "0" ^ listIterate innerRest;
		              | `Null -> st ^ "null" ^ listIterate innerRest;
		              | `Assoc a -> st ^ "," ^  "{" ^ jsonIterate st a ^ listIterate innerRest ^ "}";
		              | `Bool b -> st ^ string_of_bool (b) ^  "," ^  listIterate innerRest;
		              | `List jla -> st  ^  "[" ^ listIterate jla ^ listIterate innerRest ^ "]";
		            in  st ^ "[" ^ (listIterate jl) ^ "]" ;
		          | `Null -> st ^"null";
		          | `String s -> st ^ "\"" ^ s ^ "\""
		  in jsonCleanup (st ^ "," ^ (pairIterate head) ^ (jsonIterate st rest))
		  in  let res = ("{" ^ jsonIterate "" jsonlist ^ "}" ) in jsonCleanup res;;		
		'''
		
	}
	
	def CharSequence compileJsonExclusionList(Json json){
		exclusionKeys = new ArrayList
		json.data.compileExclusionJson
		'''[«FOR key : exclusionKeys SEPARATOR ";"»"«key»"«ENDFOR»]'''	
	}
	
	private def dispatch void compileExclusionJson(JsonObject json){
		for (pair : json.jsonPairs) {
			pair.compileExclusionJson
		}
		
	}
	
	private def dispatch void compileExclusionJson(JsonList json){
		for (value : json.jsonValues) {
			value.compileExclusionJson
		}
		
	}
	
	private def dispatch void compileExclusionJson(JsonPair json){
		if(json.value instanceof CustomValue){
			if ((json.value as CustomValue).value instanceof ExcludeValue){
				exclusionKeys.add (json.key)
			} 
		}
		json.value.compileExclusionJson
	}
	

	
	private def dispatch void compileExclusionJson(NestedJsonValue json){
		json.value.compileExclusionJson
	}
	
	private def dispatch void compileExclusionJson(ListJsonValue json){
		json.value.compileExclusionJson
	}
	
	
	private def dispatch void compileExclusionJson(CustomValue json){
		json.value.compileExclusionJson
	}
	
	private def dispatch void compileExclusionJson(RandomStringGen gen){}
	private def dispatch void compileExclusionJson(IntGen gen){}
	private def dispatch void compileExclusionJson(NameStringGen gen){}
	private def dispatch void compileExclusionJson(ExcludeValue gen){}
	private def dispatch void compileExclusionJson(ReuseValue gen){}
	private def dispatch void compileExclusionJson(IdentifierValue gen){}
	private def dispatch void compileExclusionJson(IntValue json){}
	private def dispatch void compileExclusionJson(StringValue json){}

}