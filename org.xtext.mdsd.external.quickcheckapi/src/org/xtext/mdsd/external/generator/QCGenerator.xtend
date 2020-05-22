package org.xtext.mdsd.external.generator

import java.util.HashMap
import org.xtext.mdsd.external.quickCheckApi.CustomValue
import org.xtext.mdsd.external.quickCheckApi.ExcludeValue
import org.xtext.mdsd.external.quickCheckApi.GenRef
import org.xtext.mdsd.external.quickCheckApi.Generator
import org.xtext.mdsd.external.quickCheckApi.IdentifierValue
import org.xtext.mdsd.external.quickCheckApi.IntGen
import org.xtext.mdsd.external.quickCheckApi.IntGenValue
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonDefRef
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.JsonRef
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.NameStringGen
import org.xtext.mdsd.external.quickCheckApi.NestedGen
import org.xtext.mdsd.external.quickCheckApi.NestedJsonDef
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.OneOfGen
import org.xtext.mdsd.external.quickCheckApi.ReuseValue
import org.xtext.mdsd.external.quickCheckApi.StringGen
import org.xtext.mdsd.external.quickCheckApi.StringGenValue
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.util.QCGenUtils
import org.xtext.mdsd.external.util.QCGenUtils.GenType

class QCGenerator {

	private static GenType generatorReturnType

	def static CharSequence compileGenerator(Generator generator) {
		generatorReturnType = QCGenUtils.getGeneratorType(generator)
		generator.compile
	}

	private static def CharSequence compile(Generator generator) {

		if (generator.method instanceof IntGen) {
			switch (generatorReturnType) {
				case Int: {
					return '''(Gen.generate1 («generator.method.compileMethod»))'''
				}
				case Text: {
					return '''(Gen.generate1 («generator.method.compileMethod»))'''
				}
				case Mixed: {
					return '''string_of_int(Gen.generate1 («generator.method.compileMethod»))'''
				}
				default: {
				}
			}
		}
		return '''(Gen.generate1 («generator.method.compileMethod»))'''
	}

	private static def dispatch CharSequence compileMethod(OneOfGen method) {
		'''Gen.oneofl [«FOR value : method.values SEPARATOR ";"»«value.compileValue»«ENDFOR»]'''
	}

	private static def dispatch CharSequence compileMethod(IntGen method) {
		if (method.from === 0 && method.to === 0) {
			'''Gen.int'''
		} else {
			if (method.from > method.to) {
				'''(Gen.int_range «method.to» «method.from»)'''
			} else {
				'''(Gen.int_range «method.from» «method.to»)'''
			}
			
		}
	}
	
	private static def dispatch CharSequence compileMethod(StringGen method) {
		'''(Gen.string_size (Gen.int_range 3 4))'''
	}

	private static def dispatch CharSequence compileValue(StringGenValue genValue) {
		'''"«genValue.value»"'''
	}

	private static def dispatch CharSequence compileValue(IntGenValue genValue) {
		switch (generatorReturnType) {
			case Int: {
				return '''«genValue.value»'''
			}
			case Text: {
				return '''"«genValue.value»"'''
			}
			case Mixed: {
				return '''"«genValue.value»"'''
			}
			default: {
			}
		}

	}

	private static def dispatch CharSequence compileValue(NestedGen genValue) {
		'''«genValue.value.compile»'''
	}

	private static HashMap<String, String> generators

	def static getAllGenerators(JsonRef json) {
		generators = new HashMap
		json?.iterateJson
		generators
	}

	private def static dispatch void iterateJson(JsonDefRef json) {
		json.ref?.json?.iterateJson
	}

	private def static dispatch void iterateJson(Json json) {
		json.data?.iterateJson
	}

	private def static dispatch void iterateJson(JsonObject json) {
		json.jsonPairs?.forEach[it?.iterateJson]
	}

	private def static dispatch void iterateJson(JsonList json) {
		json.jsonValues?.forEach[it?.iterateJson]
	}

	private def static dispatch void iterateJson(JsonPair json) {
		json.value?.iterateJson
	}

	private def static dispatch void iterateJson(NestedJsonValue json) {
		json.value?.iterateJson
	}

	private def static dispatch void iterateJson(NestedJsonDef json) {
		json.value?.json?.iterateJson
	}

	private def static dispatch void iterateJson(ListJsonValue json) {
		json.value?.iterateJson
	}

	private def static dispatch void iterateJson(CustomValue json) {
		json.value.iterateJson
	}

	private def static dispatch void iterateJson(GenRef value) {
		val name = value.ref.name
		val gen = value.ref.gen.compileGenerator.toString
		generators.put(name, gen)
	}

	private def static dispatch void iterateJson(NameStringGen value) {}

	private def static dispatch void iterateJson(ExcludeValue value) {}

	private def static dispatch void iterateJson(ReuseValue value) {}

	private def static dispatch void iterateJson(IdentifierValue value) {}

	private def static dispatch void iterateJson(IntValue value) {}

	private def static dispatch void iterateJson(StringValue value) {}

}
