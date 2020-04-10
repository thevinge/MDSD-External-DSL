package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test

class QCNextState {
	
	def initNext_State(Test test ) {
		'''
		let next_state cmd state = match cmd with
		    | Get ix -> state
		    | Create -> state@["{\"name\": \"bar\"}"]
		    | Delete ix -> let pos = getPos ix state in
		                   (* Returns a list of all items except that which is 'item' found above *)
		                   let l = remove_item pos state in
		                   l
		'''
	}
}