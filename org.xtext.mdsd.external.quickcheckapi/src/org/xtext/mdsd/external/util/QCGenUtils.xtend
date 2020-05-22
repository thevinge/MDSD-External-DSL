package org.xtext.mdsd.external.util

import java.util.HashMap
import org.xtext.mdsd.external.quickCheckApi.Generator
import org.xtext.mdsd.external.quickCheckApi.IntGen
import org.xtext.mdsd.external.quickCheckApi.IntGenValue
import org.xtext.mdsd.external.quickCheckApi.NestedGen
import org.xtext.mdsd.external.quickCheckApi.OneOfGen
import org.xtext.mdsd.external.quickCheckApi.StringGenValue
import java.util.HashSet

class QCGenUtils {

	enum GenType {
		Text,
		Int,
		Mixed
	}

	def static GenType getGeneratorType(Generator generator) {
		generator.method.compile
	}

	private static def  dispatch GenType compile(OneOfGen method) {
		val foundTypes = new HashSet
		for (value : method.values) {
			foundTypes.add(value.compileType)
		}

		if (foundTypes.size > 1) {
			return GenType.Mixed
		} else {
			if (foundTypes.contains(GenType.Mixed)) {
				return GenType.Mixed
			} else if (foundTypes.contains(GenType.Text)) {
				return GenType.Text
			} else if (foundTypes.contains(GenType.Int)) {
				return GenType.Int
			}
		}
	}

	private static def dispatch GenType compile(IntGen method) {
		GenType.Int
	}

	private static def dispatch GenType compileType(StringGenValue genValue) {
		GenType.Text
	}

	private static def dispatch GenType compileType(IntGenValue genValue) {
		GenType.Int
	}

	private static def dispatch GenType compileType(NestedGen genValue) {
		genValue.value.generatorType
	}
}
