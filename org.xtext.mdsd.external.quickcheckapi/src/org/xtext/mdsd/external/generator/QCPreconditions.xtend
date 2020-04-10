package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test

class QCPreconditions {
	def initPreconditions(Test test ) {
		'''
		let precond cmd state = match cmd with
		    | Get ix -> List.length state > 0 
		    | Delete ix-> List.length state > 0
		    | Create -> true
		'''
	}}